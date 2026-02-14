describe("mnc2nii", {
  it("creates temp outfile when outfile is NULL", {
    temp_file <- withr::local_tempfile(fileext = ".mnc")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        writeLines("output", captured_args$outfile)
        0
      },
      gzip = function(file, ...) file
    )

    result <- mnc2nii(temp_file, outfile = NULL)

    expect_match(captured_args$outfile, "\\.nii$")
  })

  it("uses provided outfile", {
    temp_file <- withr::local_tempfile(fileext = ".mnc")
    out_file <- withr::local_tempfile(fileext = ".nii")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        writeLines("output", captured_args$outfile)
        0
      }
    )

    result <- mnc2nii(temp_file, outfile = out_file)

    expect_equal(captured_args$outfile, out_file)
  })

  it("calls fs_cmd with correct function name", {
    temp_file <- withr::local_tempfile(fileext = ".mnc")
    out_file <- withr::local_tempfile(fileext = ".nii")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        writeLines("output", captured_args$outfile)
        0
      }
    )

    mnc2nii(temp_file, outfile = out_file)

    expect_equal(captured_args$func, "mnc2nii")
  })

  it("uses -float frontopts", {
    temp_file <- withr::local_tempfile(fileext = ".mnc")
    out_file <- withr::local_tempfile(fileext = ".nii")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        writeLines("output", captured_args$outfile)
        0
      }
    )

    mnc2nii(temp_file, outfile = out_file)

    expect_equal(captured_args$frontopts, "-float")
  })

  it("uses mni/bin as bin_app", {
    temp_file <- withr::local_tempfile(fileext = ".mnc")
    out_file <- withr::local_tempfile(fileext = ".nii")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        writeLines("output", captured_args$outfile)
        0
      }
    )

    mnc2nii(temp_file, outfile = out_file)

    expect_equal(captured_args$bin_app, "mni/bin")
  })

  it("sets retimg = FALSE", {
    temp_file <- withr::local_tempfile(fileext = ".mnc")
    out_file <- withr::local_tempfile(fileext = ".nii")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        writeLines("output", captured_args$outfile)
        0
      }
    )

    mnc2nii(temp_file, outfile = out_file)

    expect_false(captured_args$retimg)
  })

  it("errors when input file does not exist", {
    local_mocked_bindings(
      validate_fs_env = function(...) {
        TRUE
      }
    )

    expect_error(
      mnc2nii("nonexistent.mnc"),
      "Files not found"
    )
  })

  it("errors when output file not created", {
    temp_file <- withr::local_tempfile(fileext = ".mnc")
    out_file <- withr::local_tempfile(fileext = ".nii")
    writeLines("test", temp_file)

    local_mocked_bindings(
      fs_cmd = function(...) 0
    )

    expect_error(
      mnc2nii(temp_file, outfile = out_file),
      "mnc2nii did not produce outfile"
    )
  })

  it("handles .nii.nii extension fallback", {
    temp_file <- withr::local_tempfile(fileext = ".mnc")
    out_file <- withr::local_tempfile(fileext = ".nii")
    writeLines("test", temp_file)

    local_mocked_bindings(
      fs_cmd = function(...) {
        args <- list(...)
        writeLines("output", paste0(args$outfile, ".nii"))
        0
      }
    )

    result <- mnc2nii(temp_file, outfile = out_file)

    expect_true(file.exists(result))
  })

  it("gzips output when .gz extension requested", {
    temp_file <- withr::local_tempfile(fileext = ".mnc")
    out_file <- withr::local_tempfile(fileext = ".nii.gz")
    writeLines("test", temp_file)

    gzip_called <- FALSE
    local_mocked_bindings(
      fs_cmd = function(...) {
        args <- list(...)
        writeLines("output", args$outfile)
        0
      },
      gzip = function(file, ...) {
        gzip_called <<- TRUE
        paste0(file, ".gz")
      }
    )

    mnc2nii(temp_file, outfile = out_file)

    expect_true(gzip_called)
  })
})

