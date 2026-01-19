describe("checkmnc", {
  it("passes through .mnc files without conversion", {
    mnc_file <- withr::local_tempfile(fileext = ".mnc")
    writeLines("test", mnc_file)

    local_mocked_bindings(
      checkimg = function(file, ...) file
    )
    local_mocked_bindings(
      parse_img_ext = function(file) "mnc",
      .package = "neurobase"
    )

    result <- checkmnc(mnc_file)

    expect_equal(result, mnc_file)
  })

  it("converts .nii files to .mnc", {
    nii_file <- withr::local_tempfile(fileext = ".nii")
    writeLines("test", nii_file)

    conversion_called <- FALSE
    local_mocked_bindings(
      checkimg = function(file, ...) file,
      nii2mnc = function(file, outfile, ...) {
        conversion_called <<- TRUE
        "converted.mnc"
      }
    )
    local_mocked_bindings(
      parse_img_ext = function(file) "nii",
      .package = "neurobase"
    )

    result <- checkmnc(nii_file)

    expect_true(conversion_called)
    expect_equal(result, "converted.mnc")
  })

  it("errors for invalid file extensions", {
    invalid_file <- withr::local_tempfile(fileext = ".txt")
    writeLines("test", invalid_file)

    local_mocked_bindings(
      checkimg = function(file, ...) file
    )
    local_mocked_bindings(
      parse_img_ext = function(file) "txt",
      .package = "neurobase"
    )

    expect_error(
      checkmnc(invalid_file),
      "must be nii/nii.gz or mnc"
    )
  })

  it("handles vector of files", {
    file1 <- withr::local_tempfile(fileext = ".mnc")
    file2 <- withr::local_tempfile(fileext = ".mnc")
    writeLines("test", file1)
    writeLines("test", file2)

    local_mocked_bindings(
      checkimg = function(file, ...) file
    )
    local_mocked_bindings(
      parse_img_ext = function(file) "mnc",
      .package = "neurobase"
    )

    result <- checkmnc(c(file1, file2))

    expect_length(result, 2)
    expect_equal(result[[1]], file1)
    expect_equal(result[[2]], file2)
  })

  it("uses gzipped = FALSE for checkimg", {
    mnc_file <- withr::local_tempfile(fileext = ".mnc")
    writeLines("test", mnc_file)

    captured_gzipped <- NULL
    local_mocked_bindings(
      checkimg = function(file, gzipped, ...) {
        captured_gzipped <<- gzipped
        file
      }
    )
    local_mocked_bindings(
      parse_img_ext = function(file) "mnc",
      .package = "neurobase"
    )

    checkmnc(mnc_file)

    expect_false(captured_gzipped)
  })

  it("writes nifti to temp file and converts", {
    mock_nifti <- mock_nifti_image()

    conversion_called <- FALSE
    local_mocked_bindings(
      nii2mnc = function(file, outfile) {
        conversion_called <<- TRUE
        outfile
      }
    )
    local_mocked_bindings(
      checkimg = function(file, gzipped, ...) {
        temp_file <- tempfile(fileext = ".nii")
        writeLines("test", temp_file)
        temp_file
      },
      .package = "neurobase"
    )

    result <- checkmnc(mock_nifti)

    expect_true(conversion_called)
    expect_match(result, "\\.mnc$")
  })

  it("applies checkmnc to each list element", {
    file1 <- withr::local_tempfile(fileext = ".mnc")
    file2 <- withr::local_tempfile(fileext = ".mnc")
    writeLines("test", file1)
    writeLines("test", file2)

    local_mocked_bindings(
      checkimg = function(file, ...) file
    )
    local_mocked_bindings(
      parse_img_ext = function(file) "mnc",
      .package = "neurobase"
    )

    result <- checkmnc(list(file1, file2))

    expect_length(result, 2)
  })
})

describe("ensure_mnc", {
  it("is identical to checkmnc", {
    expect_identical(ensure_mnc, checkmnc)
  })
})
