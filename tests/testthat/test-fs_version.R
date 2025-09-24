test_that("fs_version works correctly when version file exists", {
  # Setup: Create a temporary directory and a mock version file
  temp_dir <- withr::local_tempdir()
  temp_version_file <- file.path(temp_dir, "build-stamp.txt")
  writeLines("Freesurfer v7.2.0", temp_version_file)

  # Mock fs_dir to return the temporary directory
  testthat::local_mocked_bindings(
    fs_dir = function() temp_dir
  )

  # Test: Check that fs_version reads the correct version
  version <- fs_version()
  expect_equal(version, "Freesurfer v7.2.0")

  # Teardown: Remove temporary directory
  unlink(temp_dir, recursive = TRUE)
})

test_that("fs_version returns empty string and warns when version file does not exist", {
  # Setup: Create a temporary directory without a version file
  temp_dir <- withr::local_tempdir()

  # Mock fs_dir to return the temporary directory
  testthat::local_mocked_bindings(
    fs_dir = function() temp_dir
  )

  # Test: Check that fs_version warns and returns an empty string
  expect_warning(
    version <- fs_version(),
    "No version file exists"
  )
  expect_equal(version, "")
})

test_that("fs_version handles an empty version file gracefully", {
  # Setup: Create a temporary directory with an empty version file
  temp_dir <- withr::local_tempdir()
  temp_version_file <- file.path(temp_dir, "build-stamp.txt")
  file.create(temp_version_file)

  # Mock fs_dir to return the temporary directory
  testthat::local_mocked_bindings(
    fs_dir = function() temp_dir
  )

  # Test: Check that fs_version returns an empty string for an empty file
  version <- fs_version()
  expect_equal(version, character(0))
})

test_that("fs_version handles multi-line version files", {
  # Setup: Create a temporary directory with a multi-line version file
  temp_dir <- withr::local_tempdir()
  temp_version_file <- file.path(temp_dir, "build-stamp.txt")
  writeLines(
    "Freesurfer v7.2.0",
    temp_version_file
  )

  # Mock fs_dir to return the temporary directory
  testthat::local_mocked_bindings(
    fs_dir = function() temp_dir
  )

  # Test: Check that fs_version reads only the first line as the version
  version <- fs_version()
  expect_equal(version, "Freesurfer v7.2.0")
})
