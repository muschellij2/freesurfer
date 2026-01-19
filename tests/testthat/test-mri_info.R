describe("mri_info", {
  it("calls fs_cmd with correct function name", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        "info output"
      }
    )

    mri_info(temp_file)

    expect_equal(captured_args$func, "mri_info")
    expect_equal(captured_args$file, temp_file)
    expect_equal(captured_args$outfile, temp_file)
  })

  it("passes additional arguments to fs_cmd", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        "info output"
      }
    )

    mri_info(temp_file, verbose = TRUE, retimg = FALSE)

    expect_true(captured_args$verbose)
    expect_false(captured_args$retimg)
  })
})

describe("mri_info.help", {
  it("calls fs_help with correct function name", {
    captured_func <- NULL
    local_mocked_bindings(
      fs_help = function(func, ...) {
        captured_func <<- func
        "help text"
      }
    )

    mri_info.help()
    expect_equal(captured_func, "mri_info")
  })
})

describe("mri_info integration", {
  it("returns info for nifti image", {
    skip_if_no_freesurfer()

    img <- oro.nifti::nifti(array(rnorm(8), dim = c(2, 2, 2)))

    result <- mri_info(img, retimg = FALSE, intern = TRUE)

    expect_type(result, "character")
    expect_true(length(result) > 0)
  })
})
