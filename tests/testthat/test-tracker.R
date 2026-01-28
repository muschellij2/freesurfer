describe("tracker", {
  it("errors when neither subjid nor infile provided", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      try_fs_cmd = function(cmd, ...) cmd,
      .env = asNamespace("freesurfer")
    )

    expect_error(
      tracker(infile = NULL, subjid = NULL),
      "Either .*subjid.*infile"
    )
  })

  it("derives subject ID from infile when subjid = NULL", {
    td <- local_tempdir()
    infile <- file.path(td, "subjectX.nii")
    file.create(infile)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "FSBIN ",
      try_fs_cmd = function(cmd, ...) cmd,
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

  it("builds command with explicit subjid, outdir and opts", {
    td <- local_tempdir()
    infile <- file.path(td, "in.nii")
    outdir <- file.path(td, "outdir")
    file.create(infile)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "/usr/bin/freesurfer ",
      try_fs_cmd = function(cmd, ...) cmd,
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
})

describe("trac_all", {
  it("builds command with -s flag", {
    td <- local_tempdir()
    infile <- file.path(td, "dwi.nii")
    file.create(infile)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "FSB ",
      try_fs_cmd = function(cmd, ...) cmd,
      .env = asNamespace("freesurfer")
    )

    cmd <- trac_all(
      infile = infile,
      subjid = "S1",
      outdir = "/tmp",
      verbose = FALSE
    )

    expect_true(grepl("-s S1", cmd, fixed = TRUE))
  })
})

describe("trac_prep", {
  it("builds command with -prep flag", {
    td <- local_tempdir()
    infile <- file.path(td, "dwi.nii")
    file.create(infile)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "FSB ",
      try_fs_cmd = function(cmd, ...) cmd,
      .env = asNamespace("freesurfer")
    )

    cmd <- trac_prep(infile = infile, subjid = "S2", verbose = FALSE)

    expect_true(grepl("-prep", cmd, fixed = TRUE))
  })
})

describe("trac_bedpost", {
  it("builds command with -bedp flag", {
    td <- local_tempdir()
    infile <- file.path(td, "dwi.nii")
    file.create(infile)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "FSB ",
      try_fs_cmd = function(cmd, ...) cmd,
      .env = asNamespace("freesurfer")
    )

    cmd <- trac_bedpost(infile = infile, subjid = "S3", verbose = FALSE)

    expect_true(grepl("-bedp", cmd, fixed = TRUE))
  })
})

describe("trac_path", {
  it("builds command with -path flag", {
    td <- local_tempdir()
    infile <- file.path(td, "dwi.nii")
    file.create(infile)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "FSB ",
      try_fs_cmd = function(cmd, ...) cmd,
      .env = asNamespace("freesurfer")
    )

    cmd <- trac_path(infile = infile, subjid = "S4", verbose = FALSE)

    expect_true(grepl("-path", cmd, fixed = TRUE))
  })
})
