describe("mri_vol2vol", {
  it("passes a reg file through to fs_flag_cmd", {
    captured <- NULL
    local_mocked_bindings(
      fs_flag_cmd = function(func, args, outfile, ...) {
        captured <<- list(func = func, args = args, outfile = outfile)
        invisible(outfile)
      }
    )

    mri_vol2vol(
      mov = "m.nii",
      targ = "t.mgz",
      reg = "r.lta",
      outfile = "o.nii",
      interp = "nearest"
    )

    expect_identical(captured$func, "mri_vol2vol")
    expect_identical(captured$args$mov, "m.nii")
    expect_identical(captured$args$targ, "t.mgz")
    expect_identical(captured$args$reg, "r.lta")
    expect_identical(captured$args$interp, "nearest")
    expect_identical(captured$args$o, "o.nii")
    expect_false(captured$args$regheader)
  })

  it("turns reg = 'header' into --regheader and drops --reg", {
    captured <- NULL
    local_mocked_bindings(
      fs_flag_cmd = function(func, args, outfile, ...) {
        captured <<- args
        invisible(outfile)
      }
    )

    mri_vol2vol(
      mov = "m.nii",
      targ = "t.mgz",
      reg = "header",
      outfile = "o.nii"
    )

    expect_true(captured$regheader)
    expect_null(captured$reg)
  })

  it("defaults the interpolation to trilinear", {
    captured <- NULL
    local_mocked_bindings(
      fs_flag_cmd = function(func, args, outfile, ...) {
        captured <<- args
        invisible(outfile)
      }
    )

    mri_vol2vol("m.nii", "t.mgz", reg = "header", outfile = "o.nii")
    expect_identical(captured$interp, "trilin")
  })

  it("errors when reg is not supplied", {
    expect_error(
      mri_vol2vol("m.nii", "t.mgz", outfile = "o.nii"),
      "reg"
    )
  })
})
