describe("mri_deface", {
  it("uses provided brain_template without downloading", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    brain_template <- withr::local_tempfile(fileext = ".gca")
    face_template <- withr::local_tempfile(fileext = ".gca")
    writeLines("test", temp_file)
    writeLines("brain", brain_template)
    writeLines("face", face_template)

    download_called <- FALSE
    local_mocked_bindings(
      fs_cmd = function(...) mock_nifti_image()
    )

    mri_deface(
      temp_file,
      brain_template = brain_template,
      face_template = face_template
    )

    expect_false(download_called)
  })

  it("passes templates in opts to fs_cmd", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    brain_template <- withr::local_tempfile(fileext = ".gca")
    face_template <- withr::local_tempfile(fileext = ".gca")
    writeLines("test", temp_file)
    writeLines("brain", brain_template)
    writeLines("face", face_template)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        mock_nifti_image()
      }
    )

    mri_deface(
      temp_file,
      brain_template = brain_template,
      face_template = face_template
    )

    expect_match(captured_args$opts, normalizePath(brain_template))
    expect_match(captured_args$opts, normalizePath(face_template))
  })

  it("sets opts_after_outfile = FALSE", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    brain_template <- withr::local_tempfile(fileext = ".gca")
    face_template <- withr::local_tempfile(fileext = ".gca")
    writeLines("test", temp_file)
    writeLines("brain", brain_template)
    writeLines("face", face_template)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        mock_nifti_image()
      }
    )

    mri_deface(
      temp_file,
      brain_template = brain_template,
      face_template = face_template
    )

    expect_false(captured_args$opts_after_outfile)
  })

  it("calls fs_cmd with correct function name", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    brain_template <- withr::local_tempfile(fileext = ".gca")
    face_template <- withr::local_tempfile(fileext = ".gca")
    writeLines("test", temp_file)
    writeLines("brain", brain_template)
    writeLines("face", face_template)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        mock_nifti_image()
      }
    )

    mri_deface(
      temp_file,
      brain_template = brain_template,
      face_template = face_template
    )

    expect_equal(captured_args$func, "mri_deface")
  })

  it("passes additional arguments to fs_cmd", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    brain_template <- withr::local_tempfile(fileext = ".gca")
    face_template <- withr::local_tempfile(fileext = ".gca")
    writeLines("test", temp_file)
    writeLines("brain", brain_template)
    writeLines("face", face_template)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      }
    )

    mri_deface(
      temp_file,
      brain_template = brain_template,
      face_template = face_template,
      retimg = FALSE,
      verbose = TRUE
    )

    expect_false(captured_args$retimg)
    expect_true(captured_args$verbose)
  })

  it("downloads and unzips brain template when NULL", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    face_template <- withr::local_tempfile(fileext = ".gca")
    writeLines("test", temp_file)
    writeLines("face", face_template)

    download_urls <- c()
    local_mocked_bindings(
      fs_cmd = function(...) mock_nifti_image()
    )
    local_mocked_bindings(
      download.file = function(url, destfile, ...) {
        download_urls <<- c(download_urls, url)
        writeLines("downloaded", destfile)
        0
      },
      .package = "utils"
    )
    local_mocked_bindings(
      gunzip = function(filename, ...) {
        outfile <- gsub("\\.gz$", "", filename)
        writeLines("unzipped", outfile)
        outfile
      },
      .package = "R.utils"
    )

    mri_deface(temp_file, brain_template = NULL, face_template = face_template)

    expect_length(download_urls, 1)
    expect_match(download_urls[1], "talairach_mixed_with_skull.gca.gz")
  })

  it("downloads and unzips face template when NULL", {
    temp_file <- withr::local_tempfile(fileext = ".nii.gz")
    brain_template <- withr::local_tempfile(fileext = ".gca")
    writeLines("test", temp_file)
    writeLines("brain", brain_template)

    download_urls <- c()
    local_mocked_bindings(
      fs_cmd = function(...) mock_nifti_image()
    )
    local_mocked_bindings(
      download.file = function(url, destfile, ...) {
        download_urls <<- c(download_urls, url)
        writeLines("downloaded", destfile)
        0
      },
      .package = "utils"
    )
    local_mocked_bindings(
      gunzip = function(filename, ...) {
        outfile <- gsub("\\.gz$", "", filename)
        writeLines("unzipped", outfile)
        outfile
      },
      .package = "R.utils"
    )

    mri_deface(temp_file, brain_template = brain_template, face_template = NULL)

    expect_length(download_urls, 1)
    expect_match(download_urls[1], "face.gca.gz")
  })
})
