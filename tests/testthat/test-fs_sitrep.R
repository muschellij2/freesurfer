# Helper function to simulate fs settings
mock_fs_settings <- function(value = NA, source = NA, exists = NA) {
  list(
    value = value,
    source = source,
    exists = exists
  )
}

test_that("fs_sitrep runs successfully", {
  local_fs_unset()
  local_mocked_bindings(
    have_fs = function() TRUE,
    get_fs_home = function(simplify) {
      mock_fs_settings(
        value = "/mock/home",
        source = "ENV_VAR",
        exists = TRUE
      )
    },
    get_fs_source = function(simplify, ...) {
      mock_fs_settings(
        value = "/mock/source.sh",
        source = "Default",
        exists = TRUE
      )
    },
    get_fs_license = function(simplify, ...) {
      mock_fs_settings(value = NA, source = NA, exists = NA)
    },
    get_fs_subdir = function(simplify, ...) {
      mock_fs_settings(
        value = "/mock/subjects",
        source = "ENV_VAR",
        exists = FALSE
      )
    },
    get_fs_verbosity = function(simplify, ...) {
      mock_fs_settings(
        value = "high",
        source = "Option",
        exists = NA
      )
    },
    get_mni_bin = function(simplify, ...) {
      mock_fs_settings(
        value = "/mock/mni/bin",
        source = "ENV_VAR",
        exists = TRUE
      )
    },
    get_fs_output = function(simplify) {
      mock_fs_settings(value = "nii", source = "Default", exists = TRUE)
    },
    fs_version = function() "7.3.2",
    mri_info.help = function() {
      c("USAGE: mri_info <options> inputs...", "Example usage")
    },
    sys_info = function() {
      list(
        platform = "mockOS 1.0",
        r_version = "R 4.2.0",
        shell = "/bin/mocksh"
      )
    }
  )

  # Check that running fs_sitrep doesn't throw errors and capture the
  # primary 'FreeSurfer Setup Report' message to reduce noisy output
  expect_snapshot(
    fs_sitrep()
  )
})

test_that("alert_info correctly handles various scenarios", {
  # Case: All settings NA
  expect_snapshot(
    alert_info(
      mock_fs_settings(value = NA, source = NA, exists = NA),
      "Test Header"
    )
  )

  # Case: Multiple possible values
  expect_snapshot(
    alert_info(
      mock_fs_settings(
        value = c("/path1", "/path2"),
        source = "Default",
        exists = TRUE
      ),
      "Test Header"
    )
  )

  # Case: Single valid value, path exists
  expect_snapshot(
    alert_info(
      mock_fs_settings(
        value = "/valid/path",
        source = "Set via R Option",
        exists = TRUE
      ),
      "Test Header"
    )
  )

  # Case: Single valid value, path does not exist
  expect_snapshot(
    alert_info(
      mock_fs_settings(
        value = "/invalid/path",
        source = "Set via R Option",
        exists = FALSE
      ),
      "Path does not exist"
    )
  )

  # Case: Source indeterminable
  expect_snapshot(
    alert_info(
      mock_fs_settings(value = "/unknown/source", source = NA, exists = FALSE),
      "Test Header"
    )
  )
})

test_that("alert_info provides expected warnings for default values", {
  # Case: Default value is used
  expect_snapshot(
    alert_info(
      mock_fs_settings(
        value = "default_value",
        source = "Default",
        exists = TRUE
      ),
      "Test Header"
    )
  )
})
