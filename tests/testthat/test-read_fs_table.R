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

test_that("handles default separator", {
  tempfile <- withr::local_tempfile(fileext = ".txt")
  file <- mock_stats_table(
    mock_data,
    file = tempfile
  )
  result <- read_fs_table(file)
  expect_s3_class(result, "data.frame")
  expect_equal(result, mock_data)

  result_stats <- read_stats_table(file)
  expect_equal(result_stats, result)
})

test_that("handles custom separator", {
  tempfile <- withr::local_tempfile(fileext = ".txt")
  file <- mock_stats_table(
    mock_data,
    sep = "\t",
    file = tempfile
  )
  result <- read_fs_table(file)
  expect_s3_class(result, "data.frame")
  expect_equal(result, mock_data)
})


test_that("works when header is set to FALSE", {
  tempfile <- withr::local_tempfile(fileext = ".txt")
  file <- mock_stats_table(
    mock_data,
    file = tempfile
  )
  result <- read_fs_table(file, header = FALSE)
  expect_s3_class(result, "data.frame")
  expect_equal(ncol(result), 2)
  expect_equal(nrow(result), 3)
  expect_equal(result$V1, c("col1", 1, 3))
  expect_equal(result$V2, c("col2", 2, 4))
})

test_that("handles non-existent file gracefully", {
  expect_error(
    read_fs_table("nonexistent_file.txt"),
    "does not exist"
  )
})

test_that("handles invalid file format gracefully", {
  file <- withr::local_tempfile(fileext = ".txt")
  writeLines("This is not a valid\ntable format, at all", file)
  expect_error(
    read_fs_table(file),
    "line 1 did not have 5 elements"
  )
})

test_that("respects additional arguments", {
  tempfile <- withr::local_tempfile(fileext = ".txt")
  file <- mock_stats_table(
    mock_data,
    file = tempfile
  )
  result <- read_fs_table(
    file,
    stringsAsFactors = TRUE,
    header = FALSE
  )
  expect_true(is.factor(result$V1))
  expect_true(is.factor(result$V2))
})

test_that("with mocked check_path validates input file", {
  local_mocked_bindings(
    check_path = function(...) {
      stop("Mocked check_path triggered")
    }
  )
  expect_error(
    read_fs_table("dummy.txt"),
    "Mocked check_path triggered"
  )
})
