test_that("check_fs_result handles all scenarios", {
  # Case 1: Non-zero result, output does not exist
  expect_error(
    check_fs_result(res = 1, fe_before = FALSE, fe_after = FALSE),
    "Command failed with no output"
  )

  # Case 2: Zero result, output does not exist
  expect_warning(
    resp <- check_fs_result(res = 0, fe_before = FALSE, fe_after = FALSE),
    "Command completed but no output"
  )
  expect_null(resp)

  # Case 3: Non-zero result, output exists but existed before the run
  expect_warning(
    check_fs_result(res = 1, fe_before = TRUE, fe_after = TRUE),
    "Command failed but output file exists"
  )

  # Case 4: Non-zero result, output exists but did not exist before
  expect_warning(
    check_fs_result(res = 1, fe_before = FALSE, fe_after = TRUE),
    "Command failed but created output file"
  )

  # Case 5: Zero result, output exists
  expect_silent(
    check_fs_result(res = 0, fe_before = FALSE, fe_after = TRUE)
  )
})

test_that("run_check_fs_cmd validates the entire workflow", {
  # Temp file to simulate the output file
  temp_file <- withr::local_tempfile()

  # Mock system command
  local_mocked_bindings(
    try_fs_cmd = function(...) 0,
    check_fs_result = function(...) NULL
  )

  expect_silent(
    run_check_fs_cmd(
      cmd = "echo 'test'",
      outfile = temp_file,
      verbose = FALSE
    )
  )
  expect_false(file.exists(temp_file))

  expect_message(
    run_check_fs_cmd(
      cmd = "false_cmd",
      outfile = temp_file,
      verbose = TRUE
    ),
    "false_cmd"
  )
})
