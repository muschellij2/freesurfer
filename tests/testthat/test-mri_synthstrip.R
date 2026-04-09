describe("mri_synthstrip", {
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

    mri_synthstrip(temp_file, outfile = out_file)

    expect_equal(captured_args$func, "mri_synthstrip")
  })

  it("uses -i as frontopts", {
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

    mri_synthstrip(temp_file, outfile = out_file)

    expect_equal(captured_args$frontopts, "-i")
  })

  it("includes -m and -o flags in opts", {
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

    mri_synthstrip(temp_file, outfile = out_file)

    expect_match(captured_args$opts, "-m ")
    expect_match(captured_args$opts, "-o$")
  })

  it("uses provided maskfile path", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    out_file <- withr::local_tempfile(fileext = ".nii.gz")
    mask_file <- withr::local_tempfile(fileext = "_mask.nii.gz")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        mock_nifti_image()
      }
    )

    mri_synthstrip(temp_file, outfile = out_file, maskfile = mask_file)

    expect_match(captured_args$opts, basename(mask_file), fixed = TRUE)
  })

  it("generates temp maskfile when not provided", {
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

    mri_synthstrip(temp_file, outfile = out_file)

    expect_match(captured_args$opts, "_mask\\.nii\\.gz")
  })

  it("appends additional opts to command", {
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

    mri_synthstrip(temp_file, outfile = out_file, opts = "--no-csf")

    expect_match(captured_args$opts, "--no-csf")
  })

  it("adds maskfile attribute to result", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    out_file <- withr::local_tempfile(fileext = ".nii.gz")
    mask_file <- withr::local_tempfile(fileext = "_mask.nii.gz")
    writeLines("test", temp_file)

    local_mocked_bindings(
      fs_cmd = function(...) mock_nifti_image()
    )

    result <- mri_synthstrip(temp_file, outfile = out_file, maskfile = mask_file)

    expect_true("maskfile" %in% names(attributes(result)))
    mask_attr <- attr(result, "maskfile")
    expect_equal(
      normalizePath(mask_attr, mustWork = FALSE),
      normalizePath(mask_file, mustWork = FALSE)
    )
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

    mri_synthstrip(temp_file, outfile = out_file, retimg = FALSE)

    expect_false(captured_args$retimg)
  })
})

describe("synthstrip", {
  it("is identical to mri_synthstrip", {
    expect_identical(synthstrip, mri_synthstrip)
  })
})

describe("mri_synthstrip.help", {
  it("calls fs_help with correct function name", {
    captured_func <- NULL
    local_mocked_bindings(
      fs_help = function(func, ...) {
        captured_func <<- func
        "help text"
      }
    )

    mri_synthstrip.help()
    expect_equal(captured_func, "mri_synthstrip")
  })
})
