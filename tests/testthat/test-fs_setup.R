describe("have_fs", {
  it("returns TRUE when FreeSurfer accessible with license", {
    local_mocked_bindings(
      get_fs_home = function(...) list(exists = TRUE),
      get_fs_license = function(...) list(exists = TRUE)
    )
    expect_true(have_fs())
    expect_true(have_fs(check_license = TRUE))
    expect_true(have_fs(check_license = FALSE))
  })

  it("returns FALSE when FreeSurfer inaccessible", {
    local_mocked_bindings(
      get_fs_home = function(...) list(exists = FALSE)
    )
    expect_false(have_fs())
    expect_false(have_fs(check_license = TRUE))
    expect_false(have_fs(check_license = FALSE))
  })

  it("returns FALSE when license missing and check_license = TRUE", {
    local_mocked_bindings(
      get_fs_home = function(...) list(exists = TRUE),
      get_fs_license = function(...) list(exists = FALSE)
    )
    expect_false(have_fs(check_license = TRUE))
  })

  it("returns FALSE when FreeSurfer inaccessible even with license", {
    local_mocked_bindings(
      get_fs_home = function(...) list(exists = FALSE),
      get_fs_license = function(...) list(exists = TRUE)
    )
    expect_false(have_fs(check_license = TRUE))
  })
})

describe("get_fs", {
  it("errors when FREESURFER_HOME missing", {
    local_mocked_bindings(
      get_fs_home = function(simplify = FALSE) {
        list(value = NULL, exists = FALSE)
      }
    )
    expect_error(
      get_fs(),
      "Can't find Freesurfer installation.*"
    )
  })

  it("warns when license file missing", {
    local_mocked_bindings(
      get_fs_home = function(simplify = TRUE) {
        ret <- list(
          exists = TRUE,
          source = "Default",
          value = "/valid/path"
        )
        if (simplify) return(ret$value)
        ret
      },
      get_fs_license = function(simplify = FALSE) {
        list(value = NA, source = NA, exists = FALSE)
      }
    )
    expect_warning(
      home <- get_fs(),
      "no license file*"
    )
    expect_match(home, "export FREESURFER_HOME=['\"]")
  })

  it("constructs command for default bin directory", {
    local_mocked_bindings(
      get_fs_home = function(simplify = FALSE) {
        list(value = "/valid/path", exists = TRUE, source = "Default")
      },
      get_fs_license = function(simplify = FALSE) list(exists = TRUE),
      get_fs_source = function(simplify = FALSE) {
        list(exists = TRUE, value = "/valid/path/FreeSurferEnv.sh")
      },
      get_fs_output = function() "nii"
    )
    cmd <- get_fs("bin")

    expect_match(cmd, "export FREESURFER_HOME=['\"]")
    expect_match(cmd, "source ['\"]")
    expect_match(cmd, "FSF_OUTPUT_FORMAT=nii")
    expect_match(cmd, "\\$\\{FREESURFER_HOME\\}/bin/")
  })

  it("constructs command for mni/bin with MNI initialization", {
    local_mocked_bindings(
      get_fs_home = function(simplify = FALSE) {
        list(value = "/valid/path", exists = TRUE, source = "Default")
      },
      get_fs_license = function(simplify = FALSE) list(exists = TRUE),
      get_fs_source = function(simplify = FALSE) {
        list(exists = TRUE, value = "/valid/path/FreeSurferEnv.sh")
      },
      get_fs_output = function() "nii",
      get_mni_bin = function(simplify = FALSE) {
        list(value = "/valid/path/mni/bin", exists = TRUE, source = "Default")
      }
    )
    cmd <- get_fs("mni/bin")

    expect_true(grepl("export PERL5LIB=\\$PERL5LIB", cmd))
    expect_true(grepl("/mni/bin/", cmd))
  })

  it("handles missing source file", {
    local_mocked_bindings(
      get_fs_home = function(simplify = FALSE) {
        ret <- list(value = "/valid/path", exists = TRUE, source = "Default")
        if (simplify) return(ret$value)
        ret
      },
      get_fs_license = function(simplify = FALSE) list(exists = TRUE),
      get_fs_source = function(simplify = FALSE) list(exists = FALSE),
      get_fs_output = function() "nii"
    )
    cmd <- get_fs("bin")

    expect_match(cmd, "export FREESURFER_HOME=['\"]")
    expect_match(cmd, "FSF_OUTPUT_FORMAT=nii")
    expect_false(grepl("source", cmd))
  })

  it("errors on invalid bin_app argument", {
    local_mocked_bindings(
      get_fs_home = function(simplify = TRUE) {
        ret <- list(value = "/valid/path", exists = TRUE, source = "Default")
        if (simplify) return(ret$value)
        ret
      },
      get_fs_license = mock_get_license
    )
    expect_error(
      get_fs("invalid"),
      "should be one of"
    )
  })
})

