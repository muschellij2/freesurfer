describe("mri_normalize", {
  it("calls fs_cmd with correct function name", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    out_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        mock_nifti_image()
      }
    )

    mri_normalize(temp_file, outfile = out_file)

    expect_equal(captured_args$func, "mri_normalize")
    expect_equal(captured_args$file, temp_file)
    expect_equal(captured_args$outfile, out_file)
  })

  it("passes frontopts from opts parameter", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    out_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        mock_nifti_image()
      }
    )

    mri_normalize(temp_file, outfile = out_file, opts = "-n 3")

    expect_equal(captured_args$frontopts, "-n 3")
  })

  it("respects retimg parameter", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    out_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      }
    )

    mri_normalize(temp_file, outfile = out_file, retimg = FALSE)

    expect_false(captured_args$retimg)
  })

  it("uses default retimg = TRUE", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    out_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        mock_nifti_image()
      }
    )

    mri_normalize(temp_file, outfile = out_file)

    expect_true(captured_args$retimg)
  })
})

describe("mri_normalize.help", {
  it("calls fs_help with correct function name", {
    captured_func <- NULL
    local_mocked_bindings(
      fs_help = function(func, ...) {
        captured_func <<- func
        "help text"
      }
    )

    mri_normalize.help()
    expect_equal(captured_func, "mri_normalize")
  })
})
