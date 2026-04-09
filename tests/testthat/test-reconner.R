describe("reconner", {
  it("errors when neither subjid nor infile provided", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE
    )

    expect_error(
      reconner(infile = NULL, subjid = NULL),
      "must be specified!"
    )
  })

  it("warns when subject directory exists and force = FALSE", {
    outdir <- withr::local_tempdir()
    subj <- "subject01"
    dir.create(file.path(outdir, subj))

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "mock/path",
      fs_subj_dir = function() outdir,
      try_fs_cmd = function(cmd, ...) cmd,
      check_path = function(...) TRUE,
      get_fs_license = mock_get_license
    )

    expect_warning(
      reconner(
        infile = "input.nii",
        subjid = subj
      ),
      "already exists"
    )
  })

  it("builds command with recon-all flags when verbose = TRUE", {
    outdir <- withr::local_tempdir()

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "mock/path",
      try_fs_cmd = function(cmd, ...) cmd,
      check_path = function(...) TRUE,
      get_fs_license = mock_get_license
    )

    cmd <- reconner(
      infile = "input.nii",
      outdir = outdir,
      subjid = "subject01",
      verbose = TRUE
    )
    expect_match(cmd, "recon-all")
    expect_match(cmd, "-sd")
    expect_match(cmd, "-i")
    expect_match(cmd, "-all")
  })

  it("includes -force flag when force = TRUE", {
    outdir <- withr::local_tempdir()

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "mock/path",
      try_fs_cmd = function(cmd, ...) cmd,
      check_path = function(...) TRUE,
      get_fs_license = mock_get_license
    )

    cmd <- reconner(
      infile = "input.nii",
      outdir = outdir,
      subjid = "subject01",
      force = TRUE,
      verbose = FALSE
    )
    expect_match(cmd, "-force", fixed = TRUE)
  })

  it("passes custom opts to command", {
    outdir <- withr::local_tempdir()

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "mock/path",
      try_fs_cmd = function(cmd, ...) cmd,
      check_path = function(...) TRUE,
      get_fs_license = mock_get_license
    )

    cmd <- reconner(
      infile = "input.nii",
      opts = "-autorecon2 -parallel",
      subjid = "subject01",
      outdir = outdir,
      verbose = FALSE
    )
    expect_match(cmd, "-autorecon2 -parallel")
  })

  it("auto-generates subject ID from filename when subjid = NULL", {
    outdir <- withr::local_tempdir()

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "mock/path",
      try_fs_cmd = function(cmd, ...) cmd,
      check_path = function(...) TRUE,
      get_fs_license = mock_get_license
    )

    local_mocked_bindings(
      nii.stub = function(filepath, bn) gsub("\\.nii$", "", basename(filepath)),
      .package = "neurobase"
    )

    expect_message(
      cmd <- reconner(
        infile = "input_file.nii",
        outdir = outdir
      ),
      "Subject set to"
    )
    expect_match(cmd, "-subjid input_file", fixed = TRUE)
  })

  it("includes -sd flag with custom output directory", {
    outdir <- withr::local_tempdir()

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "mock/path",
      try_fs_cmd = function(cmd, ...) cmd,
      check_path = function(...) TRUE,
      get_fs_license = mock_get_license
    )

    cmd <- reconner(
      infile = "input.nii",
      subjid = "subject01",
      outdir = outdir,
      verbose = FALSE
    )
    expect_match(cmd, "-sd")
  })

  it("omits -i flag when infile not provided", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "mock/path",
      try_fs_cmd = function(cmd, ...) cmd,
      get_fs_license = mock_get_license
    )

    cmd <- reconner(
      subjid = "subject02",
      verbose = FALSE
    )
    expect_match(cmd, "recon-all")
    expect_match(cmd, "-all")
    expect_false(grepl("-i ", cmd))
  })

  it("processes infile through checknii", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "mock/path",
      checknii = function(filepath) "processed_file.nii",
      try_fs_cmd = function(cmd, ...) cmd,
      check_path = function(...) TRUE,
      get_fs_license = mock_get_license
    )

    cmd <- reconner(
      infile = "input.nii",
      subjid = "subject01",
      verbose = FALSE
    )
    expect_match(cmd, "-i processed_file.nii")
  })

  it("respects get_fs_verbosity() for default verbosity", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "mock/path",
      get_fs_verbosity = function() FALSE,
      try_fs_cmd = function(cmd, ...) cmd,
      check_path = function(...) TRUE
    )

    cmd <- reconner(
      infile = "input.nii",
      subjid = "subject01"
    )
    expect_false(grepl(stdout(), "recon-all"))
  })
})
