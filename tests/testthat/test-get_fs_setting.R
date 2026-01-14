test_that("get_fs_setting correctly uses R options if set", {
  local_fs_unset()
  opt_name <- "freesurfer.test_option"
  value <- normalizePath("/this/weird/path", mustWork = FALSE)

  withr::local_options(freesurfer.test_option = value)

  result <- get_fs_setting(
    env_var = "TEST_ENV_VAR",
    opt_var = opt_name
  )
  expect_equal(result$value, value)
  expect_match(result$source, "R option")
  expect_false(result$exists)

  # -- create dir for exists tests
  value <- withr::local_tempdir()
  dir.create(value, showWarnings = FALSE, recursive = TRUE)
  withr::local_options(freesurfer.test_option = value)

  result <- get_fs_setting(
    env_var = "TEST_ENV_VAR",
    opt_var = opt_name
  )
  expect_match(result$value, value)
  expect_match(result$source, "R option")
  expect_true(result$exists)
})

test_that("get_fs_setting correctly uses environment variables if set", {
  local_fs_unset()
  env_var <- "FREESURFER_TEST_ENV"
  value <- "/path/to/env_value"

  withr::local_envvar(FREESURFER_TEST_ENV = value)

  result <- get_fs_setting(env_var = env_var, opt_var = "irrelevant.option")
  expect_match(result$value, value)
  expect_match(result$source, "Environment variable")
  expect_false(result$exists)

  # -- create dir for exists tests
  value <- withr::local_tempdir()
  withr::local_envvar(FREESURFER_TEST_ENV = value)

  result <- get_fs_setting(env_var = env_var, opt_var = "irrelevant.option")
  expect_match(result$value, value)
  expect_match(result$source, "Environment variable")
  expect_true(result$exists)
})

test_that("get_fs_setting falls back to defaults if neither option nor environment variable is set", {
  local_fs_unset()
  temp_dir <- withr::local_tempdir()

  result <- get_fs_setting(
    env_var = "MISSING_ENV_VAR",
    opt_var = "missing.option",
    defaults = c("NA/path", temp_dir)
  )
  expect_match(result$value, temp_dir)
  expect_match(result$source, "Default")
  expect_true(result$exists)
})

test_that("get_fs_setting returns NA when all options fail", {
  local_fs_unset()
  result <- get_fs_setting(
    env_var = "MISSING_ENV_VAR",
    opt_var = "missing.option",
    defaults = c("non_existent_path")
  )
  expect_true(is.na(result$value))
  expect_match(result$source, "Not found")
  expect_false(result$exists)
})

test_that("get_fs_setting returns options over envvar", {
  local_fs_unset()
  opt_name <- "freesurfer.test_option"
  opt_val <- withr::local_tempdir("opt")
  withr::local_options(freesurfer.test_option = opt_val)

  env_name <- "FREESURFER_TEST_ENV"
  env_val <- withr::local_tempdir("env")
  withr::local_envvar(FREESURFER_TEST_ENV = env_val)

  result <- get_fs_setting(env_var = env_name, opt_var = opt_name)
  expect_equal(result$value, opt_val)
  expect_match(result$source, "R option")
  expect_true(result$exists)
})

# ---- get_fs_home function ----
test_that("get_fs_home retrieves value from R option", {
  local_fs_unset()
  withr::local_options(freesurfer.home = "/mock/path/from/option")
  result <- get_fs_home(simplify = FALSE)
  expect_equal(result$value, "/mock/path/from/option")
  expect_match(result$source, "R option")
  expect_false(result$exists)

  result_simple <- get_fs_home(simplify = TRUE)
  expect_equal(result$value, result_simple)
})

test_that("get_fs_home retrieves value from environment variable", {
  local_fs_unset()
  withr::local_envvar(FREESURFER_HOME = "/mock/path/from/env")
  result <- get_fs_home(simplify = FALSE)
  expect_equal(result$value, "/mock/path/from/env")
  expect_match(result$source, "Environment variable")
  expect_false(result$exists)
})

