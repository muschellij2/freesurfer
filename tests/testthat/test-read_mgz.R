test_that("read_mgz works with valid inputs", {
  # Create a temporary directory and file
  temp_dir <- withr::local_tempdir()
  input_file <- file.path(temp_dir, "input.mgz")
  writeLines("Mock MGZ data", input_file)

  # Mocked bindings
  local_mocked_bindings(
    check_path = mock_check_path,
    temp_file = withr::local_tempfile,
    mri_convert = mock_mri_convert
  )
  local_mocked_bindings(
    readnii = mock_readnii,
    .package = "neurobase"
  )

  # Call the function and capture informational messages
  expect_message(
    result <- read_mgz(input_file),
    regexp = "Successfully read|Unexpected file format|Successfully read mgz",
    fixed = FALSE
  )
  expect_equal(result[1], "Mock NIfTI Object")
})

test_that("read_mgz handles non-existing file gracefully", {
  # Mocked bindings
  local_mocked_bindings(
    check_path = mock_check_path
  )

  # Non-existing input
  expect_error(
    read_mgz("non_existing_file.mgz"),
    "Files not found"
  )
})

test_that("read_mgz handles mri_convert errors", {
  temp_dir <- withr::local_tempdir()
  input_file <- file.path(temp_dir, "input.mgz")
  writeLines("Mock MGZ data", input_file)

  # Mock a failure in mri_convert
  mock_mri_convert_fail <- function(input, output, ...) {
    fs_abort("mri_convert failed")
  }

  local_mocked_bindings(
    check_path = mock_check_path,
    mri_convert = mock_mri_convert_fail
  )

  expect_error(
    read_mgz(input_file),
    "mri_convert failed"
  )
})

test_that("read_mgz handles readnii errors", {
  temp_dir <- withr::local_tempdir()
  input_file <- file.path(temp_dir, "input.mgz")
  writeLines("Mock MGZ data", input_file)

  local_mocked_bindings(
    check_path = mock_check_path,
    temp_file = withr::local_tempfile,
    mri_convert = mock_mri_convert
  )
  local_mocked_bindings(
    readnii = function(file) {
      fs_abort("readnii failed")
    },
    .package = "neurobase"
  )

  expect_error(
    read_mgz(input_file),
    "readnii failed"
  )
})

test_that("read_mgh and read_mgz are identical", {
  expect_identical(read_mgh, read_mgz)
})

skip_if_no_freesurfer()

test_that("read_mgz reads actual data", {
  valid_mgz_file <- file.path(
    fs_subj_dir(),
    "bert",
    "mri",
    "brain.mgz"
  )

  result <- read_mgz(valid_mgz_file)
  expect_s4_class(result, "nifti")
})
