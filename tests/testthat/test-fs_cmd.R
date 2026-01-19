describe("fs_cmd", {
  it("constructs command correctly for valid inputs", {
    # Mocking dependencies and files
    temp_file <- withr::local_tempfile(fileext = ".nii")
    writeLines("Mock NIfTI content", temp_file)
    temp_outfile <- withr::local_tempfile(fileext = ".nii")
    writeLines("Mock Output NIfTI content", temp_outfile)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      checkimg = function(file, ...) temp_file,
      check_path = function(file, error, ...) TRUE,
      check_outfile = function(outfile, retimg, fileext, ...) temp_outfile,
      check_fs_result = function(file, ...) temp_outfile,
      get_fs = function(bin_app, ...) "/mock_freesurfer_bin/",
      try_fs_cmd = function(cmd, intern, ...) "Command Executed"
    )

    local_mocked_bindings(
      readnii = function(file, ...) readLines(file),
      .package = "neurobase"
    )

    # Execute the function
    result <- fs_cmd(
      func = "test_func",
      file = temp_file,
      outfile = temp_outfile,
      verbose = FALSE
    )

    # Validate return value
    expect_equal(result, "Mock Output NIfTI content")
  })

  it("warns when input and output file paths are identical", {
    local_fs_unset()
    # Mocking input file
    temp_file <- withr::local_tempfile(fileext = ".nii")
    writeLines("Mock NIfTI content", temp_file)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      checkimg = function(file, ...) temp_file,
      check_path = function(file, error, ...) TRUE,
      get_fs = function(bin_app, ...) "/mock_freesurfer_bin/",
      try_fs_cmd = function(cmd, intern, ...) "Command Executed"
    )

    local_mocked_bindings(
      readnii = function(file, ...) readLines(file),
      .package = "neurobase"
    )

    # Expect warning when input and output files are the same
    expect_warning(
      result <- fs_cmd(
        func = "test_func",
        file = temp_file,
        outfile = temp_file,
        verbose = FALSE,
        retimg = FALSE
      ),
      "Input and output files are identical"
    )
  })

  it("constructs command with optional arguments", {
    # Mocking dependencies and files
    temp_file <- withr::local_tempfile(fileext = ".nii")
    writeLines("Mock NIfTI content", temp_file)
    outfile <- withr::local_tempfile(fileext = ".nii")
    writeLines("Mock Output NIfTI content", outfile)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      checkimg = function(file, ...) temp_file,
      check_fs_result = function(file, ...) temp_file,
      get_fs = function(bin_app, ...) "/freesurfer_bin/",
      try_fs_cmd = function(cmd, intern, ...) cmd
    )

    opts = "-opt1 -opt2"
    func = "test_func"

    # Execute with opts_after_outfile = TRUE
    expect_message(
      result <- fs_cmd(
        func = func,
        file = temp_file,
        outfile = outfile,
        opts_after_outfile = TRUE,
        opts = opts,
        retimg = FALSE
      ),
      "/freesurfer_bin/test_func"
    )

    expect_equal(
      result,
      sprintf(
        "%s%s '%s' %s '%s'",
        get_fs(),
        func,
        normalizePath(temp_file, mustWork = FALSE),
        opts,
        normalizePath(outfile, mustWork = FALSE)
      )
    )
  })

  it("handles missing output files gracefully", {
    # Mocking dependencies and files
    temp_file <- withr::local_tempfile(fileext = ".nii")
    writeLines("Mock NIfTI content", temp_file)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      checkimg = function(file, ...) temp_file,
      check_path = function(file, error, ...) TRUE,
      get_fs = function(bin_app, ...) "freesurfer_bin",
      try_fs_cmd = function(cmd, intern, ...) "Command Executed"
    )
    local_mocked_bindings(
      readnii = function(file, ...) readLines(file),
      .package = "neurobase"
    )

    # Execute the function without an output file
    expect_warning(
      expect_warning(
        result <- fs_cmd(
          func = "test_func",
          file = temp_file,
          outfile = NULL,
          verbose = FALSE
        ),
        regexp = "Command completed.*no output|output file.*created"
      ),
      regexp = "Cannot return image|return image"
    )

    # Ensure the return value corresponds to the file
    expect_true(is.null(result))
  })

  it("handles retimg = FALSE correctly", {
    # Mocking dependencies and files
    temp_file <- withr::local_tempfile(fileext = ".nii")
    writeLines("Mock NIfTI content", temp_file)
    outfile <- withr::local_tempfile(fileext = ".nii")
    writeLines("Mock Output NIfTI content", outfile)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      checkimg = function(file, ...) temp_file,
      get_fs = function(bin_app, ...) "freesurfer_bin",
      try_fs_cmd = function(...) "Command Executed"
    )

    # Execute with retimg = FALSE
    expect_error(
      result <- fs_cmd(
        func = "test_func",
        file = temp_file,
        retimg = FALSE,
        verbose = FALSE
      ),
      "Output file path required when retimg = FALSE"
    )
  })

  it("errors when outfile or input paths are invalid", {
    temp_file <- withr::local_tempfile(fileext = ".nii")
    invalid_outfile <- "invalid_path.nii"

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      checkimg = function(file) temp_file,
      check_outfile = function(outfile, retimg, fileext) {
        fs_abort("Invalid output file path")
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
      regexp = "Files not found"
    )
  })

  it("respects verbosity settings", {
    temp_file <- withr::local_tempfile(fileext = ".nii")
    writeLines("Mock NIfTI content", temp_file)
    outfile <- withr::local_tempfile(fileext = ".nii")
    writeLines("Mock Output NIfTI content", outfile)

    local_mocked_bindings(
      batch_file_exists = function(files, error, ...) TRUE,
      validate_fs_env = function(...) TRUE,
      checkimg = function(file) temp_file,
      check_path = function(file, error) TRUE,
      get_fs = function(bin_app) "freesurfer_bin/",
      try_fs_cmd = function(cmd, intern, ...) NULL
    )

    local_mocked_bindings(
      readnii = function(file, ...) readLines(file),
      .package = "neurobase"
    )

    # Capture output with verbosity enabled
    expect_message(
      fs_cmd(
        func = "test_func",
        file = temp_file,
        outfile = outfile,
        retimg = TRUE,
        verbose = TRUE
      ),
      regexp = "freesurfer_bin/test_func"
    )

    # Ensure no output with verbosity disabled
    expect_silent(
      fs_cmd(
        func = "test_func",
        file = temp_file,
        outfile = outfile,
        retimg = TRUE,
        verbose = FALSE
      )
    )
  })

  it("executes valid system commands", {
    # Test a simple valid command
    result <- try_fs_cmd("echo 'Hello, World!'", intern = TRUE)
    expect_type(result, "character")
    expect_equal(result, "Hello, World!")
  })

  it("gracefully handles invalid commands", {
    expect_error(
      try_fs_cmd("nonexistent_command", intern = TRUE, verbose = FALSE),
      "error in running command"
    )
  })

  it("works with additional arguments passed via `...`", {
    result <- try_fs_cmd("echo 'Wait Test'", wait = TRUE, intern = TRUE)
    expect_type(result, "character")
    expect_equal(result, "Wait Test")
  })
})