test_that("get_fs_home retrieves value from default paths", {
  local_fs_unset()
  mock_default_path <- withr::local_tempdir("mock_fs_home")

  withr::local_envvar(FREESURFER_HOME = "")
  withr::local_options(freesurfer.home = NULL)

  local_mocked_bindings(
    get_fs_home = function() {
      get_fs_setting(
        "FREESURFER_HOME",
        "freesurfer.home",
        c("/unused/mock/default/path", mock_default_path)
      )
    }
  )

  result <- get_fs_home()
  expect_equal(result$value, mock_default_path)
  expect_match(result$source, "Default")
  expect_true(result$exists)
})

test_that("get_fs_home handles missing values gracefully", {
  local_fs_unset()
  withr::local_envvar(FREESURFER_HOME = "")
  withr::local_options(freesurfer.home = NULL)
  local_mocked_bindings(
    get_fs_home = function() {
      get_fs_setting(
        "FREESURFER_HOME",
        "freesurfer.home",
        c("/unused/mock/default/path", "/nonexistent/path")
      )
    }
  )

  result <- get_fs_home()
  expect_true(is.na(result$value))
  expect_false(result$exists)
})

# ---- get_fs_license function ----

test_that("get_fs_license prioritizes correct license file paths", {
  local_fs_unset()
  temp_dir <- withr::local_tempdir()
  withr::local_options(freesurfer.home = temp_dir)

  # No license file
  result <- get_fs_license(simplify = FALSE)
  expect_true(is.na(result$value))
  expect_match(result$source, "Not found")
  expect_false(result$exists)

  # When .license exists
  path <- file.path(fs_dir(), ".license")
  writeLines("FS license", path)
  result <- get_fs_license(simplify = FALSE)
  expect_equal(result$value, path)
  expect_match(result$source, "Default")
  expect_true(result$exists)
  file.remove(path)

  # When license.txt exists
  path <- file.path(fs_dir(), "license.txt")
  writeLines("FS license", path)
  result <- get_fs_license(simplify = FALSE)
  expect_equal(result$value, path)
  expect_match(result$source, "Default")
  expect_true(result$exists)

  result_simple <- get_fs_license(simplify = TRUE)
  expect_equal(result$value, result_simple)
})

# ---- get_fs_output function ----
test_that("get_fs_output returns correct output format", {
  local_fs_unset()

  result <- get_fs_output(simplify = FALSE)
  expect_equal(result$value, "nii.gz")
  expect_match(result$source, "Default")

  # -- picks up env var
  format <- "nii"
  withr::local_envvar(FSF_OUTPUT_FORMAT = format)
  result <- get_fs_output(simplify = FALSE)
  expect_equal(result$value, format)
  expect_match(result$source, "Environment variable")

  # picks up option over envvar
  format <- "hdr"
  withr::local_envvar(FSF_OUTPUT_FORMAT = "mcn")
  withr::local_options(freesurfer.output_type = format)
  result <- get_fs_output(simplify = FALSE)
  expect_equal(result$value, format)
  expect_match(result$source, "R option")
})

# ---- get_fs_mni function ----
test_that("get_mni_bin does not find path when not there", {
  local_fs_unset()
  # correct file, but not inside /mni
  temp_bin <- withr::local_tempfile(
    pattern = "MNI",
    fileext = ".pm"
  )

  local_mocked_bindings(
    get_fs_home = function() {
      dirname(temp_bin)
    }
  )

  result <- get_mni_bin(simplify = FALSE)
  expect_false(result$exists)
})

test_that("get_mni_bin identifies default path", {
  local_fs_unset()

  temp_dir <- withr::local_tempdir()
  local_mocked_bindings(
    get_fs_home = function() {
      temp_dir
    }
  )

  temp_bin <- file.path(temp_dir, "mni", "MNI.pm")
  dir.create(dirname(temp_bin))
  writeLines("bin", temp_bin)
  expect_true(file.exists(temp_bin))

  result <- get_mni_bin(simplify = FALSE)
  expect_equal(result$value, dirname(temp_bin))
  expect_true(result$exists)
})

test_that("get_mni_bin identifies option", {
  local_fs_unset()

  temp_dir <- withr::local_tempdir()
  local_mocked_bindings(
    get_fs_home = function(...) {
      temp_dir
    }
  )

  temp_bin <- file.path(temp_dir, "mni", "MNI.pm")
  withr::local_options(freesurfer.mni_path = dirname(temp_bin))
  dir.create(dirname(temp_bin))
  writeLines("bin", temp_bin)

  result <- get_mni_bin(simplify = FALSE)
  expect_true(result$exists)
  expect_equal(result$value, dirname(temp_bin))

  result2 <- get_mni_bin(simplify = TRUE)
  expect_equal(result$value, result2)
})

