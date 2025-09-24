test_that("constructs the command correctly for valid inputs", {
  # Mocking dependencies and files
  temp_file <- withr::local_tempfile(fileext = ".nii")
  temp_outfile <- withr::local_tempfile(fileext = ".nii")

  local_mocked_bindings(
    checkimg = function(file) temp_file,
    check_path = function(file, error) TRUE,
    check_outfile = function(outfile, retimg, fileext) temp_outfile,
    get_fs = function(bin_app) "freesurfer_bin",
    try_cmd = function(cmd, intern) "Command Executed",
    readnii = function(file, reorient) "Image Content"
  )

  # Execute the function
  result <- fs_cmd(
    func = "test_func",
    file = temp_file,
    outfile = temp_outfile,
    verbose = FALSE
  )

  # Validate return value
  expect_equal(result, "Image Content")

  skip_if_no_freesurfer()
})

test_that("warns when input and output file paths are identical", {
  # Mocking input file
  temp_file <- withr::local_tempfile(fileext = ".nii")

  local_mocked_bindings(
    checkimg = function(file) temp_file,
    check_path = function(file, error = FALSE) TRUE,
    get_fs = function(bin_app) "freesurfer_bin",
    try_cmd = function(cmd, intern) NULL
  )

  # Expect warning when input and output files are the same
  expect_warning(
    fs_cmd(
      func = "test_func",
      file = temp_file,
      outfile = temp_file,
      verbose = FALSE,
      retimg = FALSE
    ),
    regexp = "Input file and output file are the same"
  )

  skip_if_no_freesurfer()
})

test_that("constructs commands with optional arguments", {
  # Mocking dependencies and files
  temp_file <- withr::local_tempfile(fileext = ".nii")

  local_mocked_bindings(
    checkimg = function(file) temp_file,
    check_fs_result = function(file) temp_file,
    get_fs = function(bin_app) "freesurfer_bin",
    try_cmd = function(cmd, intern) cmd
  )

  opts = "-opt1 -opt2"
  func = "test_func"

  # Execute with opts_after_outfile = TRUE
  result <- fs_cmd(
    func = func,
    file = temp_file,
    opts_after_outfile = TRUE,
    opts = opts,
    retimg = FALSE
  )

  expect_equal(
    result,
    sprintf(
      "%s %s \"%s\" %s",
      get_fs(),
      func,
      temp_file,
      opts
    )
  )

  skip_if_no_freesurfer()
})

test_that("handles missing output files gracefully", {
  skip_if_no_freesurfer()

  # Mocking dependencies and files
  temp_file <- withr::local_tempfile(fileext = ".nii")

  local_mocked_bindings(
    checkimg = function(file) temp_file,
    check_path = function(file, error) TRUE,
    get_fs = function(bin_app) "freesurfer_bin",
    try_cmd = function(cmd, intern) "Command Executed",
    readnii = function(file, reorient) "Image Content"
  )

  # Execute the function without an output file
  result <- fs_cmd(
    func = "test_func",
    file = temp_file,
    outfile = NULL,
    verbose = FALSE
  )

  # Ensure the return value corresponds to the file
  expect_equal(result, "Image Content")
})

test_that("handles retimg = FALSE correctly", {
  skip_if_no_freesurfer()

  # Mocking dependencies and files
  temp_file <- withr::local_tempfile(fileext = ".nii")

  local_mocked_bindings(
    checkimg = function(file) temp_file,
    get_fs = function(bin_app) "freesurfer_bin",
    try_cmd = function(cmd, intern) "Command Executed"
  )

  # Execute with retimg = FALSE
  result <- fs_cmd(
    func = "test_func",
    file = temp_file,
    retimg = FALSE,
    verbose = FALSE
  )

  expect_equal(result, "Command Executed")
})

test_that("errors when outfile or input paths are invalid", {
  temp_file <- withr::local_tempfile(fileext = ".nii")
  invalid_outfile <- "invalid_path.nii"

  local_mocked_bindings(
    checkimg = function(file) temp_file,
    check_outfile = function(outfile, retimg, fileext) {
      stop("Invalid output file path")
    },
    get_fs = function(bin_app) "freesurfer_bin"
  )

  expect_error(
    fs_cmd(
      func = "test_func",
      file = temp_file,
      outfile = invalid_outfile,
      verbose = FALSE
    ),
    regexp = "Invalid output file path"
  )

  skip_if_no_freesurfer()
})

test_that("respects verbosity settings", {
  temp_file <- withr::local_tempfile(fileext = ".nii")

  local_mocked_bindings(
    checkimg = function(file) temp_file,
    check_path = function(file, error) TRUE,
    get_fs = function(bin_app) "freesurfer_bin",
    try_cmd = function(cmd, intern) NULL
  )

  # Capture output with verbosity enabled
  expect_message(
    fs_cmd(
      func = "test_func",
      file = temp_file,
      retimg = FALSE,
      verbose = TRUE
    ),
    regexp = "Freesurfer command"
  )

  # Ensure no output with verbosity disabled
  expect_silent(
    fs_cmd(
      func = "test_func",
      file = temp_file,
      retimg = FALSE,
      verbose = FALSE
    )
  )

  skip_if_no_freesurfer()
})
