describe("fs_cmd", {
  it("constructs command correctly for valid inputs", {
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

    result <- fs_cmd(
      func = "test_func",
      file = temp_file,
      outfile = temp_outfile,
      verbose = FALSE
    )

    expect_equal(result, "Mock Output NIfTI content")
  })

  it("warns when input and output files identical", {
    local_fs_unset()
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

  it("places opts after outfile when opts_after_outfile = TRUE", {
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

    opts <- "-opt1 -opt2"
    func <- "test_func"

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

    expect_match(result, func)
    expect_match(result, opts)
    expect_match(
      result,
      gsub("\\\\", "\\\\\\\\", normalizePath(temp_file, mustWork = FALSE))
    )
    expect_match(
      result,
      gsub("\\\\", "\\\\\\\\", normalizePath(outfile, mustWork = FALSE))
    )
  })

  it("warns when output file not created", {
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

    expect_true(is.null(result))
  })

  it("errors when retimg = FALSE and outfile = NULL", {
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

  it("errors when input file not found", {
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

  it("prints command when verbose = TRUE", {
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
  })

  it("is silent when verbose = FALSE", {
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
})

describe("try_fs_cmd", {
  it("executes valid shell commands", {
    result <- try_fs_cmd("echo 'Hello, World!'", intern = TRUE)
    expect_type(result, "character")
    expect_equal(result, "Hello, World!")
  })

  it("errors for invalid commands", {
    skip_on_os("windows")
    expect_error(
      try_fs_cmd("nonexistent_command", intern = TRUE, verbose = FALSE),
      "error in running command"
    )
  })

  it("passes additional arguments via ...", {
    result <- try_fs_cmd("echo 'Wait Test'", wait = TRUE, intern = TRUE)
    expect_type(result, "character")
    expect_equal(result, "Wait Test")
  })
})

describe("fs_cmd integration", {
  it("runs mri_info successfully", {
    skip_if_no_freesurfer()

    sample_mgz <- file.path(fs_dir(), "subjects", "sample-001.mgz")
    skip_if_not(file.exists(sample_mgz), "sample-001.mgz not available")

    withr::local_options(freesurfer.verbose = FALSE)
    expect_warning(
      result <- fs_cmd(
        func = "mri_info",
        file = sample_mgz,
        outfile = sample_mgz,
        frontopts = "--dim",
        retimg = FALSE
      ),
      "Input and output files are identical"
    )

    expect_equal(result, 0L)
  })
})
