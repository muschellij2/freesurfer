describe("check_fs_result", {
  it("errors when command fails with no output", {
    expect_error(
      check_fs_result(res = 1, fe_before = FALSE, fe_after = FALSE),
      "Command failed with no output"
    )
  })

  it("warns when command succeeds but output does not exist", {
    expect_warning(
      resp <- check_fs_result(res = 0, fe_before = FALSE, fe_after = FALSE),
      "Command completed but no output"
    )
    expect_null(resp)
  })

  it("warns when command fails but output file existed before", {
    expect_warning(
      check_fs_result(res = 1, fe_before = TRUE, fe_after = TRUE),
      "Command failed but output file exists"
    )
  })

  it("warns when command fails but created output file", {
    expect_warning(
      check_fs_result(res = 1, fe_before = FALSE, fe_after = TRUE),
      "Command failed but created output file"
    )
  })

  it("succeeds silently when command succeeds and output exists", {
    expect_silent(
      check_fs_result(res = 0, fe_before = FALSE, fe_after = TRUE)
    )
  })
})

describe("run_check_fs_cmd", {
  it("runs command silently when verbose is FALSE", {
    temp_file <- withr::local_tempfile()

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
  })

  it("outputs message when verbose is TRUE", {
    temp_file <- withr::local_tempfile()

    local_mocked_bindings(
      try_fs_cmd = function(...) 0,
      check_fs_result = function(...) NULL
    )

    expect_message(
      run_check_fs_cmd(
        cmd = "false_cmd",
        outfile = temp_file,
        verbose = TRUE
      ),
      "false_cmd"
    )
  })
})
