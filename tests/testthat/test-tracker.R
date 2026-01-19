describe("tracker", {
  it("errors when neither subjid nor infile supplied", {
    local_mocked_bindings(
      try_fs_cmd = function(cmd) cmd,
      .env = asNamespace("freesurfer")
    )

    expect_error(
      tracker(infile = NULL, subjid = NULL),
      "Either .*subjid.*infile"
    )
  })

  it("derives subject id from infile and emits info when verbose", {
    td <- local_tempdir()
    infile <- file.path(td, "subjectX.nii")
    file.create(infile)

    local_mocked_bindings(
      get_fs = function() "FSBIN ",
      try_fs_cmd = function(cmd) cmd,
      .env = asNamespace("freesurfer")
    )

    expect_message(
      expect_message(
        res <- tracker(infile = infile, subjid = NULL, verbose = TRUE),
        "Subject ID set to"
      ),
      "-s subjectX"
    )
    expect_type(res, "character")
    expect_true(grepl("-s subjectX", res, fixed = TRUE))
    expect_true(grepl("-i ", res, fixed = TRUE))
    expect_true(grepl("trac-all", res, fixed = TRUE))
  })

  it("builds correct command with explicit subjid, outdir and opts (no execution)", {
    td <- local_tempdir()
    infile <- file.path(td, "in.nii")
    outdir <- file.path(td, "outdir")
    file.create(infile)

    local_mocked_bindings(
      get_fs = function() "/usr/bin/freesurfer ",
      try_fs_cmd = function(cmd) cmd,
      .env = asNamespace("freesurfer")
    )

    cmd <- tracker(
      infile = infile,
      outdir = outdir,
      subjid = "SUBJ01",
      verbose = FALSE,
      opts = "-customflag"
    )

    expect_true(grepl("trac-all", cmd, fixed = TRUE))
    expect_true(grepl("-s SUBJ01", cmd, fixed = TRUE))
    expect_true(grepl("-sd ", cmd, fixed = TRUE))
    expect_true(grepl("-i ", cmd, fixed = TRUE))
    expect_true(grepl("-customflag", cmd, fixed = TRUE))
  })

  it("forward expected opts", {
    td <- local_tempdir()
    infile <- file.path(td, "dwi.nii")
    file.create(infile)

    local_mocked_bindings(
      get_fs = function() "FSB ",
      try_fs_cmd = function(cmd) cmd,
      .env = asNamespace("freesurfer")
    )

    cmd_all <- trac_all(
      infile = infile,
      subjid = "S1",
      outdir = "/tmp",
      verbose = FALSE
    )
    expect_true(grepl("-s S1", cmd_all, fixed = TRUE))

    cmd_prep <- trac_prep(infile = infile, subjid = "S2", verbose = FALSE)
    expect_true(grepl("-prep", cmd_prep, fixed = TRUE))

    cmd_bed <- trac_bedpost(infile = infile, subjid = "S3", verbose = FALSE)
    expect_true(grepl("-bedp", cmd_bed, fixed = TRUE))

    cmd_path <- trac_path(infile = infile, subjid = "S4", verbose = FALSE)
    expect_true(grepl("-path", cmd_path, fixed = TRUE))
  })
})