describe("fs_imgext", {
  it("returns .hdr for output type hdr", {
    local_mocked_bindings(get_fs_output = function() "hdr")
    expect_equal(fs_imgext(), ".hdr")
  })

  it("returns .nii.gz for output type nii.gz", {
    local_mocked_bindings(get_fs_output = function() "nii.gz")
    expect_equal(fs_imgext(), ".nii.gz")
  })

  it("returns .nii for output type nii", {
    local_mocked_bindings(get_fs_output = function() "nii")
    expect_equal(fs_imgext(), ".nii")
  })

  it("returns NULL for unsupported output types", {
    local_mocked_bindings(get_fs_output = function() "unsupported_type")
    expect_null(fs_imgext())
  })

  it("errors when get_fs_output returns NULL", {
    local_mocked_bindings(get_fs_output = function() NULL)
    expect_error(fs_imgext())
  })

  it("returns NULL when get_fs_output returns empty string", {
    local_mocked_bindings(get_fs_output = function() "")
    expect_null(fs_imgext())
  })
})

describe("freesurferdir", {
  it("returns value from get_fs_home", {
    local_mocked_bindings(
      get_fs_home = function() "/valid/path/to/freesurfer"
    )
    expect_equal(freesurferdir(), "/valid/path/to/freesurfer")
  })

  it("returns NULL when get_fs_home returns NULL", {
    local_mocked_bindings(get_fs_home = function() NULL)
    expect_null(freesurferdir())
  })

  it("returns empty string when get_fs_home returns empty", {
    local_mocked_bindings(get_fs_home = function() "")
    expect_equal(freesurferdir(), "")
  })

  it("is identical to freesurfer_dir alias", {
    local_mocked_bindings(
      get_fs_home = function() "/valid/path/to/freesurfer"
    )
    expect_equal(freesurfer_dir(), freesurferdir())
  })

  it("is identical to fs_dir alias", {
    local_mocked_bindings(
      get_fs_home = function() "/valid/path/to/freesurfer"
    )
    expect_equal(fs_dir(), freesurferdir())
  })
})

describe("fs_subj_dir", {
  it("returns value from get_fs_subdir", {
    local_mocked_bindings(
      get_fs_subdir = function() "/valid/path/to/subjects"
    )
    expect_equal(fs_subj_dir(), "/valid/path/to/subjects")
  })

  it("returns NULL when get_fs_subdir returns NULL", {
    local_mocked_bindings(get_fs_subdir = function() NULL)
    expect_null(fs_subj_dir())
  })

  it("returns empty string when get_fs_subdir returns empty", {
    local_mocked_bindings(get_fs_subdir = function() "")
    expect_equal(fs_subj_dir(), "")
  })

  it("reads from SUBJECTS_DIR environment variable", {
    sub_dir <- "/mocked/env/subjects"
    withr::local_envvar(SUBJECTS_DIR = sub_dir)
    expect_equal(
      normalizePath(fs_subj_dir(), mustWork = FALSE),
      normalizePath(sub_dir, mustWork = FALSE)
    )
  })

  it("reads from freesurfer.subj_dir R option", {
    local_fs_unset()
    sub_dir <- "/mocked/option/subjects"
    withr::local_options(freesurfer.subj_dir = sub_dir)

    expect_equal(
      normalizePath(fs_subj_dir(), mustWork = FALSE),
      normalizePath(sub_dir, mustWork = FALSE)
    )
  })

  it("prioritizes R option over environment variable", {
    local_fs_unset()
    sub_dir <- "/mocked/option/subjects"
    withr::local_envvar(SUBJECTS_DIR = sub_dir)
    withr::local_options(freesurfer.subj_dir = sub_dir)

    expect_equal(
      normalizePath(fs_subj_dir(), mustWork = FALSE),
      normalizePath(sub_dir, mustWork = FALSE)
    )
  })
})

describe("fs_setup integration", {
  it("have_fs returns TRUE when FreeSurfer installed", {
    skip_if_no_freesurfer()
    expect_true(have_fs())
  })

  it("fs_dir returns existing directory", {
    skip_if_no_freesurfer()
    fs_home <- fs_dir()
    expect_true(dir.exists(fs_home))
  })

  it("fs_version returns valid version string", {
    skip_if_no_freesurfer()
    version <- fs_version()
    expect_type(version, "character")
    expect_match(version, "freesurfer", ignore.case = TRUE)
  })
})
