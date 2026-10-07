describe("fs_flag_cmd", {
  it("builds --flag value pairs in order, quoting values", {
    captured <- NULL
    local_mocked_bindings(
      get_fs = function(...) "",
      run_check_fs_cmd = function(cmd, ...) {
        captured <<- cmd
        invisible(NULL)
      }
    )

    fs_flag_cmd(
      "mri_vol2vol",
      args = list(
        mov = "a.nii",
        targ = "b.mgz",
        interp = "nearest",
        o = "out.nii"
      ),
      outfile = "out.nii",
      verbose = FALSE
    )

    expect_identical(
      captured,
      paste(
        "mri_vol2vol --mov",
        shQuote("a.nii"),
        "--targ",
        shQuote("b.mgz"),
        "--interp",
        shQuote("nearest"),
        "--o",
        shQuote("out.nii")
      )
    )
  })

  it("renders TRUE as a bare boolean flag and drops NULL / FALSE", {
    captured <- NULL
    local_mocked_bindings(
      get_fs = function(...) "",
      run_check_fs_cmd = function(cmd, ...) {
        captured <<- cmd
        invisible(NULL)
      }
    )

    fs_flag_cmd(
      "mri_vol2vol",
      args = list(
        mov = "a.nii",
        regheader = TRUE,
        reg = NULL,
        dropme = FALSE,
        o = "out.nii"
      ),
      outfile = "out.nii",
      verbose = FALSE
    )

    expect_match(captured, "--regheader", fixed = TRUE)
    expect_false(grepl("--reg ", captured, fixed = TRUE)) # reg = NULL dropped
    expect_false(grepl("dropme", captured, fixed = TRUE)) # FALSE dropped
  })

  it("appends opts and returns the outfile invisibly", {
    local_mocked_bindings(
      get_fs = function(...) "",
      run_check_fs_cmd = function(cmd, ...) invisible(NULL)
    )

    out <- withVisible(fs_flag_cmd(
      "mri_info",
      args = list(o = "x"),
      outfile = "x",
      opts = "--conform",
      verbose = FALSE
    ))

    expect_identical(out$value, "x")
    expect_false(out$visible)
  })

  it("errors on a non-list or unnamed args", {
    expect_error(fs_flag_cmd("x", args = c("a", "b")), "named list")
    expect_error(fs_flag_cmd("x", args = list("a")), "must be named")
  })
})
