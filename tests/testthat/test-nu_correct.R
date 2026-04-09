describe("nu_correct", {
  it("converts nii input to mnc before processing", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)

    captured_file <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        args <- list(...)
        captured_file <<- args$file
        0
      },
      nii2mnc = function(file, ...) {
        paste0(tools::file_path_sans_ext(tools::file_path_sans_ext(file)), ".mnc")
      },
      mnc2nii = function(file, outfile, ...) outfile,
      readnii = function(file, ...) mock_nifti_image()
    )
    local_mocked_bindings(
      checkimg = function(file, ...) file,
      parse_img_ext = function(file) {
        if (grepl("\\.nii\\.gz$", file)) "nii"
        else if (grepl("\\.nii$", file)) "nii"
        else if (grepl("\\.mnc$", file)) "mnc"
        else tools::file_ext(file)
      },
      .package = "neurobase"
    )

    nu_correct(temp_file)

    expect_match(captured_file, "\\.mnc$")
  })

  it("calls fs_cmd with correct function name", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      },
      nii2mnc = function(file, ...) paste0(file, ".mnc"),
      mnc2nii = function(file, outfile, ...) outfile,
      readnii = function(file, ...) mock_nifti_image()
    )
    local_mocked_bindings(
      checkimg = function(file, ...) file,
      parse_img_ext = function(file) {
        if (grepl("\\.nii", file)) "nii" else "mnc"
      },
      .package = "neurobase"
    )

    nu_correct(temp_file)

    expect_equal(captured_args$func, "nu_correct")
  })

  it("uses mni/bin for bin_app", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      },
      nii2mnc = function(file, ...) paste0(file, ".mnc"),
      mnc2nii = function(file, outfile, ...) outfile,
      readnii = function(file, ...) mock_nifti_image()
    )
    local_mocked_bindings(
      checkimg = function(file, ...) file,
      parse_img_ext = function(file) {
        if (grepl("\\.nii", file)) "nii" else "mnc"
      },
      .package = "neurobase"
    )

    nu_correct(temp_file)

    expect_equal(captured_args$bin_app, "mni/bin")
  })

  it("adds -mask option when mask is provided", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    mask_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)
    writeLines("mask", mask_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      },
      nii2mnc = function(file, ...) paste0(file, ".mnc"),
      mnc2nii = function(file, outfile, ...) outfile,
      readnii = function(file, ...) mock_nifti_image(),
      ensure_mnc = function(file, ...) paste0(file, ".mnc")
    )
    local_mocked_bindings(
      checkimg = function(file, ...) file,
      parse_img_ext = function(file) {
        if (grepl("\\.nii", file)) "nii" else "mnc"
      },
      .package = "neurobase"
    )

    nu_correct(temp_file, mask = mask_file)

    expect_match(captured_args$frontopts, "-mask ")
  })

  it("adds -quiet option when verbose = FALSE", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      },
      nii2mnc = function(file, ...) paste0(file, ".mnc"),
      mnc2nii = function(file, outfile, ...) outfile,
      readnii = function(file, ...) mock_nifti_image()
    )
    local_mocked_bindings(
      checkimg = function(file, ...) file,
      parse_img_ext = function(file) {
        if (grepl("\\.nii", file)) "nii" else "mnc"
      },
      .package = "neurobase"
    )

    nu_correct(temp_file, verbose = FALSE)

    expect_match(captured_args$frontopts, "-quiet")
  })

  it("does not add -quiet option when verbose = TRUE", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      },
      nii2mnc = function(file, ...) paste0(file, ".mnc"),
      mnc2nii = function(file, outfile, ...) outfile,
      readnii = function(file, ...) mock_nifti_image()
    )
    local_mocked_bindings(
      checkimg = function(file, ...) file,
      parse_img_ext = function(file) {
        if (grepl("\\.nii", file)) "nii" else "mnc"
      },
      .package = "neurobase"
    )

    nu_correct(temp_file, verbose = TRUE)

    expect_no_match(captured_args$frontopts, "-quiet")
  })

  it("appends existing opts", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      },
      nii2mnc = function(file, ...) paste0(file, ".mnc"),
      mnc2nii = function(file, outfile, ...) outfile,
      readnii = function(file, ...) mock_nifti_image()
    )
    local_mocked_bindings(
      checkimg = function(file, ...) file,
      parse_img_ext = function(file) {
        if (grepl("\\.nii", file)) "nii" else "mnc"
      },
      .package = "neurobase"
    )

    nu_correct(temp_file, opts = "-distance 150", verbose = FALSE)

    expect_match(captured_args$frontopts, "-distance 150")
  })

  it("sets retimg = FALSE for fs_cmd call", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      },
      nii2mnc = function(file, ...) paste0(file, ".mnc"),
      mnc2nii = function(file, outfile, ...) outfile,
      readnii = function(file, ...) mock_nifti_image()
    )
    local_mocked_bindings(
      checkimg = function(file, ...) file,
      parse_img_ext = function(file) {
        if (grepl("\\.nii", file)) "nii" else "mnc"
      },
      .package = "neurobase"
    )

    nu_correct(temp_file)

    expect_false(captured_args$retimg)
  })
})

describe("nu_correct.help", {
  it("calls fs_help with correct function name", {
    captured_args <- NULL
    local_mocked_bindings(
      fs_help = function(func, ...) {
        captured_args <<- list(func = func, ...)
        "help text"
      }
    )

    nu_correct.help()

    expect_equal(captured_args$func, "nu_correct")
  })

  it("uses -help as help_arg", {
    captured_args <- NULL
    local_mocked_bindings(
      fs_help = function(func, ...) {
        captured_args <<- list(func = func, ...)
        "help text"
      }
    )

    nu_correct.help()

    expect_equal(captured_args$help_arg, "-help")
  })

  it("uses mni/bin for bin_app", {
    captured_args <- NULL
    local_mocked_bindings(
      fs_help = function(func, ...) {
        captured_args <<- list(func = func, ...)
        "help text"
      }
    )

    nu_correct.help()

    expect_equal(captured_args$bin_app, "mni/bin")
  })
})
