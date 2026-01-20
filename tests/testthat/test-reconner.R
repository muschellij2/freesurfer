describe("reconner", {
  it("throws error when neither subjid nor infile is provided", {
    expect_error(
      reconner(infile = NULL, subjid = NULL),
      "must be specified!"
    )
  })

  it("raises warning if subject directory exists and force is FALSE", {
    outdir <- withr::local_tempdir()
    subj <- "subject01"
    dir.create(file.path(outdir, subj))

    local_mocked_bindings(
      get_fs = function() "mock/path",
      fs_subj_dir = function() outdir,
      try_fs_cmd = function(cmd) cmd,
      check_path = function(...) TRUE,
      get_fs_license = mock_get_license
    )

    expect_message(
      expect_warning(
        reconner(
          infile = "input.nii",
          subjid = subj
        ),
        "Subject Directory .* already exists.*use .*force = TRUE.*"
      ),
      "recon-all -i"
    )
  })

  it("outputs command when verbose is TRUE", {
    outdir <- withr::local_tempdir()

    local_mocked_bindings(
      get_fs = function() "mock/path",
      try_fs_cmd = function(cmd) cmd,
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

  it("adds force flag when force = TRUE", {
    outdir <- withr::local_tempdir()

    local_mocked_bindings(
      get_fs = function() "mock/path",
      try_fs_cmd = function(cmd) cmd,
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

  it("correctly adds options to the command", {
    outdir <- withr::local_tempdir()

    local_mocked_bindings(
      get_fs = function() "mock/path",
      try_fs_cmd = function(cmd) cmd,
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

  it("auto-generates subject ID from input file if subjid is NULL", {
    outdir <- withr::local_tempdir()

    local_mocked_bindings(
      get_fs = function() "mock/path",
      try_fs_cmd = function(cmd) cmd,
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

  it("updates subject directory path with custom output directory", {
    outdir <- withr::local_tempdir()

    local_mocked_bindings(
      get_fs = function() "mock/path",
      try_fs_cmd = function(cmd) cmd,
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

  it("runs command without outfile if infile is not specified", {
    local_mocked_bindings(
      get_fs = function() "mock/path",
      try_fs_cmd = function(cmd) cmd,
      get_fs_license = mock_get_license
    )

    expect_message(
      cmd <- reconner(
        subjid = "subject02"
      ),
      "recon-all -all"
    )
    expect_false(grepl("-i", cmd))
  })

  it("calls checknii and uses it for infile processing", {
    local_mocked_bindings(
      get_fs = function() "mock/path",
      checknii = function(filepath) "processed_file.nii",
      try_fs_cmd = function(cmd) cmd,
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

  it("controls default verbosity via get_fs_verbosity()", {
    local_mocked_bindings(
      get_fs = function() "mock/path",
      get_fs_verbosity = function() FALSE,
      try_fs_cmd = function(cmd) cmd,
      check_path = function(...) TRUE
    )

    cmd <- reconner(
      infile = "input.nii",
      subjid = "subject01"
    )
    expect_false(grepl(stdout(), "recon-all"))
  })
})
