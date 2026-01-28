describe("mri_surf2surf", {
  it("builds correct hemisphere argument", {
    captured_cmd <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/fs/bin/",
      run_check_fs_cmd = function(cmd, ...) {
        captured_cmd <<- cmd
        0
      }
    )

    mri_surf2surf(
      subject = "bert",
      target_subject = "fsaverage",
      hemi = "lh"
    )

    expect_match(captured_cmd, "--hemi lh")
  })

  it("builds correct subject argument", {
    captured_cmd <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/fs/bin/",
      run_check_fs_cmd = function(cmd, ...) {
        captured_cmd <<- cmd
        0
      }
    )

    mri_surf2surf(
      subject = "bert",
      target_subject = "fsaverage",
      hemi = "lh"
    )

    expect_match(captured_cmd, "--s bert")
  })

  it("builds correct target subject argument", {
    captured_cmd <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/fs/bin/",
      run_check_fs_cmd = function(cmd, ...) {
        captured_cmd <<- cmd
        0
      }
    )

    mri_surf2surf(
      subject = "bert",
      target_subject = "fsaverage",
      hemi = "lh"
    )

    expect_match(captured_cmd, "--trgsubject fsaverage")
  })

  it("builds correct source type argument", {
    captured_cmd <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/fs/bin/",
      run_check_fs_cmd = function(cmd, ...) {
        captured_cmd <<- cmd
        0
      }
    )

    mri_surf2surf(
      subject = "bert",
      target_subject = "fsaverage",
      src_type = "curv",
      hemi = "lh"
    )

    expect_match(captured_cmd, "--src_type curv")
  })

  it("builds correct target type argument", {
    captured_cmd <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/fs/bin/",
      run_check_fs_cmd = function(cmd, ...) {
        captured_cmd <<- cmd
        0
      }
    )

    mri_surf2surf(
      subject = "bert",
      target_subject = "fsaverage",
      trg_type = "mgh",
      hemi = "lh"
    )

    expect_match(captured_cmd, "--trg_type mgh")
  })

  it("builds correct sval argument", {
    skip_on_os("windows")

    captured_cmd <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/fs/bin/",
      run_check_fs_cmd = function(cmd, ...) {
        captured_cmd <<- cmd
        0
      }
    )

    mri_surf2surf(
      subject = "bert",
      target_subject = "fsaverage",
      sval = "thickness",
      hemi = "lh"
    )

    expect_match(captured_cmd, "--sval thickness")
  })

  it("adds --debug flag when verbose = TRUE", {
    captured_cmd <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/fs/bin/",
      run_check_fs_cmd = function(cmd, ...) {
        captured_cmd <<- cmd
        0
      }
    )

    mri_surf2surf(
      subject = "bert",
      target_subject = "fsaverage",
      hemi = "lh",
      verbose = TRUE
    )

    expect_match(captured_cmd, "--debug")
  })

  it("does not add --debug flag when verbose = FALSE", {
    captured_cmd <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/fs/bin/",
      run_check_fs_cmd = function(cmd, ...) {
        captured_cmd <<- cmd
        0
      }
    )

    mri_surf2surf(
      subject = "bert",
      target_subject = "fsaverage",
      hemi = "lh",
      verbose = FALSE
    )

    expect_no_match(captured_cmd, "--debug")
  })

  it("includes tval argument for output file", {
    captured_cmd <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/fs/bin/",
      run_check_fs_cmd = function(cmd, ...) {
        captured_cmd <<- cmd
        0
      }
    )

    mri_surf2surf(
      subject = "bert",
      target_subject = "fsaverage",
      hemi = "lh"
    )

    expect_match(captured_cmd, "--tval ")
  })

  it("appends additional opts to command", {
    captured_cmd <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/fs/bin/",
      run_check_fs_cmd = function(cmd, ...) {
        captured_cmd <<- cmd
        0
      }
    )

    mri_surf2surf(
      subject = "bert",
      target_subject = "fsaverage",
      hemi = "lh",
      opts = "--cortex"
    )

    expect_match(captured_cmd, "--cortex")
  })

  it("prefixes output file with hemisphere", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/fs/bin/",
      run_check_fs_cmd = function(cmd, outfile, ...) 0
    )

    result <- mri_surf2surf(
      subject = "bert",
      target_subject = "fsaverage",
      hemi = "rh"
    )

    expect_match(basename(result), "^rh\\.")
  })

  it("validates hemisphere argument", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/fs/bin/",
      run_check_fs_cmd = function(cmd, ...) 0
    )

    expect_error(
      mri_surf2surf(
        subject = "bert",
        target_subject = "fsaverage",
        hemi = "invalid"
      ),
      "'arg' should be one of"
    )
  })

  it("validates trg_type argument", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/fs/bin/",
      run_check_fs_cmd = function(cmd, ...) 0
    )

    expect_error(
      mri_surf2surf(
        subject = "bert",
        target_subject = "fsaverage",
        trg_type = "invalid"
      ),
      "'arg' should be one of"
    )
  })

  it("validates src_type argument", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/fs/bin/",
      run_check_fs_cmd = function(cmd, ...) 0
    )

    expect_error(
      mri_surf2surf(
        subject = "bert",
        target_subject = "fsaverage",
        src_type = "invalid"
      ),
      "'arg' should be one of"
    )
  })

  it("sets SUBJECTS_DIR when subj_dir is provided", {
    skip_on_os("windows")

    captured_cmd <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/fs/bin/",
      run_check_fs_cmd = function(cmd, ...) {
        captured_cmd <<- cmd
        0
      }
    )

    mri_surf2surf(
      subject = "bert",
      target_subject = "fsaverage",
      hemi = "lh",
      subj_dir = "/custom/subjects"
    )

    expect_match(captured_cmd, "export SUBJECTS_DIR=/custom/subjects")
  })

  it("does not set SUBJECTS_DIR when subj_dir is NULL", {
    captured_cmd <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/fs/bin/",
      run_check_fs_cmd = function(cmd, ...) {
        captured_cmd <<- cmd
        0
      }
    )

    mri_surf2surf(
      subject = "bert",
      target_subject = "fsaverage",
      hemi = "lh",
      subj_dir = NULL
    )

    expect_no_match(captured_cmd, "export SUBJECTS_DIR")
  })

  it("passes func_name to run_check_fs_cmd", {
    captured_func_name <- NULL
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "/fs/bin/",
      run_check_fs_cmd = function(cmd, outfile, verbose, func_name, ...) {
        captured_func_name <<- func_name
        0
      }
    )

    mri_surf2surf(
      subject = "bert",
      target_subject = "fsaverage",
      hemi = "lh"
    )

    expect_equal(captured_func_name, "mri_surf2surf")
  })
})

describe("mri_surf2surf.help", {
  it("calls fs_help with correct function name", {
    captured_func <- NULL
    local_mocked_bindings(
      fs_help = function(func, ...) {
        captured_func <<- func
        "help text"
      }
    )

    mri_surf2surf.help()
    expect_equal(captured_func, "mri_surf2surf")
  })
})
