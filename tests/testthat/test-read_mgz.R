describe("read_mgz", {
  it("reads valid MGZ file successfully", {
    temp_dir <- withr::local_tempdir()
    input_file <- file.path(temp_dir, "input.mgz")
    writeLines("Mock MGZ data", input_file)

    local_mocked_bindings(
      check_path = mock_check_path,
      temp_file = withr::local_tempfile,
      mri_convert = mock_mri_convert
    )
    local_mocked_bindings(
      readnii = mock_readnii,
      .package = "neurobase"
    )

    expect_message(
      result <- read_mgz(input_file),
      regexp = "Successfully read|Unexpected file format|Successfully read mgz",
      fixed = FALSE
    )
    expect_equal(result[1], "Mock NIfTI Object")
  })

  it("errors for non-existent file", {
    local_mocked_bindings(
      check_path = mock_check_path
    )

    expect_error(
      read_mgz("non_existing_file.mgz"),
      "Files not found"
    )
  })

  it("propagates mri_convert errors", {
    temp_dir <- withr::local_tempdir()
    input_file <- file.path(temp_dir, "input.mgz")
    writeLines("Mock MGZ data", input_file)

    mock_mri_convert_fail <- function(input, output, ...) {
      fs_abort("mri_convert failed")
    }

    local_mocked_bindings(
      check_path = mock_check_path,
      mri_convert = mock_mri_convert_fail
    )

    expect_error(
      read_mgz(input_file),
      "mri_convert failed"
    )
  })

  it("propagates readnii errors", {
    temp_dir <- withr::local_tempdir()
    input_file <- file.path(temp_dir, "input.mgz")
    writeLines("Mock MGZ data", input_file)

    local_mocked_bindings(
      check_path = mock_check_path,
      temp_file = withr::local_tempfile,
      mri_convert = mock_mri_convert
    )
    local_mocked_bindings(
      readnii = function(file) {
        fs_abort("readnii failed")
      },
      .package = "neurobase"
    )

    expect_error(
      read_mgz(input_file),
      "readnii failed"
    )
  })

  it("is identical to read_mgh alias", {
    expect_identical(read_mgh, read_mgz)
  })

  it("skips format warning when validate_format = FALSE", {
    temp_dir <- withr::local_tempdir()
    input_file <- file.path(temp_dir, "input.xyz")
    writeLines("Mock data", input_file)

    local_mocked_bindings(
      check_path = mock_check_path,
      temp_file = withr::local_tempfile,
      mri_convert = mock_mri_convert,
      get_fs_verbosity = function() FALSE
    )
    local_mocked_bindings(
      readnii = mock_readnii,
      .package = "neurobase"
    )

    expect_no_warning(
      read_mgz(input_file, validate_format = FALSE)
    )
  })

  it("warns for unexpected file extension when validate_format = TRUE", {
    temp_dir <- withr::local_tempdir()
    input_file <- file.path(temp_dir, "input.xyz")
    writeLines("Mock data", input_file)

    local_mocked_bindings(
      check_path = mock_check_path,
      temp_file = withr::local_tempfile,
      mri_convert = mock_mri_convert,
      get_fs_verbosity = function() FALSE
    )
    local_mocked_bindings(
      readnii = mock_readnii,
      .package = "neurobase"
    )

    expect_warning(
      read_mgz(input_file, validate_format = TRUE),
      "Unexpected file format"
    )
  })

  it("does not warn for file without extension", {
    temp_dir <- withr::local_tempdir()
    input_file <- file.path(temp_dir, "inputfile")
    writeLines("Mock data", input_file)

    local_mocked_bindings(
      check_path = mock_check_path,
      temp_file = withr::local_tempfile,
      mri_convert = mock_mri_convert,
      get_fs_verbosity = function() FALSE
    )
    local_mocked_bindings(
      readnii = mock_readnii,
      .package = "neurobase"
    )

    expect_no_warning(
      read_mgz(input_file, validate_format = TRUE)
    )
  })

  it("outputs success message when verbose = TRUE", {
    temp_dir <- withr::local_tempdir()
    input_file <- file.path(temp_dir, "input.mgz")
    writeLines("Mock MGZ data", input_file)

    local_mocked_bindings(
      check_path = mock_check_path,
      temp_file = withr::local_tempfile,
      mri_convert = mock_mri_convert,
      get_fs_verbosity = function() TRUE
    )
    local_mocked_bindings(
      readnii = mock_readnii,
      .package = "neurobase"
    )

    expect_message(
      read_mgz(input_file),
      "Successfully read"
    )
  })

  it("errors when conversion produces no output file", {
    temp_dir <- withr::local_tempdir()
    input_file <- file.path(temp_dir, "input.mgz")
    writeLines("Mock MGZ data", input_file)

    local_mocked_bindings(
      check_path = mock_check_path,
      temp_file = withr::local_tempfile,
      mri_convert = function(file, outfile, ...) {
        invisible(NULL)
      },
      get_fs_verbosity = function() FALSE
    )

    expect_error(
      read_mgz(input_file),
      "MGZ conversion failed"
    )
  })

  it("attaches original file and format metadata to result", {
    temp_dir <- withr::local_tempdir()
    input_file <- file.path(temp_dir, "input.mgz")
    writeLines("Mock MGZ data", input_file)

    local_mocked_bindings(
      check_path = mock_check_path,
      temp_file = withr::local_tempfile,
      mri_convert = mock_mri_convert,
      get_fs_verbosity = function() FALSE
    )
    local_mocked_bindings(
      readnii = mock_readnii,
      .package = "neurobase"
    )

    result <- read_mgz(input_file)

    expect_equal(attr(result, "original_file"), input_file)
    expect_equal(attr(result, "original_format"), "mgz")
  })
})

describe("read_mgz integration", {
  it("reads actual FreeSurfer MGZ file", {
    skip_if_no_freesurfer()

    valid_mgz_file <- file.path(
      fs_subj_dir(),
      "bert",
      "mri",
      "brain.mgz"
    )
    skip_if_not(file.exists(valid_mgz_file), "bert subject not available")

    result <- read_mgz(valid_mgz_file)
    expect_s4_class(result, "nifti")
  })
})
