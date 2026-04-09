describe("read_fs_table", {
# Create a temporary file with sample data for testing
mock_stats_table <- function(
  content,
  sep = " ",
  file
) {
  write.table(
    content,
    file = file,
    sep = sep,
    row.names = FALSE,
    col.names = TRUE,
    quote = FALSE
  )
  attr(file, "delimiter") <- sep
  return(file)
}

mock_data <-
  data.frame(
    col1 = c(1, 3),
    col2 = c(2, 4)
  )

it("handles default separator", {
  tempfile <- withr::local_tempfile(fileext = ".txt")
  file <- mock_stats_table(
    mock_data,
    file = tempfile
  )
  expect_message(
    result <- read_fs_table(file),
    regexp = "Successfully read table|Auto-detected separator|Successfully read"
  )
  expect_s3_class(result, "data.frame")
  expect_equal(result, mock_data)

  expect_message(
    result_stats <- read_stats_table(file),
    "Successfully read table: 2 rows, 2 columns"
  )
  expect_equal(result_stats, result)
})

it("handles custom separator", {
  tempfile <- withr::local_tempfile(fileext = ".txt")
  file <- mock_stats_table(
    mock_data,
    sep = "\t",
    file = tempfile
  )
  expect_message(
    result <- read_fs_table(file),
    regexp = "Successfully read table|Auto-detected separator"
  )
  expect_s3_class(result, "data.frame")
  expect_equal(result, mock_data)
})

it("works when header is set to FALSE", {
  tempfile <- withr::local_tempfile(fileext = ".txt")
  file <- mock_stats_table(
    mock_data,
    file = tempfile
  )
  expect_message(
    result <- read_fs_table(file, header = FALSE),
    regexp = "Successfully read table|Auto-detected separator"
  )
  expect_s3_class(result, "data.frame")
  expect_equal(ncol(result), 2)
  expect_equal(nrow(result), 3)
  expect_equal(result$V1, c("col1", 1, 3))
  expect_equal(result$V2, c("col2", 2, 4))
})

it("handles non-existent file gracefully", {
  expect_error(
    read_fs_table("nonexistent_file.txt"),
    "does not exist"
  )
})

it("handles invalid file format gracefully", {
  file <- withr::local_tempfile(fileext = ".txt")
  writeLines("This is not a valid\ntable format, at all\nshould error", file)
  expect_error(
    expect_message(
      read_fs_table(file),
      "Analyzed 3 data lines"
    ),
    "line 2 did not have 2 elements"
  )
})

it("respects additional arguments", {
  tempfile <- withr::local_tempfile(fileext = ".txt")
  file <- mock_stats_table(
    mock_data,
    file = tempfile
  )
  expect_message(
    result <- read_fs_table(
      file,
      stringsAsFactors = TRUE,
      header = FALSE
    ),
    regexp = "Successfully read table|Auto-detected separator"
  )
  expect_true(is.factor(result$V1))
  expect_true(is.factor(result$V2))
})

it("with mocked check_path validates input file", {
  local_mocked_bindings(
    check_path = function(...) {
      fs_abort("Mocked check_path triggered")
    }
  )
  expect_error(
    read_fs_table("dummy.txt"),
    "Mocked check_path triggered"
  )
})

it("warns for unexpected file extension", {
  file <- withr::local_tempfile(fileext = ".xyz")
  writeLines(c("col1\tcol2", "1\t2", "3\t4"), file)

  local_mocked_bindings(
    get_fs_verbosity = function() FALSE
  )

  expect_warning(
    read_fs_table(file, validate_format = TRUE),
    "Unexpected file extension"
  )
})

it("does not warn for valid extensions", {
  file <- withr::local_tempfile(fileext = ".stats")
  writeLines(c("col1\tcol2", "1\t2", "3\t4"), file)

  local_mocked_bindings(
    get_fs_verbosity = function() FALSE
  )

  expect_no_warning(
    read_fs_table(file, validate_format = TRUE)
  )
})

it("skips format validation when validate_format = FALSE", {
  file <- withr::local_tempfile(fileext = ".xyz")
  writeLines(c("col1\tcol2", "1\t2", "3\t4"), file)

  local_mocked_bindings(
    get_fs_verbosity = function() FALSE
  )

  expect_no_warning(
    read_fs_table(file, validate_format = FALSE)
  )
})

it("errors on empty file", {
  file <- withr::local_tempfile(fileext = ".txt")
  writeLines(character(0), file)

  expect_error(
    read_fs_table(file),
    "empty"
  )
})

it("warns when result has zero rows", {
  file <- withr::local_tempfile(fileext = ".txt")
  writeLines("col1\tcol2", file)

  local_mocked_bindings(
    get_fs_verbosity = function() FALSE
  )

  expect_warning(
    read_fs_table(file),
    "empty or contains no data rows"
  )
})

it("warns when result has only one column with non-space separator", {
  file <- withr::local_tempfile(fileext = ".txt")
  writeLines("col1\n1\n2\n3", file)

  local_mocked_bindings(
    get_fs_verbosity = function() FALSE
  )

  expect_warning(
    read_fs_table(file, sep = "\t"),
    "only one column"
  )
})

it("uses delimiter attribute from file if present", {
  file <- withr::local_tempfile(fileext = ".txt")
  writeLines("col1\tcol2\n1\t2\n3\t4", file)
  attr(file, "delimiter") <- "\t"

  local_mocked_bindings(
    get_fs_verbosity = function() FALSE
  )

  result <- read_fs_table(file)
  expect_equal(ncol(result), 2)
})

it("auto-detects tab separator", {
  file <- withr::local_tempfile(fileext = ".txt")
  writeLines("col1\tcol2\n1\t2\n3\t4", file)

  local_mocked_bindings(
    get_fs_verbosity = function() FALSE
  )

  result <- read_fs_table(file)
  expect_equal(ncol(result), 2)
})

it("reads comma-separated file with explicit separator", {
  file <- withr::local_tempfile(fileext = ".csv")
  writeLines(c("col1,col2", "1,2", "3,4"), file)

  local_mocked_bindings(
    get_fs_verbosity = function() FALSE
  )

  result <- read_fs_table(file, sep = ",")
  expect_equal(ncol(result), 2)
})

it("handles files with comment lines", {
  file <- withr::local_tempfile(fileext = ".txt")
  writeLines(c("# comment", "col1\tcol2", "1\t2", "3\t4"), file)

  local_mocked_bindings(
    get_fs_verbosity = function() FALSE
  )

  result <- read_fs_table(file, comment.char = "#")
  expect_equal(ncol(result), 2)
  expect_equal(nrow(result), 2)
})
})
