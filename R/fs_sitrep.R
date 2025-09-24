#' Freesurfer Situation Report
#'
#' Get a situation report on your current Freesurfer installation and settings
#' within R. This function helps diagnose problems by showing how Freesurfer
#' paths and options are determined.
#'
#' @export
#' @examplesIf have_fs()
#' # Report all Freesurfer settings
#' fs_sitrep()
fs_sitrep <- function() {
  cli::cli_h2("Freesurfer Setup Report")

  alert_info(
    get_fs_home(simplify = FALSE),
    "Freesurfer Directory"
  )

  alert_info(
    get_fs_source(simplify = FALSE),
    "Source script"
  )

  alert_info(
    get_fs_license(simplify = FALSE),
    "License File"
  )

  alert_info(
    get_fs_subdir(simplify = FALSE),
    "Subjects Directory",
  )

  alert_info(
    get_fs_verbosity(simplify = FALSE),
    "Verbose mode",
  )

  alert_info(
    get_mni_bin(simplify = FALSE),
    "MNI functionality"
  )

  alert_info(
    get_fs_output(simplify = FALSE),
    "Output Format"
  )

  # --- Testing installation ---- #

  cli::cli_h3("Testing R and Freesurfer communication.")
  cli::cli_li("Version: {.val {fs_version()}}")
  cli::cli_li("Shell set to {.val {Sys.getenv('SHELL')}}")
  cli::cli_li("Running {.code mri_info()}")

  mri_info_help <- suppressMessages(
    mri_info.help()
  )
  if (
    grepl("USAGE:", mri_info_help[1]) && grepl("mri_info", mri_info_help[1])
  ) {
    cli::cli_alert_success(
      "R and Freesurfer are working together."
    )
  } else {
    cli::cli_alert_danger(
      "Freesurfer and R are not working together."
    )
    cli::cli_code(mri_info_help)
  }

  invisible()
}

#' @noRd
alert_info <- function(settings, header, error = "Unable to detect.") {
  cli::cli_h3(header)

  if (all(is.na(settings$value))) {
    cli::cli_li(error)
    return()
  }

  if (length(settings$value) > 1) {
    cli::cli_alert_warning(
      "Multiple possible values found"
    )
    cli::cli_li(settings$value)
    cli::cli_alert_info(
      "Consider setting wanted value with {.code options}. 
      Continuing with first valid setting."
    )
    settings <- return_single(settings)
  }

  cli::cli_li("{.val {settings$value}}")

  if (is.na(settings$source)) {
    cli::cli_alert_danger(
      "Source indeterminable"
    )
  } else if (grepl("Default", settings$source)) {
    cli::cli_alert_warning(
      "Determined from: {.code {settings$source}}"
    )
  } else {
    cli::cli_alert_info("Determined from: {.code {settings$source}}")
  }

  if (is.na(settings$exists)) {} else if (settings$exists) {
    cli::cli_alert_success("Path exists")
  } else {
    cli::cli_alert_danger(
      "Path does not exist"
    )
  }
}
