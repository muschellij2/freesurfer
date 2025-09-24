#' Write Freesurfer annotation file
#'
#' Creates a mock Freesurfer binary annotation file
#' that can be read by the `read_annotation` function.
#' This is useful for testing purposes.
#'
#' @param path Path to the annotation file to be written.
#' @param num_vertices Number of vertices for the mock file.
#' @param include_colortable Logical. Whether to include a color table in the file.
#'
#' @return Nothing. Writes a file at the specified path.
mock_annotation <- function(path, num_vertices, include_colortable = TRUE) {
  ff <- file(path, "wb")
  on.exit(close(ff))

  # Write the number of annotations
  writeBin(as.integer(num_vertices), ff, endian = "big")

  # Generate and write mock vertices and labels
  vertices <- seq_len(num_vertices)
  labels <- sample(1:1000, num_vertices, replace = TRUE)

  # Interleave vertices and labels
  tmp <- as.vector(rbind(vertices, labels))
  writeBin(as.integer(tmp), ff, endian = "big")

  # Include colortable
  if (include_colortable) {
    # Indicate presence of colortable
    writeBin(as.integer(1), ff, endian = "big")

    # Write the number of entries
    num_entries <- 3
    writeBin(as.integer(num_entries), ff, endian = "big")

    # Version information
    version <- 2
    writeBin(as.integer(-version), ff, endian = "big")

    # Write colortable metadata
    writeBin(as.integer(num_entries), ff, endian = "big")
    colortable_name <- "mock_colortable"
    writeBin(as.character(colortable_name), ff, endian = "big")

    writeBin(as.integer(num_entries), ff, endian = "big")

    # Generate and write colortable entries
    for (i in seq_len(num_entries)) {
      # Structure ID
      writeBin(as.integer(i), ff, endian = "big")

      # Mock name of the structure
      struct_name <- paste0("Region_", i)
      writeBin(as.character(struct_name), ff, endian = "big")

      # Random Colors (R, G, B, A)
      R <- sample(0:255, 1)
      G <- sample(0:255, 1)
      B <- sample(0:255, 1)
      A <- 0

      writeBin(as.integer(R), ff, endian = "big")
      writeBin(as.integer(G), ff, endian = "big")
      writeBin(as.integer(B), ff, endian = "big")
      writeBin(as.integer(A), ff, endian = "big")
    }
  } else {
    # Indicate absence of colortable
    writeBin(as.integer(0), ff, endian = "big")
  }
}


test_that("throws an error if file does not exist", {
  nonexistent_path <- tempfile(fileext = ".annot")
  expect_error(
    read_annotation(nonexistent_path),
    "does not exist",
    fixed = TRUE
  )
})

test_that("read_annotation throws an error for a malformed file", {
  temp_file <- withr::local_tempfile(fileext = ".annot")

  # Write random malformed content to the file
  writeBin(as.raw(0), temp_file)

  # Expect error when reading the malformed file
  expect_error(
    read_annotation(temp_file, verbose = FALSE),
    "does not have the expected content"
  )
})

test_that("successfully reads a valid file with colortable", {
  temp_file <- withr::local_tempfile(fileext = ".annot")

  # Create a mock annotation file with colortable
  mock_annotation(
    temp_file,
    num_vertices = 5,
    include_colortable = TRUE
  )

  # Read the annotation file
  result <- read_annotation(temp_file, verbose = FALSE)

  # Verify the structure of the result
  expect_type(result, "list")
  expect_named(result, c("vertices", "label", "colortable"))
  expect_length(result$vertices, 5)
  expect_length(result$label, 5)
  expect_true(nrow(result$colortable) > 0)
  expect_named(
    result$colortable,
    c("label", "R", "G", "B", "A", "code")
  )

  skip_if_no_freesurfer()

  annot_file <- file.path(
    fs_subj_dir(),
    "bert",
    "label",
    "lh.aparc.annot"
  )

  expect_warning(
    result <- read_annotation(annot_file),
    "there may be"
  )

  expect_named(result, c("vertices", "label", "colortable"))
  expect_length(result$vertices, 134814)
  expect_length(result$label, 134814)
  expect_true(is.data.frame(result$colortable))
  expect_equal(ncol(result$colortable), 6)
  expect_equal(nrow(result$colortable), 36)
})

test_that("successfully reads a file without colortable", {
  temp_file <- withr::local_tempfile(fileext = ".annot")

  # Create a mock annotation file without colortable
  mock_annotation(
    temp_file,
    num_vertices = 5,
    include_colortable = FALSE
  )

  # Read the annotation file
  expect_warning(
    result <- read_annotation(temp_file, verbose = TRUE),
    "No colortable in file"
  )

  # Verify the result structure
  expect_type(result, "list")
  expect_named(result, c("vertices", "label", "colortable"))
  expect_length(result$vertices, 5)
  expect_length(result$label, 5)
  expect_equal(nrow(result$colortable), 0)

  skip_if_no_freesurfer()

  # Does FS have a version without colortable?
  # ant <- file.path(
  #   fs_subj_dir(),
  #   "bert",
  #   "label",
  #   "lh.mpm.vpnl.annot"
  # )
  # result <- read_annotation(ant)

  # expect_named(
  #   result,
  #   c("vertices", "label", "colortable")
  # )
  # expect_length(result$vertices, 134814)
  # expect_length(result$label, 134814)
  # expect_true(is.data.frame(result$colortable))
  # expect_equal(nrow(result$colortable), 36)
})

test_that("handles empty colortable labels correctly", {
  temp_file <- withr::local_tempfile(fileext = ".annot")

  # Create a file with an incomplete colortable
  mock_annotation(temp_file, num_vertices = 5, include_colortable = TRUE)
  file_conn <- file(temp_file, "r+b")
  seek(file_conn, where = 32, origin = "start")
  writeBin(as.raw(0), file_conn)
  close(file_conn)

  # Read the file
  result <- read_annotation(temp_file, verbose = FALSE)

  # Ensure all labels are filled with empty strings
  expect_true(
    all(result$colortable$label == "" | !is.na(result$colortable$label))
  )
})
