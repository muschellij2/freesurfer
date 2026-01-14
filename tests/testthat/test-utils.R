test_that("mkdir successfully creates a directory", {
  # Setup: Define a temporary directory
  temp_dir <- file.path(tempdir(), "test_mkdir_dir")

  # Test: Ensure the directory does not initially exist
  expect_false(dir.exists(temp_dir))

  # Run mkdir to create the directory
  mkdir(temp_dir)

  # Assertions: Directory should exist after creation
  expect_true(dir.exists(temp_dir))

  # Teardown: Remove the created directory
  unlink(temp_dir, recursive = TRUE)
})

test_that("mkdir handles already existing directories gracefully", {
  # Setup: Define and create a temporary directory
  temp_dir <- file.path(tempdir(), "test_existing_dir")
  mkdir(temp_dir)

  # Test: Call mkdir again on the same directory
  expect_true(dir.exists(temp_dir))
  expect_silent(mkdir(temp_dir)) # Should not throw any warning

  # Assertions: Directory should still exist
  expect_true(dir.exists(temp_dir))

  # Teardown: Remove the created directory
  unlink(temp_dir, recursive = TRUE)
})

test_that("temp_file creates a temporary file path with its directory", {
  # Test: Generate a temporary file path
  temp_file <- temp_file(pattern = "test_file_")

  # Assertions: Verify the directory and the file path
  expect_type(temp_file, "character")
  expect_true(dir.exists(dirname(temp_file)))
  expect_match(temp_file, "test_file_")

  # Teardown: Remove the created directory
  unlink(dirname(temp_file), recursive = TRUE)
})

test_that("temp_file handles file name pattern customization", {
  # Test: Generate a temporary file path with a customized pattern
  temp_file <- temp_file(pattern = "custom_pattern_", fileext = ".txt")

  # Assertions: Validate the temporary file path follows the given pattern
  expect_match(basename(temp_file), "^custom_pattern_.*\\.txt$")
  expect_true(dir.exists(dirname(temp_file)))

  # Teardown: Remove the created directory
  unlink(dirname(temp_file), recursive = TRUE)
})

test_that("temp_file works without additional custom arguments", {
  # Test: Generate a simple temporary file path
  temp_file <- temp_file()

  # Assertions: Validate the file path and its directory
  expect_true(file.exists(dirname(temp_file)))

  # Teardown: Remove the created directory
  unlink(dirname(temp_file), recursive = TRUE)
})

test_that("temp_file does not create the file, only ensures directory exists", {
  # Test: Generate a temporary file path
  temp_file <- temp_file(pattern = "test_no_file_creation_")

  # Assertions: Verify that the file itself does not exist
  expect_false(file.exists(temp_file))
  expect_true(dir.exists(dirname(temp_file)))

  # Teardown: Remove the created directory
  unlink(dirname(temp_file), recursive = TRUE)
})

test_that("temp_file respects a custom tmpdir argument", {
  # Setup: create a base temporary directory path (doesn't exist yet)
  base_tmp <- file.path(
    withr::local_tempdir(),
    paste0("custom_tmpdir_", as.integer(Sys.time()))
  )

  # Run: request a tempfile inside base_tmp
  tf <- temp_file(tmpdir = base_tmp, pattern = "provided_dir_")

  # Assertions: returned path should use the provided directory and the dir exists
  expect_true(startsWith(dirname(tf), base_tmp))
})

test_that("validate_fs_env returns invisibly TRUE when FreeSurfer is available", {
  # Mock FreeSurfer presence and license so this unit test runs without a
  # real FreeSurfer installation. We only exercise the local success path.
  local_mocked_bindings(
    have_fs = function() TRUE,
    get_fs_license = function(...) {
      list(value = "/tmp/license.txt", exists = TRUE)
    }
  )

  expect_invisible(freesurfer:::validate_fs_env(check_license = FALSE))
})

test_that("validate_fs_env exercises license-check path", {
  local_mocked_bindings(
    have_fs = function() TRUE,
    get_fs_license = function(...) {
      list(value = "/tmp/license.txt", exists = TRUE)
    }
  )

  res <- tryCatch(
    withCallingHandlers(
      {
        freesurfer:::validate_fs_env(check_license = TRUE)
        list(warn = FALSE, ok = TRUE)
      },
      warning = function(w) {
        invokeRestart("muffleWarning")
        list(warn = TRUE, ok = TRUE)
      }
    ),
    error = function(e) list(warn = NA, ok = FALSE)
  )

  expect_true(is.list(res))
  expect_true(res$ok)
})

test_that("sys_info returns expected components", {
  si <- freesurfer:::sys_info()

  expect_type(si, "list")
  expect_true(all(c("platform", "r_version", "shell") %in% names(si)))
  expect_type(si$platform, "character")
  expect_type(si$r_version, "character")
  expect_type(si$shell, "character")
})

test_that("check_path works correctly when file exists", {
  temp_file <- tempfile()
  file.create(temp_file)
  expect_true(check_path(temp_file))
  unlink(temp_file) # Clean up
})

test_that("check_path throws an error when file does not exist and error = TRUE", {
  missing_file <- tempfile()
  expect_error(
    check_path(missing_file),
    "File does not exist"
  )
})

test_that("check_path returns FALSE when file does not exist and error = FALSE", {
  missing_file <- tempfile()
  expect_false(check_path(missing_file, error = FALSE))
})

test_that("check_outfile returns a tempfile when retimg is TRUE and outfile is NULL", {
  temp_file <- check_outfile(outfile = NULL, retimg = TRUE)

  # Check that the returned value is a string
  expect_type(temp_file, "character")

  # Check that the returned file has the correct extension
  expect_match(temp_file, "\\.nii\\.gz$")
})

test_that("check_outfile throws an error when outfile is NULL and retimg is FALSE", {
  expect_error(
    check_outfile(outfile = NULL, retimg = FALSE),
    "Either provide outfile or set retimg = TRUE"
  )
})

test_that("check_outfile returns the expanded path of a valid outfile", {
  dummy_file <- withr::local_tempfile()
  outfile_path <- path.expand(dummy_file)

  # Call check_outfile with a dummy valid outfile path
  result <- check_outfile(outfile = outfile_path, retimg = FALSE)

  # Check that the returned value matches the input (path-expanded)
  expect_identical(result, outfile_path)
})

test_that("check_outfile handles custom file extensions for tempfiles", {
  custom_ext <- ".testfile"
  temp_file <- check_outfile(
    outfile = NULL,
    retimg = TRUE,
    fileext = custom_ext
  )

  expect_match(temp_file, "\\.testfile$")
})
