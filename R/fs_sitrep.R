# Final R/fs_sitrep.R - Clean system diagnostics

#' FreeSurfer Situation Report
#'
#' Get a situation report on your current FreeSurfer installation and settings
#' within R. This function helps diagnose problems by showing how FreeSurfer
#' paths and options are determined.
#'
#' @param clear_cache (logical) Whether to clear settings cache before reporting
#' @param test_commands (logical) Whether to test actual FreeSurfer commands
#' @export
#' @examplesIf have_fs()
#' # Report all FreeSurfer settings
#' fs_sitrep()
fs_sitrep <- function(clear_cache = FALSE, test_commands = TRUE) {
  fs_home <- get_fs_home(simplify = FALSE)
  license_info <- get_fs_license(simplify = FALSE)
  verbosity <- get_fs_verbosity(simplify = FALSE)

  cli::cli_h2("FreeSurfer Setup Report")

  # Core settings - simple and clean
  alert_info(fs_home, "FreeSurfer Directory")
  alert_info(
    get_fs_source(
      fs_home = fs_home$value,
      simplify = FALSE
    ),
    "Source script"
  )
  alert_info(license_info, "License File")
  alert_info(
    get_fs_subdir(fs_home = fs_home$value, simplify = FALSE),
    "Subjects Directory"
  )
  alert_info(verbosity, "Verbose mode")
  alert_info(
    get_mni_bin(fs_home = fs_home$value, simplify = FALSE),
    "MNI functionality"
  )
  alert_info(
    get_fs_output(simplify = FALSE),
    "Output Format"
  )

  # System information
  sysinfo <- sys_info()
  cli::cli_h3("System Information")
  cli::cli_li("Operating System: {.val {sysinfo$platform}}")
  cli::cli_li("R Version: {.val {sysinfo$r_version}}")
  cli::cli_li("Shell: {.val {sysinfo$shell}}")

  # Testing installation
  if (test_commands) {
    cli::cli_h3("Testing R and FreeSurfer Communication")

    # Test basic availability
    if (!have_fs()) {
      cli::cli_alert_danger("FreeSurfer installation not detected")
      cli::cli_li(
        "Use {.code options(freesurfer.home = '/path/to/freesurfer')} to set location"
      )
      return(invisible())
    }

    # Test version
    version_info <- fs_version()
    cli::cli_li("Version: {.val {version_info}}")

    # Test command execution - simple approach
    cli::cli_li("Testing command execution with {.code mri_info --help}")

    mri_info_result <- suppressMessages(mri_info.help())

    if (is.character(mri_info_result) && length(mri_info_result) > 0) {
      if (any(grepl("USAGE:|mri_info", mri_info_result, ignore.case = TRUE))) {
        cli::cli_alert_success("R and FreeSurfer are working together")
        cli::cli_li("Command test successful")
      } else {
        cli::cli_alert_warning(
          "FreeSurfer command executed but output format unexpected"
        )
        if (verbosity$value) {
          cli::cli_li(
            "Output preview: {.val {paste(head(mri_info_result, 2), collapse = ' | ')}}"
          )
        }
      }
    } else {
      cli::cli_alert_danger("FreeSurfer and R are not working together")
      cli::cli_li("Command execution failed or returned no output")
    }
  }

  # Simple recommendations
  cli::cli_h3("Recommendations")

  if (is.na(fs_home$value)) {
    cli::cli_li(
      "Set FreeSurfer home: {.code options(freesurfer.home = '/path/to/freesurfer')}"
    )
  } else if (is.na(license_info$value) || !license_info$exists) {
    cli::cli_li("Install FreeSurfer license file in {fs_home$value}")
  } else if (!verbosity$value) {
    cli::cli_li(
      "Enable verbose mode for better debugging: {.code options(freesurfer.verbose = TRUE)}"
    )
  } else {
    cli::cli_alert_success("FreeSurfer setup looks good!")
  }

  invisible()
}

#' Simple alert_info helper
#' @param settings FreeSurfer settings object
#' @param header Section header
#' @noRd
alert_info <- function(settings, header) {
  cli::cli_h3(header)

  if (is.null(settings) || all(is.na(settings$value))) {
    cli::cli_li("Unable to detect")
    return()
  }

  if (length(settings$value) > 1) {
    cli::cli_alert_warning("Multiple possible values found")
    for (val in settings$value) {
      cli::cli_li("{.val {val}}")
    }
    cli::cli_alert_info("Consider setting preferred value with {.code options}")
    settings <- return_single(settings)
  }

  cli::cli_li("{.val {settings$value}}")

  # Source information
  if (!is.na(settings$source)) {
    if (grepl("Default|Not found", settings$source, ignore.case = TRUE)) {
      cli::cli_alert_warning("Determined from: {.code {settings$source}}")
    } else {
      cli::cli_alert_info("Determined from: {.code {settings$source}}")
    }
  }

  # Path existence
  if (!is.na(settings$exists)) {
    if (settings$exists) {
      cli::cli_alert_success("Path exists")
    } else {
      cli::cli_alert_danger("Path does not exist")
    }
  }
}
