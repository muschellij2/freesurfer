test_that("fs_help returns correct help output for a valid Freesurfer function", {
  expected_output <- c(
    "Usage: mri_watershed [options]",
    "Example: mri_watershed input.mgz output.mgz"
  )

  testthat::local_mocked_bindings(
    get_fs = function(...) "/mock/freesurfer/",
    try_cmd = function(...) {
      expect_equal(..., "/mock/freesurfer/mri_watershed --help ")
      return(expected_output)
    }
  )

  result <- fs_help("mri_watershed")

  expect_equal(result, expected_output)
})


test_that("fs_help supports extra arguments", {
  testthat::local_mocked_bindings(
    get_fs = function(...) "/mock/freesurfer/",
    try_cmd = function(cmd, intern) {
      expect_equal(cmd, "/mock/freesurfer/mri_convert --help --debug")
      expect_true(intern)
      return(c("Usage: mri_convert [options]", "--debug: Enable debug mode"))
    }
  )

  result <- fs_help(func_name = "mri_convert", extra.args = "--debug")
  expected_output <- c(
    "Usage: mri_convert [options]",
    "--debug: Enable debug mode"
  )
  expect_equal(result, expected_output)
})

test_that("returns actual help from fs", {
  skip_if_no_freesurfer()

  result <- expect_message(
    fs_help("mri_convert"),
    "mri_convert [options]"
  )

  expect_s3_class(
    result,
    "simpleMessage"
  )
  expect_true(
    grepl("mri_convert", result$message)
  )

  # --- with arguments ---- #
  expect_message(
    fs_help(
      func_name = "mri_convert",
      extra.args = "--debug"
    ),
    "mri_convert --help --debug"
  )
})


test_that("fs_help prints output and returns it invisibly", {
  testthat::local_mocked_bindings(
    get_fs = function(...) "/mock/freesurfer/",
    try_cmd = function(cmd, intern) {
      return(c("Usage: mri_info [options]", "Example: mri_info input.mgz"))
    }
  )

  expect_message(
    res <- fs_help(func_name = "mri_info"),
    "mri_info"
  )
  expect_equal(
    res,
    c("Usage: mri_info [options]", "Example: mri_info input.mgz")
  )
})

test_that("fs_help handles missing Freesurfer path", {
  testthat::local_mocked_bindings(
    get_fs = function(...) "",
    try_cmd = function(cmd, intern) {
      expect_equal(cmd, "mri_annotation2label --help --verbose")
      return(c("Usage: mri_annotation2label [options]", "Verbose mode enabled"))
    }
  )

  result <- fs_help(
    func_name = "mri_annotation2label",
    extra.args = "--verbose"
  )
  expected_output <- c(
    "Usage: mri_annotation2label [options]",
    "Verbose mode enabled"
  )
  expect_equal(result, expected_output)
})

test_that("fs_help constructs correct command using custom Freesurfer path", {
  testthat::local_mocked_bindings(
    get_fs = function(...) "/custom/path/to/freesurfer/",
    try_cmd = function(cmd, intern) {
      expect_equal(
        cmd,
        "/custom/path/to/freesurfer/mri_vol2surf --help --verbose"
      )
      expect_true(intern)
      return(c("Usage: mri_vol2surf [options]", "Details about usage"))
    }
  )

  result <- fs_help(func_name = "mri_vol2surf", extra.args = "--verbose")
  expected_output <- c(
    "Usage: mri_vol2surf [options]",
    "Details about usage"
  )
  expect_equal(result, expected_output)
})

test_that("fs_help does not crash with invalid try_cmd response", {
  testthat::local_mocked_bindings(
    get_fs = function(...) "/mock/freesurfer/",
    try_cmd = function(cmd, intern) {
      stop("Command not found")
    }
  )

  expect_error(
    result <- fs_help(func_name = "invalid_command"),
    "Command not found"
  )
})
