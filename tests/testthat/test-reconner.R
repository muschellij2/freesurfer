test_that("Error is thrown when neither subjid nor infile is provided", {
  expect_error(
    reconner(infile = NULL, subjid = NULL),
    "must be specified!"
  )
})

test_that("Warning is raised if subject directory exists and force is FALSE", {
  outdir <- withr::local_tempdir()
  subj <- "subject01"
  dir.create(file.path(outdir, subj))

  local_mocked_bindings(
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

test_that("Verbose outputs command when verbose is TRUE", {
  local_mocked_bindings(
    try_fs_cmd = function(cmd) cmd,
    check_path = function(...) TRUE,
    get_fs_license = mock_get_license
  )

  expect_message(
    reconner(
      infile = "input.nii",
      outdir = "/output_dir",
      subjid = "subject01",
      verbose = TRUE
    ),
    "recon-all  -sd '/output_dir' -i ./input.nii -all"
  )
})

test_that("Force flag is added when force = TRUE", {
  local_mocked_bindings(
    try_fs_cmd = function(cmd) cmd,
    check_path = function(...) TRUE,
    get_fs_license = mock_get_license
  )

  expect_message(
    cmd <- reconner(
      infile = "input.nii",
      outdir = "/output_dir",
      subjid = "subject01",
      force = TRUE
    ),
    "-force -all"
  )
  expect_match(cmd, "-force", fixed = TRUE)
})

test_that("Options are correctly added to the command", {
  local_mocked_bindings(
    try_fs_cmd = function(cmd) cmd,
    check_path = function(...) TRUE,
    get_fs_license = mock_get_license
  )

  expect_message(
    cmd <- reconner(
      infile = "input.nii",
      opts = "-autorecon2 -parallel",
      subjid = "subject01",
      outdir = "/output_dir"
    ),
    "-autorecon2 -parallel"
  )
  expect_match(cmd, "-autorecon2 -parallel")
})

test_that("Subject ID is auto-generated from the input file if subjid is NULL", {
  local_mocked_bindings(
    try_fs_cmd = function(cmd) cmd,
    check_path = function(...) TRUE,
    get_fs_license = mock_get_license
  )

  local_mocked_bindings(
    nii.stub = function(filepath, bn) gsub("\\.nii$", "", basename(filepath)),
    .package = "neurobase"
  )

  expect_message(
    expect_message(
      cmd <- reconner(
        infile = "input_file.nii",
        outdir = "/output_dir"
      ),
      "-i ./input_file.nii -all"
    ),
    "Subject set to: \"input_file\""
  )
  expect_match(cmd, "-subjid input_file", fixed = TRUE)
})

test_that("Subject directory path updates with custom output directory", {
  local_mocked_bindings(
    try_fs_cmd = function(cmd) cmd,
    check_path = function(...) TRUE,
    get_fs_license = mock_get_license
  )

  expect_message(
    cmd <- reconner(
      infile = "input.nii",
      subjid = "subject01",
      outdir = "/custom_output"
    ),
    "-sd '/custom_output'"
  )
  expect_match(cmd, "-sd '/custom_output'")
})

test_that("Command runs without outfile if infile is not specified", {
  local_mocked_bindings(
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

test_that("checknii is called and used for infile processing", {
  local_mocked_bindings(
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

test_that("get_fs_verbosity() controls default verbosity", {
  local_mocked_bindings(
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
