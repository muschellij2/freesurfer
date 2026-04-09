describe("mri_watershed", {
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

    mri_watershed(temp_file, outfile = out_file)

    expect_equal(captured_args$func, "mri_watershed")
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

    mri_watershed(temp_file, outfile = out_file, opts = "-h 35")

    expect_equal(captured_args$frontopts, "-h 35")
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

    mri_watershed(temp_file, outfile = out_file, retimg = FALSE)

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

    mri_watershed(temp_file, outfile = out_file)

    expect_true(captured_args$retimg)
  })
})

describe("mri_watershed.help", {
  it("calls fs_help with correct function name", {
    captured_func <- NULL
    local_mocked_bindings(
      fs_help = function(func, ...) {
        captured_func <<- func
        "help text"
      }
    )

    mri_watershed.help()
    expect_equal(captured_func, "mri_watershed")
  })
})
