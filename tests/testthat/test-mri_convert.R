describe("mri_convert", {
  it("warns for unexpected input format", {
    temp_file <- withr::local_tempfile(fileext = ".txt")
    writeLines("test", temp_file)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) 0
    )

    expect_warning(
      mri_convert(temp_file, outfile = "out.nii.gz", format_check = TRUE),
      "Unexpected input file format"
    )
  })

  it("warns for unexpected output format", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) 0
    )

    expect_warning(
      mri_convert(temp_file, outfile = "out.txt", format_check = TRUE),
      "Unexpected output file format"
    )
  })

  it("does not warn for valid formats", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)
    out_file <- withr::local_tempfile(fileext = ".mgz")

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) 0,
      get_fs_verbosity = function() FALSE
    )

    expect_no_warning(
      mri_convert(temp_file, outfile = out_file, format_check = TRUE)
    )
  })

  it("skips format check when format_check = FALSE", {
    temp_file <- withr::local_tempfile(fileext = ".xyz")
    writeLines("test", temp_file)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) 0
    )

    expect_silent(
      mri_convert(temp_file, outfile = "out.abc", format_check = FALSE)
    )
  })

  it("correctly identifies nii.gz extension", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)
    out_file <- withr::local_tempfile(fileext = ".nii.gz")

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) 0
    )

    expect_silent(
      mri_convert(temp_file, outfile = out_file, format_check = TRUE)
    )
  })

  it("accepts mgz and mgh formats", {
    temp_mgz <- withr::local_tempfile(fileext = ".mgz")
    temp_mgh <- withr::local_tempfile(fileext = ".mgh")
    writeLines("test", temp_mgz)
    writeLines("test", temp_mgh)
    out_file <- withr::local_tempfile(fileext = ".nii")

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) 0,
      get_fs_verbosity = function() FALSE
    )

    expect_no_warning(
      mri_convert(temp_mgz, outfile = out_file, format_check = TRUE)
    )
    expect_no_warning(
      mri_convert(temp_mgh, outfile = out_file, format_check = TRUE)
    )
  })

  it("accepts mnc format", {
    temp_mnc <- withr::local_tempfile(fileext = ".mnc")
    writeLines("test", temp_mnc)
    out_file <- withr::local_tempfile(fileext = ".mnc")

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) 0,
      get_fs_verbosity = function() FALSE
    )

    expect_no_warning(
      mri_convert(temp_mnc, outfile = out_file, format_check = TRUE)
    )
  })

  it("passes correct arguments to fs_cmd", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)
    out_file <- withr::local_tempfile(fileext = ".mgz")

    captured_args <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      }
    )

    mri_convert(temp_file, outfile = out_file, opts = "--conform")

    expect_equal(captured_args$func, "mri_convert")
    expect_equal(captured_args$frontopts, "--conform")
    expect_false(captured_args$retimg)
  })

  it("handles nifti objects by skipping format check", {
    mock_nifti <- mock_nifti_image()

    captured_args <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      }
    )

    mri_convert(mock_nifti, outfile = "out.mgz", format_check = TRUE)

    expect_false(captured_args$validate_inputs)
  })

  it("passes timeout_seconds to fs_cmd", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)
    out_file <- withr::local_tempfile(fileext = ".mgz")

    captured_args <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      }
    )

    mri_convert(temp_file, outfile = out_file, timeout_seconds = 600)

    expect_equal(captured_args$timeout_seconds, 600)
  })
})

describe("mri_convert.help", {
  it("calls fs_help with correct function name", {
    captured_func <- NULL
    local_mocked_bindings(
      fs_help = function(func, ...) {
        captured_func <<- func
        "help text"
      }
    )

    mri_convert.help()
    expect_equal(captured_func, "mri_convert")
  })
})

describe("mri_convert integration", {
  it("converts nifti to nifti", {
    skip_if_no_freesurfer()

    img <- oro.nifti::nifti(array(rnorm(8), dim = c(2, 2, 2)))
    outfile <- withr::local_tempfile(fileext = ".nii.gz")

    withr::local_options(freesurfer.verbose = FALSE)
    mri_convert(img, outfile = outfile)

    expect_true(file.exists(outfile))
  })
})
