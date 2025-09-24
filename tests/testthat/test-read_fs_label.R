# Helper function to create a mock FreeSurfer .label file content
mock_label_content <- function(
  num_vertices = 5,
  comment = "#!ascii label",
  has_warning = FALSE
) {
  content <- c(comment)

  # If has_warning is TRUE, make n_lines not match actual lines
  if (has_warning) {
    content <- c(content, as.character(num_vertices + 1)) # Claim more lines than actual
  } else {
    content <- c(content, as.character(num_vertices))
  }

  # Generate mock vertex data
  for (i in 0:(num_vertices - 1)) {
    # Format: vertex_num r_coord a_coord s_coord value
    # Ensure coordinates and value are numeric
    line <- sprintf(
      "%d %.6f %.6f %.6f %.6f",
      i, # vertex_num
      round(runif(1, -100, 100), 6), # r_coord
      round(runif(1, -100, 100), 6), # a_coord
      round(runif(1, -100, 100), 6), # s_coord
      round(runif(1, 0, 10), 6) # value
    )
    content <- c(content, line)
  }
  return(content)
}

# --- Test Cases for ---

test_that("reads a valid label file correctly", {
  # Create a mock label file
  mock_label_content <- mock_label_content(num_vertices = 3)

  withr::with_tempfile("mock_label", fileext = ".label", {
    writeLines(mock_label_content, con = mock_label)

    result <- read_fs_label(mock_label)

    # Assertions on the structure and content of the returned data.frame
    expect_s3_class(result, "data.frame")
    expect_equal(ncol(result), 5)
    expect_equal(
      names(result),
      c("vertex_num", "r_coord", "a_coord", "s_coord", "value")
    )
    expect_equal(nrow(result), 3)

    # Check data types (they should be numeric after conversion)
    expect_type(result$vertex_num, "character") # Initially character from readLines
    expect_type(result$r_coord, "character")
    # Note: The function returns character columns as it uses strsplit and do.call("rbind", ss).
    # If numeric conversion is expected, it should be done within read_fs_label.
    # For now, we test based on its current implementation.

    # Check the comment attribute
    expect_equal(attr(result, "comment"), mock_label_content[1])
  })

  skip_if_no_freesurfer()

  crt <- file.path(
    fs_subj_dir(),
    "bert",
    "label",
    "lh.cortex.label"
  )
  result <- read_fs_label(crt)

  expect_equal(nrow(result), 125558)
  expect_equal(result$vertex_num[1], "0")
  expect_equal(result$r_coord[1], "-11.127")
  expect_equal(result$value[2], "0.0000000000")
  expect_equal(
    names(result),
    c("vertex_num", "r_coord", "a_coord", "s_coord", "value")
  )
})

test_that("handles empty label file (minimum valid structure)", {
  mock_label_content <- c("#!ascii label", "0") # Comment and 0 lines

  withr::with_tempfile(
    "mock_empty_label",
    fileext = ".label",
    {
      writeLines(
        mock_label_content,
        con = mock_empty_label
      )

      expect_error(
        result <- read_fs_label(mock_empty_label),
        "no valid label content."
      )
    }
  )
})

test_that("warns if number of lines does not match specification", {
  mock_label_content <- mock_label_content(
    num_vertices = 2,
    has_warning = TRUE
  )

  withr::with_tempfile("mock_label_warning", fileext = ".label", {
    writeLines(mock_label_content, con = mock_label_warning)

    expect_warning(
      result <- read_fs_label(mock_label_warning),
      "Number of lines do not match file specification!"
    )

    # Still expect it to parse the available lines
    expect_equal(nrow(result), 2)
  })
})

test_that("throws error for non-existent file", {
  non_existent_file <- file.path(tempdir(), "non_existent.label")
  expect_error(
    read_fs_label(non_existent_file),
    "does not exist"
  )
})

test_that("handles leading/trailing spaces in lines", {
  # Create content with extra spaces
  content_with_spaces <- c(
    "#!ascii label",
    "2",
    "  0   1.234567   -8.765432   99.000000   0.500000  ",
    " 1   -2.345678   7.654321   -88.000000   1.000000"
  )
  withr::with_tempfile("mock_label_spaces", fileext = ".label", {
    writeLines(content_with_spaces, con = mock_label_spaces)

    result <- read_fs_label(mock_label_spaces)

    expect_equal(nrow(result), 2)
    expect_equal(result$vertex_num[1], "0")
    expect_equal(result$r_coord[1], "1.234567")
    expect_equal(result$value[2], "1.000000")
  })
})
