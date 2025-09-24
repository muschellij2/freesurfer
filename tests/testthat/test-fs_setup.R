test_that("have_fs returns TRUE when Freesurfer is accessible and license is not checked", {
  local_mocked_bindings(
    get_fs_home = function(...) list(exists = TRUE),
    get_fs_license = function(...) list(exists = TRUE)
  )
  expect_true(have_fs())
  expect_true(have_fs(check_license = TRUE))
  expect_true(have_fs(check_license = FALSE))
})

test_that("have_fs returns FALSE when Freesurfer is inaccessible and license is not checked", {
  local_mocked_bindings(
    get_fs_home = function(...) list(exists = FALSE)
  )
  expect_false(have_fs())
  expect_false(have_fs(check_license = TRUE))
  expect_false(have_fs(check_license = FALSE))
})

test_that("have_fs returns TRUE when Freesurfer is accessible and license exists", {
  local_mocked_bindings(
    get_fs_home = function(...) list(exists = TRUE),
    get_fs_license = function(...) list(exists = TRUE)
  )
  expect_true(have_fs(check_license = TRUE))
})

test_that("have_fs returns FALSE when Freesurfer is accessible but license is missing", {
  local_mocked_bindings(
    get_fs_home = function(...) list(exists = TRUE),
    get_fs_license = function(...) list(exists = FALSE)
  )
  expect_false(have_fs(check_license = TRUE))
})

test_that("have_fs returns FALSE when Freesurfer is inaccessible and license is checked", {
  local_mocked_bindings(
    get_fs_home = function(...) list(exists = FALSE),
    get_fs_license = function(...) list(exists = TRUE)
  )
  expect_false(have_fs(check_license = TRUE))
})