test_that("get_mni_bin returns several paths when present", {
  local_fs_unset()

  temp_dir <- withr::local_tempdir()
  local_mocked_bindings(
    get_fs_home = function() {
      temp_dir
    }
  )

  temp_bin <- c(
    file.path(temp_dir, "mni", "v2", "MNI.pm"),
    file.path(temp_dir, "mni", "v3", "MNI.pm")
  )

  withr::local_options(
    freesurfer.mni_path = file.path(temp_dir, "mni")
  )
  sapply(dirname(temp_bin), dir.create, recursive = TRUE)
  sapply(temp_bin, function(x) writeLines("bin", x))

  result <- get_mni_bin(simplify = FALSE)
  expect_true(all(result$exists))
  expect_length(result$value, 2)
})

# ---- get_fs_subdir function ----
test_that("get_fs_subdir retrieves value from R option", {
  local_fs_unset()

  withr::local_options(freesurfer.subj_dir = "/mock/path/from/option")
  result <- get_fs_subdir(simplify = FALSE)
  expect_equal(result$value, "/mock/path/from/option")
  expect_match(result$source, "R option")
  expect_false(result$exists) # Since this is a mock path
})

test_that("get_fs_subdir retrieves value from environment variable", {
  local_fs_unset()

  withr::local_envvar(SUBJECTS_DIR = "/mock/path/from/env")
  result <- get_fs_subdir(simplify = FALSE)
  expect_equal(result$value, "/mock/path/from/env")
  expect_match(result$source, "Environment variable")
  expect_false(result$exists) # Since this is a mock path
})

test_that("get_fs_subdir retrieves value from default fs_dir() + '/subjects'", {
  local_fs_unset()

  mock_fs_dir <- withr::local_tempdir()
  local_mocked_bindings(
    get_fs_home = function() {
      mock_fs_dir
    }
  )

  mock_subjects_dir <- file.path(mock_fs_dir, "subjects")
  dir.create(
    mock_subjects_dir,
    recursive = TRUE,
    showWarnings = FALSE
  )

  result <- get_fs_subdir(simplify = FALSE)
  expect_equal(result$value, mock_subjects_dir)
  expect_match(result$source, "Default path")
  expect_true(result$exists)
})

test_that("get_fs_subdir handles missing values gracefully", {
  local_fs_unset()

  local_mocked_bindings(
    get_fs_home = function() {
      NA
    }
  )

  result <- get_fs_subdir(simplify = FALSE)
  expect_true(is.na(result$value))
  expect_match(result$source, "Not found")
  expect_false(result$exists)
})

test_that("return_setting correctly handles valid paths", {
  # Create temporary files for path testing
  temp_files <- c(
    withr::local_tempfile(),
    withr::local_tempfile()
  )
  k <- sapply(temp_files, file.create)

  # Test valid paths
  result <- return_setting(
    value = temp_files,
    source = "env",
    is_path = TRUE
  )
  expect_equal(result$value, temp_files)
  expect_match(result$source, "env")
  expect_equal(
    unname(result$exists),
    c(TRUE, TRUE)
  )
})

test_that("return_setting correctly handles NA values", {
  # Test with NA values
  result <- return_setting(
    value = c(NA, NA),
    source = "env",
    is_path = TRUE
  )
  expect_equal(result$value, c(NA, NA))
  expect_match(result$source, "env")
  expect_equal(
    unname(result$exists),
    FALSE
  )
})

test_that("return_setting handles non-path scenarios", {
  # Test when is_path is FALSE
  result <- return_setting(
    value = c("example_value"),
    source = "default",
    is_path = FALSE
  )
  expect_equal(result$value, "example_value")
  expect_match(result$source, "default")
  expect_true(is.na(result$exists))
})

test_that("return_single selects the first valid existing value", {
  # Mock setting with valid existing entries
  setting <- list(
    value = c("valid_path_1", "valid_path_2"),
    source = "test",
    exists = c(FALSE, TRUE)
  )
  result <- return_single(setting)
  expect_equal(result$value, "valid_path_2")
  expect_equal(result$exists, TRUE)
})

