# Helper function to simulate fs settings
mock_fs_settings <- function(value = NA, source = NA, exists = NA) {
  list(value = value, source = source, exists = exists)
}

test_that("fs_sitrep runs successfully", {
  local_mocked_bindings(
    get_fs_home = function(simplify) {
      mock_fs_settings(
        value = "/mock/home",
        source = "ENV_VAR",
        exists = TRUE
      )
    },
    get_fs_source = function(simplify) {
      mock_fs_settings(
        value = "/mock/source.sh",
        source = "Default",
        exists = TRUE
      )
    },
    get_fs_license = function(simplify) {
      mock_fs_settings(value = NA, source = NA, exists = NA)
    },
    get_fs_subdir = function(simplify) {
      mock_fs_settings(
        value = "/mock/subjects",
        source = "ENV_VAR",
        exists = FALSE
      )
    },
    get_fs_verbosity = function(simplify) {
      mock_fs_settings(
        value = "high",
        source = "Option",
        exists = TRUE
      )
    },
    get_mni_bin = function(simplify) {
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
    }
  )

  # Check that running fs_sitrep doesn't throw errors or warnings
  expect_message(fs_sitrep())
})

test_that("fs_sitrep handles R and Freesurfer communication failures", {
  # Simulate a communication failure between R and Freesurfer
  local_mocked_bindings(
    get_fs_home = function(simplify) {
      mock_fs_settings(value = "/mock/home", source = "ENV_VAR", exists = TRUE)
    },
    mri_info.help = function() "Error: Command not found",
    get_fs_license = function(...) {
      mock_fs_settings(value = NA, source = NA, exists = TRUE)
    },
    fs_version = function() "7.3.2"
  )

  # Ensure that fs_sitrep captures the failure gracefully
  expect_message(
    fs_sitrep(),
    "Freesurfer and R are not working together"
  )
})

test_that("alert_info correctly handles various scenarios", {
  # Case: All settings NA
  expect_message(
    alert_info(
      mock_fs_settings(value = NA, source = NA, exists = NA),
      "Test Header"
    ),
    "Unable to detect\\."
  )

  # Case: Multiple possible values
  expect_message(
    alert_info(
      mock_fs_settings(
        value = c("/path1", "/path2"),
        source = "Default",
        exists = TRUE
      ),
      "Test Header"
    ),
    "Multiple possible values found"
  )

  # Case: Single valid value, path exists
  expect_message(
    alert_info(
      mock_fs_settings(
        value = "/valid/path",
        source = "Set via R Option",
        exists = TRUE
      ),
      "Test Header"
    ),
    "Path exists"
  )

  # Case: Single valid value, path does not exist
  expect_message(
    alert_info(
      mock_fs_settings(
        value = "/invalid/path",
        source = "Set via R Option",
        exists = FALSE
      ),
      "Path does not exist"
    ),
    "Path does not exist"
  )

  # Case: Source indeterminable
  expect_message(
    alert_info(
      mock_fs_settings(value = "/unknown/source", source = NA, exists = TRUE),
      "Test Header"
    ),
    "Source indeterminable"
  )
})

test_that("alert_info provides expected warnings for default values", {
  # Case: Default value is used
  expect_message(
    alert_info(
      mock_fs_settings(
        value = "default_value",
        source = "Default",
        exists = TRUE
      ),
      "Test Header"
    ),
    "Default"
  )
})
