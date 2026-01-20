# Helper function to simulate fs settings
mock_fs_settings <- function(value = NA, source = NA, exists = NA) {
  list(
    value = value,
    source = source,
    exists = exists
  )
}

cli::test_that_cli("fs_sitrep() runs successfully", {
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

cli::test_that_cli("fs_sitrep()  alert_info correctly handles various scenarios", {
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
      mock_fs_settings(
        value = "/unknown/source",
        source = NA,
        exists = FALSE
      ),
      "Test Header"
    )
  )
})

cli::test_that_cli("fs_sitrep()  alert_info provides expected warnings for default values", {
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

cli::test_that_cli("fs_sitrep()  returns early when FreeSurfer is not available", {
  local_fs_unset()
  local_mocked_bindings(
    have_fs = function() FALSE,
    get_fs_home = function(simplify) {
      mock_fs_settings(value = NA, source = NA, exists = FALSE)
    },
    get_fs_source = function(simplify, ...) {
      mock_fs_settings(value = NA, source = NA, exists = FALSE)
    },
    get_fs_license = function(simplify, ...) {
      mock_fs_settings(value = NA, source = NA, exists = FALSE)
    },
    get_fs_subdir = function(simplify, ...) {
      mock_fs_settings(value = NA, source = NA, exists = FALSE)
    },
    get_fs_verbosity = function(simplify, ...) {
      mock_fs_settings(value = FALSE, source = NA, exists = NA)
    },
    get_mni_bin = function(simplify, ...) {
      mock_fs_settings(value = NA, source = NA, exists = FALSE)
    },
    get_fs_output = function(simplify) {
      mock_fs_settings(value = NA, source = NA, exists = FALSE)
    },
    sys_info = function() {
      list(platform = "test", r_version = "4.0.0", shell = "/bin/sh")
    }
  )

  expect_snapshot(
    fs_sitrep(test_commands = TRUE)
  )
})

cli::test_that_cli("fs_sitrep()  handles unexpected mri_info output format", {
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
      mock_fs_settings(
        value = "/mock/license.txt",
        source = "ENV",
        exists = TRUE
      )
    },
    get_fs_subdir = function(simplify, ...) {
      mock_fs_settings(
        value = "/mock/subjects",
        source = "ENV_VAR",
        exists = TRUE
      )
    },
    get_fs_verbosity = function(simplify, ...) {
      mock_fs_settings(value = TRUE, source = "Option", exists = NA)
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
      c("Unexpected output that doesn't match pattern")
    },
    sys_info = function() {
      list(platform = "test", r_version = "4.0.0", shell = "/bin/sh")
    }
  )

  expect_snapshot(
    fs_sitrep(test_commands = TRUE)
  )
})

cli::test_that_cli("fs_sitrep()  handles failed mri_info command", {
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
      mock_fs_settings(
        value = "/mock/license.txt",
        source = "ENV",
        exists = TRUE
      )
    },
    get_fs_subdir = function(simplify, ...) {
      mock_fs_settings(
        value = "/mock/subjects",
        source = "ENV_VAR",
        exists = TRUE
      )
    },
    get_fs_verbosity = function(simplify, ...) {
      mock_fs_settings(value = FALSE, source = "Option", exists = NA)
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
      NULL
    },
    sys_info = function() {
      list(platform = "test", r_version = "4.0.0", shell = "/bin/sh")
    }
  )

  expect_snapshot(
    fs_sitrep(test_commands = TRUE)
  )
})

cli::test_that_cli("fs_sitrep()  skips command testing when test_commands = FALSE", {
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
      mock_fs_settings(
        value = "/mock/license.txt",
        source = "ENV",
        exists = TRUE
      )
    },
    get_fs_subdir = function(simplify, ...) {
      mock_fs_settings(
        value = "/mock/subjects",
        source = "ENV_VAR",
        exists = TRUE
      )
    },
    get_fs_verbosity = function(simplify, ...) {
      mock_fs_settings(value = TRUE, source = "Option", exists = NA)
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
    sys_info = function() {
      list(platform = "test", r_version = "4.0.0", shell = "/bin/sh")
    }
  )

  expect_snapshot(
    fs_sitrep(test_commands = FALSE)
  )
})

cli::test_that_cli("fs_sitrep()  recommends setting home when fs_home is NA", {
  local_fs_unset()
  local_mocked_bindings(
    have_fs = function() TRUE,
    get_fs_home = function(simplify) {
      mock_fs_settings(value = NA, source = NA, exists = FALSE)
    },
    get_fs_source = function(simplify, ...) {
      mock_fs_settings(value = NA, source = NA, exists = FALSE)
    },
    get_fs_license = function(simplify, ...) {
      mock_fs_settings(value = NA, source = NA, exists = FALSE)
    },
    get_fs_subdir = function(simplify, ...) {
      mock_fs_settings(value = NA, source = NA, exists = FALSE)
    },
    get_fs_verbosity = function(simplify, ...) {
      mock_fs_settings(value = FALSE, source = NA, exists = NA)
    },
    get_mni_bin = function(simplify, ...) {
      mock_fs_settings(value = NA, source = NA, exists = FALSE)
    },
    get_fs_output = function(simplify) {
      mock_fs_settings(value = NA, source = NA, exists = FALSE)
    },
    fs_version = function() "7.0.0",
    mri_info.help = function() c("USAGE: mri_info"),
    sys_info = function() {
      list(platform = "test", r_version = "4.0.0", shell = "/bin/sh")
    }
  )

  expect_snapshot(
    fs_sitrep(test_commands = TRUE)
  )
})

describe("fs_sitrep integration", {
  it("runs without error when FreeSurfer is available", {
    skip_if_no_freesurfer()
    withr::local_options(freesurfer.verbose = FALSE)
    expect_no_error(fs_sitrep())
  })
})
