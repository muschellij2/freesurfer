describe("fs_help", {
  it("returns correct help output for a valid Freesurfer function", {
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

  it("supports extra arguments", {
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

  it("returns actual help from fs", {
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

  it("prints output and returns it invisibly", {
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

  it("handles missing Freesurfer path", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "",
      try_fs_cmd = function(cmd, intern, ...) {
        expect_equal(cmd, "mri_annotation2label --help --verbose")
        return(c(
          "Usage: mri_annotation2label [options]",
          "Verbose mode enabled"
        ))
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

  it("constructs correct command using custom Freesurfer path", {
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

  it("does not crash with invalid try_fs_cmd response", {
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

  it("errors on empty func_name", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/mock/freesurfer/",
      try_fs_cmd = function(cmd, intern, ...) {
        fs_abort("Command not found")
      }
    )

    expect_error(
      fs_help(func_name = ""),
      "non-empty character string"
    )
  })

  it("errors on non-character func_name", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/mock/freesurfer/",
      try_fs_cmd = function(cmd, intern, ...) {
        fs_abort("Command not found")
      }
    )
    expect_error(
      fs_help(func_name = 123),
      "non-empty character string"
    )
  })

  it("errors on vector func_name", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/mock/freesurfer/"
    )
    expect_error(
      fs_help(func_name = c("cmd1", "cmd2")),
      "non-empty character string"
    )
  })

  it("does not display output when display = FALSE", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/mock/freesurfer/",
      try_fs_cmd = function(cmd, intern, ...) {
        c("Usage: test_cmd [options]", "Example usage")
      }
    )

    expect_silent(
      result <- fs_help(func_name = "test_cmd", display = FALSE, warn = FALSE)
    )
    expect_equal(result, c("Usage: test_cmd [options]", "Example usage"))
  })

  it("warns when help returns empty result", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/mock/freesurfer/",
      try_fs_cmd = function(cmd, intern, ...) {
        character(0)
      }
    )

    expect_warning(
      fs_help(func_name = "empty_cmd", display = FALSE, warn = TRUE),
      "No help output returned"
    )
  })

  it("warns when command not found in output", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/mock/freesurfer/",
      try_fs_cmd = function(cmd, intern, ...) {
        c("command not found: fake_cmd")
      }
    )

    expect_warning(
      fs_help(func_name = "fake_cmd", display = FALSE, warn = TRUE),
      "appears to be unrecognized"
    )
  })

  it("does not warn when warn = FALSE", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/mock/freesurfer/",
      try_fs_cmd = function(cmd, intern, ...) {
        character(0)
      }
    )

    expect_no_warning(
      fs_help(func_name = "empty_cmd", display = FALSE, warn = FALSE)
    )
  })

  it("uses custom bin_app", {
    captured_path <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(bin_app, ...) {
        captured_path <<- bin_app
        "/mock/freesurfer/"
      },
      try_fs_cmd = function(cmd, intern, ...) {
        c("MNI tool help")
      }
    )

    fs_help(func_name = "nu_correct", bin_app = "mni/bin", display = FALSE)

    expect_equal(captured_path, "mni/bin")
  })
})
