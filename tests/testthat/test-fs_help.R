test_that("fs_help returns correct help output for a valid Freesurfer function", {
  expected_output <- c(
    "Usage: mri_watershed [options]",
    "Example: mri_watershed input.mgz output.mgz"
  )

  local_mocked_bindings(
    validate_fs_env = function(...) TRUE,
    get_fs = function(...) "/mock/freesurfer/",
    try_fs_cmd = function(...) {
      expect_equal(..., "/mock/freesurfer/mri_watershed --help")
      return(expected_output)
    }
  )

  expect_message(
    result <- fs_help("mri_watershed"),
    regexp = "Usage: mri_watershed"
  )

  expect_equal(result, expected_output)
})

test_that("fs_help supports extra arguments", {
  local_mocked_bindings(
    validate_fs_env = function(...) TRUE,
    get_fs = function(...) "/mock/freesurfer/",
    try_fs_cmd = function(cmd, intern, ...) {
      expect_equal(cmd, "/mock/freesurfer/mri_convert --help --debug")
      expect_true(intern)
      return(c("Usage: mri_convert [options]", "--debug: Enable debug mode"))
    }
  )

  expect_message(
    result <- fs_help(func_name = "mri_convert", extra_args = "--debug"),
    regexp = "Usage: mri_convert"
  )
  expected_output <- c(
    "Usage: mri_convert [options]",
    "--debug: Enable debug mode"
  )
  expect_equal(result, expected_output)
})

test_that("returns actual help from fs", {
  skip_if_no_freesurfer()

  expect_message(
    result <- fs_help("mri_convert"),
    "mri_convert [options]"
  )

  expect_true(
    any(grepl("mri_convert", result))
  )

  # --- with arguments ---- #
  expect_message(
    fs_help(
      func_name = "mri_convert",
      extra_args = "--debug"
    ),
    "mri_convert --help --debug"
  )
})

test_that("fs_help prints output and returns it invisibly", {
  local_mocked_bindings(
    validate_fs_env = function(...) TRUE,
    get_fs = function(...) "/mock/freesurfer/",
    try_fs_cmd = function(cmd, intern, ...) {
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
  local_mocked_bindings(
    validate_fs_env = function(...) TRUE,
    get_fs = function(...) "",
    try_fs_cmd = function(cmd, intern, ...) {
      expect_equal(cmd, "mri_annotation2label --help --verbose")
      return(c("Usage: mri_annotation2label [options]", "Verbose mode enabled"))
    }
  )

  expect_message(
    result <- fs_help(
      func_name = "mri_annotation2label",
      extra_args = "--verbose"
    ),
    regexp = "mri_annotation2label"
  )
  expected_output <- c(
    "Usage: mri_annotation2label [options]",
    "Verbose mode enabled"
  )
  expect_equal(result, expected_output)
})

test_that("fs_help constructs correct command using custom Freesurfer path", {
  local_mocked_bindings(
    validate_fs_env = function(...) TRUE,
    get_fs = function(...) "/custom/path/to/freesurfer/",
    try_fs_cmd = function(cmd, intern, ...) {
      expect_equal(
        cmd,
        "/custom/path/to/freesurfer/mri_vol2surf --help --verbose"
      )
      expect_true(intern)
      return(c("Usage: mri_vol2surf [options]", "Details about usage"))
    }
  )

  expect_message(
    result <- fs_help(func_name = "mri_vol2surf", extra_args = "--verbose"),
    regexp = "mri_vol2surf"
  )
  expected_output <- c(
    "Usage: mri_vol2surf [options]",
    "Details about usage"
  )
  expect_equal(result, expected_output)
})

test_that("fs_help does not crash with invalid try_fs_cmd response", {
  local_mocked_bindings(
    validate_fs_env = function(...) TRUE,
    get_fs = function(...) "/mock/freesurfer/",
    try_fs_cmd = function(cmd, intern, ...) {
      fs_abort("Command not found")
    }
  )

  expect_error(
    expect_message(
      result <- fs_help(func_name = "invalid_command"),
      regexp = "Requesting help for"
    ),
    "Command not found"
  )
})
