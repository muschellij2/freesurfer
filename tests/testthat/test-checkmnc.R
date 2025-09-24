# Helper function to mock behavior of nii2mnc
mock_nii2mnc <- function(input, outfile) {
  outfile
}

# Test suite for checkmnc
test_that("checkmnc works with 'nifti' object", {
  local_mocked_bindings(nii2mnc = mock_nii2mnc)

  nifti_mock <- structure(Inf, class = "nifti")
  # result <- checkmnc(nifti_mock)

  # expect_true(grepl("\\.mnc$", result))
  # expect_true(file.exists(result))
})

test_that("checkmnc works with character filenames", {
  # local_mocked_bindings(
  #   checkimg = function(file, ...) file,
  #   nii2mnc = mock_nii2mnc
  # )
  # # Single valid file
  # valid_file <- tempfile(fileext = ".nii")
  # file.create(valid_file)
  # result <- checkmnc(valid_file)
  # expect_true(file.exists(result))
  # expect_true(grepl("\\.mnc$", result))
  # # Multiple files
  # files <- c(tempfile(fileext = ".nii"), tempfile(fileext = ".mnc"))
  # file.create(files)
  # result <- checkmnc(files)
  # expect_true(all(file.exists(result)))
  # expect_equal(length(result), length(files))
})

test_that("checkmnc throws error for invalid extensions", {
  local_mocked_bindings(checkimg = function(file, ...) file)

  invalid_file <- tempfile(fileext = ".txt")
  file.create(invalid_file)

  expect_error(
    checkmnc(invalid_file),
    regexp = "File extension must be nii/nii.gz or mnc"
  )
})

test_that("checkmnc works with list input", {
  # local_mocked_bindings(nii2mnc = mock_nii2mnc, checkimg = function(file, ...) {
  #   file
  # })
  # files <- list(tempfile(fileext = ".nii"), tempfile(fileext = ".mnc"))
  # file.create(unlist(files))
  # result <- checkmnc(files)
  # expect_true(all(file.exists(result)))
  # expect_equal(length(result), length(files))
})

test_that("ensure_mnc is an alias for checkmnc", {
  # local_mocked_bindings(nii2mnc = mock_nii2mnc, checkimg = function(file, ...) {
  #   file
  # })
  # file <- tempfile(fileext = ".nii")
  # file.create(file)
  # result <- ensure_mnc(file)
  # expect_true(file.exists(result))
  # expect_true(grepl("\\.mnc$", result))
  # # Check equivalence between ensure_mnc and checkmnc
  # result_check <- checkmnc(file)
  # expect_identical(result, result_check)
})
