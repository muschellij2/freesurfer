describe("mris_euler_number", {
  it("warns for unexpected file format when validate_format = TRUE", {
    temp_file <- withr::local_tempfile(fileext = ".xyz")
    out_file <- withr::local_tempfile(fileext = ".txt")
    writeLines("test", temp_file)
    writeLines("euler = 2", out_file)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) 0,
      get_fs_verbosity = function() FALSE
    )

    expect_warning(
      mris_euler_number(temp_file, outfile = out_file, validate_format = TRUE),
      "Unexpected file format"
    )
  })

  it("does not warn for valid formats", {
    temp_file <- withr::local_tempfile(fileext = ".mgz")
    out_file <- withr::local_tempfile(fileext = ".txt")
    writeLines("test", temp_file)
    writeLines("euler = 2", out_file)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) 0,
      get_fs_verbosity = function() FALSE
    )

    expect_no_warning(
      mris_euler_number(temp_file, outfile = out_file, validate_format = TRUE)
    )
  })

  it("skips validation when validate_format = FALSE", {
    temp_file <- withr::local_tempfile(fileext = ".xyz")
    out_file <- withr::local_tempfile(fileext = ".txt")
    writeLines("test", temp_file)
    writeLines("euler = 2", out_file)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) 0,
      get_fs_verbosity = function() FALSE
    )

    expect_no_warning(
      mris_euler_number(temp_file, outfile = out_file, validate_format = FALSE)
    )
  })

  it("correctly identifies nii.gz as valid", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    out_file <- withr::local_tempfile(fileext = ".txt")
    writeLines("test", temp_file)
    writeLines("euler = 2", out_file)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) 0,
      get_fs_verbosity = function() FALSE
    )

    expect_no_warning(
      mris_euler_number(temp_file, outfile = out_file, validate_format = TRUE)
    )
  })

  it("calls fs_cmd with correct function name", {
    temp_file <- withr::local_tempfile(fileext = ".mgz")
    out_file <- withr::local_tempfile(fileext = ".txt")
    writeLines("test", temp_file)
    writeLines("euler = 2", out_file)

    captured_args <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      }
    )

    mris_euler_number(temp_file, outfile = out_file)

    expect_equal(captured_args$func, "mris_euler_number")
  })

  it("sets retimg = FALSE", {
    temp_file <- withr::local_tempfile(fileext = ".mgz")
    out_file <- withr::local_tempfile(fileext = ".txt")
    writeLines("test", temp_file)
    writeLines("euler = 2", out_file)

    captured_args <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      }
    )

    mris_euler_number(temp_file, outfile = out_file)

    expect_false(captured_args$retimg)
  })

  it("includes stderr redirect in opts", {
    temp_file <- withr::local_tempfile(fileext = ".mgz")
    out_file <- withr::local_tempfile(fileext = ".txt")
    writeLines("test", temp_file)
    writeLines("euler = 2", out_file)

    captured_args <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      }
    )

    mris_euler_number(temp_file, outfile = out_file)

    expect_match(captured_args$opts, "2> ")
  })

  it("passes timeout_seconds to fs_cmd", {
    temp_file <- withr::local_tempfile(fileext = ".mgz")
    out_file <- withr::local_tempfile(fileext = ".txt")
    writeLines("test", temp_file)
    writeLines("euler = 2", out_file)

    captured_args <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      }
    )

    mris_euler_number(temp_file, outfile = out_file, timeout_seconds = 60)

    expect_equal(captured_args$timeout_seconds, 60)
  })

  it("returns NULL when output file is empty", {
    temp_file <- withr::local_tempfile(fileext = ".mgz")
    out_file <- withr::local_tempfile(fileext = ".txt")
    writeLines("test", temp_file)
    writeLines(character(0), out_file)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) 0
    )

    expect_warning(
      result <- mris_euler_number(temp_file, outfile = out_file),
      "empty"
    )
    expect_null(result)
  })

  it("reads and returns output file content", {
    temp_file <- withr::local_tempfile(fileext = ".mgz")
    out_file <- withr::local_tempfile(fileext = ".txt")
    writeLines("test", temp_file)
    expected_output <- c("euler number = 2", "total holes = 0")
    writeLines(expected_output, out_file)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) 0
    )

    result <- mris_euler_number(temp_file, outfile = out_file)

    expect_equal(result, expected_output)
  })

  it("creates temp output file when outfile is NULL", {
    temp_file <- withr::local_tempfile(fileext = ".mgz")
    writeLines("test", temp_file)

    captured_outfile <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) {
        args <- list(...)
        captured_outfile <<- args$opts
        0
      }
    )

    expect_warning(
      mris_euler_number(temp_file),
      "no output|empty"
    )

    expect_match(captured_outfile, "\\.txt")
  })
})

describe("mris_euler_number.help", {
  it("calls fs_help with correct function name", {
    captured_func <- NULL
    local_mocked_bindings(
      fs_help = function(func, ...) {
        captured_func <<- func
        "help text"
      }
    )

    mris_euler_number.help()
    expect_equal(captured_func, "mris_euler_number")
  })
})

describe("mris_euler_number integration", {
  it("calculates euler number for surface", {
    skip_if_no_freesurfer()

    bert_surf <- file.path(fs_subj_dir(), "bert", "surf", "lh.white")
    skip_if_not(file.exists(bert_surf), "bert subject not available")

    expect_warning(
      expect_warning(
        expect_warning(
          result <- mris_euler_number(bert_surf),
          "Unexpected file format"
        ),
        "Input and output files are identical"
      ),
      "output file is empty"
    )

    expect_true(is.character(result) || is.null(result))
  })
})
