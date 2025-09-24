test_that("recon function works for valid input", {
  # Setup a temporary file and directory
  temp_file <- withr::local_tempfile(fileext = ".nii")
  temp_dir <- withr::local_tempdir()
  file.create(temp_file)

  # Mock bindings
  local_mocked_bindings(
    get_fs = mock_get_fs,
    try_cmd = mock_try_cmd,
    checknii = mock_checknii,
    get_fs_verbosity = function() FALSE
  )

  # Call recon and verify no errors for valid input
  expect_silent(
    res <- recon(
      infile = temp_file,
      outdir = temp_dir,
      subjid = "test_subject"
    )
  )
})

test_that("recon warns when subj dir exists", {
  tempdr <- withr::local_tempdir()

  tmp_file <- withr::local_tempfile(
    fileext = ".nii",
    tmpdir = file.path(tempdr, "test_subject")
  )
  dir.create(dirname(tmp_file), recursive = TRUE)
  file.create(tmp_file)

  local_mocked_bindings(
    get_fs = mock_get_fs,
    try_cmd = mock_try_cmd,
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

test_that("recon handles missing subjid and generates correctly", {
  tempdr <- withr::local_tempdir()
  tmp_file <- withr::local_tempfile(
    fileext = ".nii",
    tmpdir = file.path(tempdr, "test_subject")
  )
  dir.create(dirname(tmp_file), recursive = TRUE)
  file.create(tmp_file)

  local_mocked_bindings(
    get_fs = mock_get_fs,
    try_cmd = mock_try_cmd,
    checknii = mock_checknii,
    get_fs_verbosity = function() FALSE
  )

  # Ensure subjid is auto-generated from infile when missing
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

test_that("recon handles invalid file paths gracefully", {
  invalid_file <- "nonexistent_file.nii"

  local_mocked_bindings(
    get_fs = mock_get_fs,
    try_cmd = mock_try_cmd,
    checknii = mock_checknii,
    get_fs_verbosity = function() FALSE
  )

  # Expect an error for nonexistent input file
  expect_error(
    recon(
      infile = invalid_file,
      outdir = NULL,
      subjid = "test_subject"
    ),
    "does not exist"
  )
})

test_that("recon handles all parameters and edge cases correctly", {
  temp_file <- withr::local_tempfile(fileext = ".nii")
  temp_dir <- withr::local_tempdir()
  file.create(temp_file)

  local_mocked_bindings(
    get_fs = mock_get_fs,
    try_cmd = mock_try_cmd,
    checknii = mock_checknii,
    get_fs_verbosity = function() FALSE
  )

  # Handle all edge cases of parameter combinations
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
