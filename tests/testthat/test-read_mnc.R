mock_mnc2nii <- function(input, outfile) {
  if (!file.exists(input)) {
    stop("Input file does not exist for mnc2nii")
  }
  writeLines("Mock NIfTI data", outfile)
}

# Unit tests
test_that("works with valid inputs", {
  # Create a temporary directory and file
  temp_dir <- withr::local_tempdir()
  input_file <- file.path(temp_dir, "input.mnc")
  writeLines("Mock MNC data", input_file)

  # Mocked bindings
  local_mocked_bindings(
    check_path = mock_check_path,
    temp_file = withr::local_tempfile,
    mnc2nii = mock_mnc2nii,
    readnii = mock_readnii
  )

  # Call the function
  result <- read_mnc(input_file)
  expect_equal(result, "Mock NIfTI Object")
})

test_that("handles non-existing file gracefully", {
  # Mocked bindings
  local_mocked_bindings(
    check_path = mock_check_path
  )

  # Non-existing input
  expect_error(
    read_mnc("non_existing_file.mnc"),
    "File does not exist"
  )
})

test_that("handles mnc2nii errors", {
  temp_dir <- withr::local_tempdir()
  input_file <- file.path(temp_dir, "input.mnc")
  writeLines("Mock MNC data", input_file)

  # Mock a failure in mnc2nii
  mock_mnc2nii_fail <- function(input, outfile) {
    stop("mnc2nii failed")
  }

  local_mocked_bindings(
    check_path = mock_check_path,
    temp_file = withr::local_tempfile,
    mnc2nii = mock_mnc2nii_fail
  )

  expect_error(
    read_mnc(input_file),
    "mnc2nii failed"
  )
})

test_that("handles readnii errors", {
  temp_dir <- withr::local_tempdir()
  input_file <- file.path(temp_dir, "input.mnc")
  writeLines("Mock MNC data", input_file)

  # Mock a failure in readnii
  mock_readnii_fail <- function(file) {
    stop("readnii failed")
  }

  local_mocked_bindings(
    check_path = mock_check_path,
    temp_file = withr::local_tempfile,
    mnc2nii = mock_mnc2nii,
    readnii = mock_readnii_fail
  )

  expect_error(
    read_mnc(input_file),
    "readnii failed"
  )
})

test_that("creates a temporary output file", {
  temp_dir <- withr::local_tempdir()
  input_file <- file.path(temp_dir, "input.mnc")
  writeLines("Mock MNC data", input_file)

  created_file <- NULL

  local_tempfile_capture <- function(fileext) {
    created_file <<- withr::local_tempfile(fileext = fileext)
    writeLines("Mock MNC data tempfile", input_file)
    created_file
  }

  local_mocked_bindings(
    check_path = mock_check_path,
    temp_file = local_tempfile_capture,
    mnc2nii = mock_mnc2nii,
    readnii = mock_readnii
  )

  output <- read_mnc(input_file)

  expect_true(file.exists(created_file))
  expect_equal(output, "Mock NIfTI Object")
})

skip_if_no_freesurfer()

test_that("reads real data", {
  withr::local_options(freesurfer.verbose = FALSE)
  temp_minc_file <- withr::local_tempfile(fileext = ".mnc")

  bert_mri = file.path(fs_subj_dir(), "bert", "mri", "T1.mgz")
  bert_nii = read_mgz(bert_mri)
  bert_mnc <- nii2mnc(bert_nii, outfile = temp_minc_file)
  bert_mnc_cont <- read_mnc(bert_mnc)

  expect_true(file.exists(temp_minc_file))
  expect_equal(temp_minc_file, bert_mnc)
  expect_s4_class(bert_mnc_cont, "nifti")
})
