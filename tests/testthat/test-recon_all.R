describe("recon", {
  it("runs silently with valid input file and subject ID", {
    temp_file <- withr::local_tempfile(fileext = ".nii")
    temp_dir <- withr::local_tempdir()
    file.create(temp_file)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = mock_get_fs,
      try_fs_cmd = mock_try_fs_cmd,
      checknii = mock_checknii,
      get_fs_verbosity = function() FALSE
    )

    expect_silent(
      res <- recon(
        infile = temp_file,
        outdir = temp_dir,
        subjid = "test_subject"
      )
    )
  })

  it("warns when subject directory already exists", {
    tempdr <- withr::local_tempdir()

    tmp_file <- withr::local_tempfile(
      fileext = ".nii",
      tmpdir = file.path(tempdr, "test_subject")
    )
    dir.create(dirname(tmp_file), recursive = TRUE)
    file.create(tmp_file)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = mock_get_fs,
      try_fs_cmd = mock_try_fs_cmd,
      checknii = mock_checknii,
      get_fs_verbosity = function() FALSE
    )

    expect_warning(
      recon(
        infile = tmp_file,
        outdir = tempdr,
        subjid = "test_subject"
      ),
      "already exists"
    )
  })

  it("auto-generates subject ID from filename when subjid = NULL", {
    tempdr <- withr::local_tempdir()
    tmp_file <- withr::local_tempfile(
      fileext = ".nii",
      tmpdir = file.path(tempdr, "test_subject")
    )
    dir.create(dirname(tmp_file), recursive = TRUE)
    file.create(tmp_file)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = mock_get_fs,
      try_fs_cmd = mock_try_fs_cmd,
      checknii = mock_checknii,
      get_fs_verbosity = function() FALSE
    )

    expect_message(
      out <- recon(
        infile = tmp_file,
        outdir = tempdr,
        subjid = NULL,
        verbose = TRUE
      ),
      "Subject set to: "
    )
    expect_true(out)
  })

  it("errors for non-existent input file", {
    invalid_file <- "nonexistent_file.nii"

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = mock_get_fs,
      try_fs_cmd = mock_try_fs_cmd,
      checknii = mock_checknii,
      get_fs_verbosity = function() FALSE
    )

    expect_error(
      recon(
        infile = invalid_file,
        outdir = NULL,
        subjid = "test_subject"
      ),
      "does not exist"
    )
  })

  it("accepts custom options and processing flags", {
    temp_file <- withr::local_tempfile(fileext = ".nii")
    temp_dir <- withr::local_tempdir()
    file.create(temp_file)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = mock_get_fs,
      try_fs_cmd = mock_try_fs_cmd,
      checknii = mock_checknii,
      get_fs_verbosity = function() FALSE
    )

    expect_silent(
      recon(
        infile = temp_file,
        outdir = temp_dir,
        subjid = "edge_case",
        options = c(
          motioncor = TRUE,
          talairach = TRUE,
          skullstrip = TRUE,
          fill = TRUE
        ),
        opts = "-custom-opt"
      )
    )
  })
})