describe("nii2mnc", {
  it("creates temp outfile when outfile is NULL", {
    temp_file <- withr::local_tempfile(fileext = ".nii")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        writeLines("output", captured_args$outfile)
        0
      }
    )
    local_mocked_bindings(
      checknii = function(file) file,
      .package = "neurobase"
    )

    result <- nii2mnc(temp_file, outfile = NULL)

    expect_match(captured_args$outfile, "\\.mnc$")
  })

  it("uses provided outfile", {
    temp_file <- withr::local_tempfile(fileext = ".nii")
    out_file <- withr::local_tempfile(fileext = ".mnc")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        writeLines("output", captured_args$outfile)
        0
      }
    )
    local_mocked_bindings(
      checknii = function(file) file,
      .package = "neurobase"
    )

    nii2mnc(temp_file, outfile = out_file)

    expect_equal(captured_args$outfile, out_file)
  })

  it("calls fs_cmd with correct function name", {
    temp_file <- withr::local_tempfile(fileext = ".nii")
    out_file <- withr::local_tempfile(fileext = ".mnc")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        writeLines("output", captured_args$outfile)
        0
      }
    )
    local_mocked_bindings(
      checknii = function(file) file,
      .package = "neurobase"
    )

    nii2mnc(temp_file, outfile = out_file)

    expect_equal(captured_args$func, "nii2mnc")
  })

  it("uses mni/bin as bin_app", {
    temp_file <- withr::local_tempfile(fileext = ".nii")
    out_file <- withr::local_tempfile(fileext = ".mnc")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        writeLines("output", captured_args$outfile)
        0
      }
    )
    local_mocked_bindings(
      checknii = function(file) file,
      .package = "neurobase"
    )

    nii2mnc(temp_file, outfile = out_file)

    expect_equal(captured_args$bin_app, "mni/bin")
  })

  it("sets retimg = FALSE", {
    temp_file <- withr::local_tempfile(fileext = ".nii")
    out_file <- withr::local_tempfile(fileext = ".mnc")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        writeLines("output", captured_args$outfile)
        0
      }
    )
    local_mocked_bindings(
      checknii = function(file) file,
      .package = "neurobase"
    )

    nii2mnc(temp_file, outfile = out_file)

    expect_false(captured_args$retimg)
  })

  it("errors when output format is not MNC", {
    temp_file <- withr::local_tempfile(fileext = ".nii")
    writeLines("test", temp_file)

    local_mocked_bindings(
      checknii = function(file) file,
      .package = "neurobase"
    )

    expect_error(
      nii2mnc(temp_file, outfile = "output.nii"),
      "File format of output not MNC"
    )
  })

  it("errors when output file not created", {
    temp_file <- withr::local_tempfile(fileext = ".nii")
    out_file <- withr::local_tempfile(fileext = ".mnc")
    writeLines("test", temp_file)

    local_mocked_bindings(
      fs_cmd = function(...) 0
    )
    local_mocked_bindings(
      checknii = function(file) file,
      .package = "neurobase"
    )

    expect_error(
      nii2mnc(temp_file, outfile = out_file),
      "nii2mnc did not produce outfile"
    )
  })

  it("calls mnc when available", {
    skip_if_not(get_mni_bin(simplify = FALSE)$exists)

    withr::local_options(freesurfer.verbose = FALSE)
    img <- oro.nifti::nifti(array(rnorm(5 * 5 * 5), dim = c(5, 5, 5)))
    mnc <- nii2mnc(img)

    outfile <- withr::local_tempfile(fileext = ".nii")
    img_file <- mnc2nii(mnc, outfile = outfile)
    expect_equal(outfile, img_file)
    expect_message(
      res <- neurobase::readnii(img_file),
      "Malformed"
    )
  })
})

describe("mnc2nii.help", {
  it("displays help info when", {
    expect_message(
      result <- mnc2nii.help(),
      "Convert MINC to NIfTI"
    )
    expect_null(result)
  })
})

describe("nii2mnc.help", {
  it("displays help info when", {
    expect_message(
      result <- nii2mnc.help(),
      "Convert NIfTI to MINC"
    )
    expect_null(result)
  })
})