test_that("get_fs throws error when FREESURFER_HOME is missing or invalid", {
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

test_that("get_fs warns when license file is missing", {
  local_mocked_bindings(
    get_fs_home = function(simplify = FALSE) {
      list(value = "/valid/path", source = "Default", exists = TRUE)
    },
    get_fs_license = function(simplify = FALSE) {
      list(value = NA, source = NA, exists = FALSE)
    }
  )
  expect_warning(
    home <- get_fs(),
    "no license file*"
  )
  expect_true(grepl("export FREESURFER_HOME='/valid/path'", home))
})

test_that("get_fs constructs command for default `bin` directory", {
  local_mocked_bindings(
    get_fs_home = function(simplify = FALSE) {
      list(value = "/valid/path", exists = TRUE, source = "Default")
    },
    get_fs_license = function(simplify = FALSE) {
      list(exists = TRUE)
    },
    get_fs_source = function(simplify = FALSE) {
      list(exists = TRUE, value = "/valid/path/FreeSurferEnv.sh")
    },
    get_fs_output = function() {
      "nii"
    }
  )
  cmd <- get_fs("bin")

  expect_true(grepl("export FREESURFER_HOME='/valid/path'", cmd))
  expect_true(grepl("source '/valid/path/FreeSurferEnv.sh'", cmd))
  expect_true(grepl("FSF_OUTPUT_FORMAT=nii", cmd))
  expect_true(grepl("\\$\\{FREESURFER_HOME\\}/bin/", cmd))
})

test_that("get_fs constructs command for `mni/bin` with MNI initialization", {
  local_mocked_bindings(
    get_fs_home = function(simplify = FALSE) {
      list(value = "/valid/path", exists = TRUE, source = "Default")
    },
    get_fs_license = function(simplify = FALSE) {
      list(exists = TRUE)
    },
    get_fs_source = function(simplify = FALSE) {
      list(exists = TRUE, value = "/valid/path/FreeSurferEnv.sh")
    },
    get_fs_output = function() {
      "nii"
    },
    get_mni_bin = function(simplify = FALSE) {
      list(value = "/valid/path/mni/bin", exists = TRUE, source = "Default")
    }
  )
  cmd <- get_fs("mni/bin")
  expect_true(grepl("export PERL5LIB=\\$PERL5LIB", cmd))
  expect_true(grepl("/mni/bin/", cmd))
})

test_that("get_fs handles case where source file is missing", {
  local_mocked_bindings(
    get_fs_home = function(simplify = FALSE) {
      list(value = "/valid/path", exists = TRUE, source = "Default")
    },
    get_fs_license = function(simplify = FALSE) {
      list(exists = TRUE)
    },
    get_fs_source = function(simplify = FALSE) {
      list(exists = FALSE)
    },
    get_fs_output = function() {
      "nii"
    }
  )
  cmd <- get_fs("bin")
  expect_true(grepl("export FREESURFER_HOME='/valid/path'", cmd))
  expect_true(grepl("FSF_OUTPUT_FORMAT=nii", cmd))
  expect_false(grepl("source", cmd))
})

test_that("get_fs throws error on invalid bin_app argument", {
  local_mocked_bindings(
    get_fs_home = function(simplify = FALSE) {
      list(value = "/valid/path", exists = TRUE, source = "Default")
    }
  )
  expect_error(
    get_fs("invalid"),
    "should be one of"
  )
})


# ---- fs_imgext ---- #

test_that("fs_imgext returns correct extension for output type 'hdr'", {
  local_mocked_bindings(
    get_fs_output = function() {
      "hdr"
    }
  )
  expect_equal(fs_imgext(), ".hdr")
})

test_that("fs_imgext returns correct extension for output type 'nii.gz'", {
  local_mocked_bindings(
    get_fs_output = function() {
      "nii.gz"
    }
  )
  expect_equal(fs_imgext(), ".nii.gz")
})

test_that("fs_imgext returns correct extension for output type 'nii'", {
  local_mocked_bindings(
    get_fs_output = function() {
      "nii"
    }
  )
  expect_equal(fs_imgext(), ".nii")
})

test_that("fs_imgext returns NULL for unsupported output types", {
  local_mocked_bindings(
    get_fs_output = function() {
      "unsupported_type"
    }
  )
  expect_null(fs_imgext())
})

test_that("fs_imgext handles edge case where get_fs_output returns NULL", {
  local_mocked_bindings(
    get_fs_output = function() {
      NULL
    }
  )
  expect_error(
    fs_imgext()
  )
})

test_that("fs_imgext handles edge case where get_fs_output returns an empty string", {
  local_mocked_bindings(
    get_fs_output = function() {
      ""
    }
  )
  expect_null(fs_imgext())
})

# ---- fsdir ---- #

test_that("freesurferdir calls get_fs_home and returns its value", {
  local_mocked_bindings(
    get_fs_home = function() {
      "/valid/path/to/freesurfer"
    }
  )
  expect_equal(freesurferdir(), "/valid/path/to/freesurfer")
})

test_that("freesurferdir handles case where get_fs_home returns NULL", {
  local_mocked_bindings(
    get_fs_home = function() {
      NULL
    }
  )
  expect_null(freesurferdir())
})

test_that("freesurferdir handles empty string returned by get_fs_home", {
  local_mocked_bindings(
    get_fs_home = function() {
      ""
    }
  )
  expect_equal(freesurferdir(), "")
})

test_that("freesurfer_dir is identical to freesurferdir", {
  local_mocked_bindings(
    get_fs_home = function() {
      "/valid/path/to/freesurfer"
    }
  )
  expect_equal(freesurfer_dir(), freesurferdir())
})

test_that("fs_dir is identical to freesurferdir", {
  local_mocked_bindings(
    get_fs_home = function() {
      "/valid/path/to/freesurfer"
    }
  )
  expect_equal(fs_dir(), freesurferdir())
})

# ---- fs_subj_dir ---- #

test_that("fs_subj_dir calls get_fs_subdir and returns its value", {
  local_mocked_bindings(
    get_fs_subdir = function() {
      "/valid/path/to/subjects"
    }
  )
  expect_equal(fs_subj_dir(), "/valid/path/to/subjects")
})

test_that("fs_subj_dir returns NULL when get_fs_subdir returns NULL", {
  local_mocked_bindings(
    get_fs_subdir = function() {
      NULL
    }
  )
  expect_null(fs_subj_dir())
})

test_that("fs_subj_dir handles empty string returned by get_fs_subdir", {
  local_mocked_bindings(
    get_fs_subdir = function() {
      ""
    }
  )
  expect_equal(fs_subj_dir(), "")
})

test_that("fs_subj_dir works when SUBJECTS_DIR is set via environment variable", {
  withr::local_envvar(SUBJECTS_DIR = "/mocked/env/subjects")
  expect_equal(fs_subj_dir(), "/mocked/env/subjects")
})

test_that("fs_subj_dir works when SUBJECTS_DIR is set via R options", {
  withr::local_options(freesurfer.subj_dir = "/mocked/option/subjects")

  expect_equal(fs_subj_dir(), "/mocked/option/subjects")
})

test_that("fs_subj_dir prioritizes R options over environment variable", {
  withr::local_envvar(SUBJECTS_DIR = "/mocked/env/subjects")
  withr::local_options(freesurfer.subj_dir = "/mocked/option/subjects")
  expect_equal(fs_subj_dir(), "/mocked/option/subjects")
})