test_that("return_single handles cases with no existing paths", {
  # Mock setting with no valid existing entries
  setting <- list(
    value = c("invalid_path_1", "invalid_path_2"),
    source = "test",
    exists = c(FALSE, FALSE)
  )

  result <- return_single(setting)
  expect_true(is.na(result$value))
  expect_false(result$exists)
})

test_that("return_single asis when there is only one", {
  # Mock setting with no valid existing entries
  setting <- list(
    value = "invalid_path_1",
    source = "test",
    exists = c(FALSE)
  )

  result <- return_single(setting)
  expect_equal(result$value, "invalid_path_1")
  expect_false(result$exists)
})

# -- verbosity tests

test_that("get_fs_verbosity gets envvar", {
  local_fs_unset()
  withr::local_envvar(
    FREESURFER_VERBOSE = TRUE
  )

  expect_true(get_fs_verbosity())

  result <- get_fs_verbosity(simplify = FALSE)
  expect_true(result$value)
  expect_match(result$source, "Environment variable")
  expect_true(is.na(result$exists))

  withr::local_envvar(
    FREESURFER_VERBOSE = FALSE
  )

  expect_false(get_fs_verbosity())

  result <- get_fs_verbosity(simplify = FALSE)
  expect_false(result$value)
  expect_match(result$source, "Environment variable")
  expect_true(is.na(result$exists))
})

test_that("get_fs_verbosity deals with NA", {
  # Mock get_fs_setting with a valid value
  local_mocked_bindings(
    get_fs_setting = function(...) {
      return(list(
        value = NA,
        source = "Default",
        exists = NA
      ))
    }
  )

  # Case 3: Non-NA value with simplify = TRUE
  expect_warning(
    val_simple <- get_fs_verbosity(simplify = TRUE),
    "Unrecognized verbosity setting"
  )
  expect_true(val_simple)

  # capture the warning and the detailed result
  expect_warning(
    res <- get_fs_verbosity(simplify = FALSE),
    "Unrecognized verbosity setting"
  )
  expect_true(res$value)
  expect_match(res$source, "Default")
})

test_that("get_fs_verbosity deals with non-boolean", {
  withr::local_envvar(
    FREESURFER_VERBOSE = "high"
  )

  expect_warning(
    get_fs_verbosity(),
    "Unrecognized verbosity setting"
  )
})

# ---- source ----
test_that("get_fs_source behaves correctly", {
  # Mocking get_fs_setting and fs_dir
  local_mocked_bindings(
    get_fs_setting = function(var, option, default) {
      return(list(value = NA, source = NA, exists = FALSE))
    },
    fs_dir = function() {
      return("/mocked/path")
    }
  )

  # Case 1: NA value with simplify = TRUE
  expect_true(is.na(get_fs_source(simplify = TRUE)))

  # Case 2: NA value with simplify = FALSE
  result <- get_fs_source(simplify = FALSE)
  expect_type(result, "list")
  expect_true(is.na(result$value))
  expect_true(is.na(result$source))
  expect_false(result$exists)

  # Mock get_fs_setting with a valid value and custom source
  local_mocked_bindings(
    get_fs_setting = function(var, option, default) {
      return(list(
        value = "/mocked/path/FreeSurferEnv.sh",
        source = "EnvVar",
        exists = TRUE
      ))
    }
  )

  # Case 3: Non-NA value with simplify = TRUE
  expect_equal(
    get_fs_source(simplify = TRUE),
    "/mocked/path/FreeSurferEnv.sh"
  )

  # Case 4: Non-NA value with simplify = FALSE
  result <- get_fs_source(simplify = FALSE)
  expect_type(result, "list")
  expect_equal(result$value, "/mocked/path/FreeSurferEnv.sh")
  expect_match(result$source, "EnvVar")
  expect_true(result$exists)

  # Case 5: Default source should map to fs_dir()
  local_mocked_bindings(
    get_fs_setting = function(var, option, default) {
      return(list(
        value = "/mocked/path/FreeSurferEnv.sh",
        source = "Default",
        exists = TRUE
      ))
    }
  )

  result <- get_fs_source(simplify = FALSE)
  expect_match(result$source, "Default")
})
