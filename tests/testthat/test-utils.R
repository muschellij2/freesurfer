describe("utils", {
  it("successfully creates a directory", {
    # Setup: Define a temporary directory
    temp_base <- withr::local_tempdir()
    temp_dir <- file.path(temp_base, "test_mkdir_dir")

    # Test: Ensure the directory does not initially exist
    expect_false(dir.exists(temp_dir))

    # Run mkdir to create the directory
    mkdir(temp_dir)

    # Assertions: Directory should exist after creation
    expect_true(dir.exists(temp_dir))
  })

  it("handles already existing directories gracefully", {
    # Setup: Define and create a temporary directory
    temp_base <- withr::local_tempdir()
    temp_dir <- file.path(temp_base, "test_existing_dir")
    mkdir(temp_dir)

    # Test: Call mkdir again on the same directory
    expect_true(dir.exists(temp_dir))
    expect_silent(mkdir(temp_dir)) # Should not throw any warning

    # Assertions: Directory should still exist
    expect_true(dir.exists(temp_dir))
  })

  it("creates a temporary file path with its directory", {
    # Use local_tempdir to ensure cleanup
    withr::local_tempdir()

    # Test: Generate a temporary file path
    temp_file <- temp_file(pattern = "test_file_")

    # Assertions: Verify the directory and the file path
    expect_type(temp_file, "character")
    expect_true(dir.exists(dirname(temp_file)))
    expect_match(temp_file, "test_file_")
  })

  it("handles file name pattern customization", {
    # Use local_tempdir to ensure cleanup
    withr::local_tempdir()

    # Test: Generate a temporary file path with a customized pattern
    temp_file <- temp_file(pattern = "custom_pattern_", fileext = ".txt")

    # Assertions: Validate the temporary file path follows the given pattern
    expect_match(basename(temp_file), "^custom_pattern_.*\\.txt$")
    expect_true(dir.exists(dirname(temp_file)))
  })

  it("works without additional custom arguments", {
    # Use local_tempdir to ensure cleanup
    withr::local_tempdir()

    # Test: Generate a simple temporary file path
    temp_file <- temp_file()

    # Assertions: Validate the file path and its directory
    expect_true(file.exists(dirname(temp_file)))
  })

  it("does not create the file, only ensures directory exists", {
    # Use local_tempdir to ensure cleanup
    withr::local_tempdir()

    # Test: Generate a temporary file path
    temp_file <- temp_file(pattern = "test_no_file_creation_")

    # Assertions: Verify that the file itself does not exist
    expect_false(file.exists(temp_file))
    expect_true(dir.exists(dirname(temp_file)))
  })

  it("respects a custom tmpdir argument", {
    # Setup: use an existing temporary directory
    base_tmp <- withr::local_tempdir()

    # Run: request a tempfile inside base_tmp
    tf <- temp_file(tmpdir = base_tmp, pattern = "provided_dir_")

    # Assertions: returned path should be inside base_tmp directory
    expect_true(grepl(basename(base_tmp), tf, fixed = TRUE))
    expect_true(dir.exists(dirname(tf)))
  })

  it("returns invisibly TRUE when FreeSurfer is available", {
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

  it("exercises license-check path", {
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

  it("returns expected components", {
    si <- freesurfer:::sys_info()

    expect_type(si, "list")
    expect_true(all(c("platform", "r_version", "shell") %in% names(si)))
    expect_type(si$platform, "character")
    expect_type(si$r_version, "character")
    expect_type(si$shell, "character")
  })

  it("works correctly when file exists", {
    temp_file <- withr::local_tempfile()
    file.create(temp_file)
    expect_true(check_path(temp_file))
  })

  it("throws an error when file does not exist and error = TRUE", {
    missing_file <- tempfile()
    expect_error(
      check_path(missing_file),
      "File does not exist"
    )
  })

  it("returns FALSE when file does not exist and error = FALSE", {
    missing_file <- tempfile()
    expect_false(check_path(missing_file, error = FALSE))
  })

  it("returns a tempfile when retimg is TRUE and outfile is NULL", {
    temp_file <- check_outfile(outfile = NULL, retimg = TRUE)

    # Check that the returned value is a string
    expect_type(temp_file, "character")

    # Check that the returned file has the correct extension
    expect_match(temp_file, "\\.nii\\.gz$")
  })

  it("throws an error when outfile is NULL and retimg is FALSE", {
    expect_error(
      check_outfile(outfile = NULL, retimg = FALSE),
      "Either provide outfile or set retimg = TRUE"
    )
  })

  it("returns the expanded path of a valid outfile", {
    dummy_file <- withr::local_tempfile()
    outfile_path <- path.expand(dummy_file)

    # Call check_outfile with a dummy valid outfile path
    result <- check_outfile(outfile = outfile_path, retimg = FALSE)

    # Check that the returned value matches the input (path-expanded)
    expect_equal(result, normalizePath(outfile_path, mustWork = FALSE))
  })

  it("handles custom file extensions for tempfiles", {
    custom_ext <- ".testfile"
    temp_file <- check_outfile(
      outfile = NULL,
      retimg = TRUE,
      fileext = custom_ext
    )

    expect_match(temp_file, "\\.testfile$")
  })

  it("errors when FreeSurfer is not available", {
    local_mocked_bindings(
      have_fs = function() FALSE
    )

    expect_error(
      freesurfer:::validate_fs_env(),
      "FreeSurfer installation not found"
    )
  })

  it("warns when license file is missing and check_license = TRUE", {
    local_mocked_bindings(
      have_fs = function() TRUE,
      get_fs_license = function(...) {
        list(value = NA, exists = FALSE)
      }
    )

    expect_warning(
      freesurfer:::validate_fs_env(check_license = TRUE),
      "license file not found"
    )
  })
})
