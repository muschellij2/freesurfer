describe("mri_mask", {
  it("calls fs_cmd with correct function name", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    mask_file <- withr::local_tempfile(fileext = ".nii.gz")
    out_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)
    writeLines("mask", mask_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        mock_nifti_image()
      }
    )
    local_mocked_bindings(
      checkimg = function(file, ...) file,
      .package = "neurobase"
    )

    mri_mask(temp_file, mask = mask_file, outfile = out_file)

    expect_equal(captured_args$func, "mri_mask")
    expect_equal(captured_args$file, temp_file)
  })

  it("passes mask file in opts", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    mask_file <- withr::local_tempfile(fileext = ".nii.gz")
    out_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)
    writeLines("mask", mask_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        mock_nifti_image()
      }
    )
    local_mocked_bindings(
      checkimg = function(file, ...) file,
      .package = "neurobase"
    )

    mri_mask(temp_file, mask = mask_file, outfile = out_file)

    expect_equal(captured_args$opts, mask_file)
  })

  it("passes frontopts from opts parameter", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    mask_file <- withr::local_tempfile(fileext = ".nii.gz")
    out_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)
    writeLines("mask", mask_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        mock_nifti_image()
      }
    )
    local_mocked_bindings(
      checkimg = function(file, ...) file,
      .package = "neurobase"
    )

    mri_mask(
      temp_file,
      mask = mask_file,
      outfile = out_file,
      opts = "-transfer 100"
    )

    expect_equal(captured_args$frontopts, "-transfer 100")
  })

  it("respects retimg parameter", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    mask_file <- withr::local_tempfile(fileext = ".nii.gz")
    out_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)
    writeLines("mask", mask_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      }
    )
    local_mocked_bindings(
      checkimg = function(file, ...) file,
      .package = "neurobase"
    )

    mri_mask(temp_file, mask = mask_file, outfile = out_file, retimg = FALSE)

    expect_false(captured_args$retimg)
  })
})

describe("mri_mask.help", {
  it("calls fs_help with correct function name", {
    captured_func <- NULL
    local_mocked_bindings(
      fs_help = function(func, ...) {
        captured_func <<- func
        "help text"
      }
    )

    mri_mask.help()
    expect_equal(captured_func, "mri_mask")
  })
})
