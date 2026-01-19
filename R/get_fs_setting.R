#' Retrieve FreeSurfer Configuration Settings
#'
#' @description
#' These functions retrieve FreeSurfer configuration settings using a
#' hierarchical lookup system: R options → environment variables → defaults.
#'
#' @details
#' ## Lookup Hierarchy
#' Settings are resolved in the following order (first match wins):
#' 1. **R options** (set with `options()`)
#' 2. **Environment variables** (set with `Sys.setenv()`)
#' 3. **Default paths** (platform-specific)
#'
#' ## Setting Options
#' You can set R options in your `.Rprofile`:
#' ```r
#' options(
#'   freesurfer.home = "/usr/local/freesurfer",
#'   freesurfer.subj_dir = "~/freesurfer_subjects",
#'   freesurfer.verbose = TRUE
#' )
#' ```
#'
#' @param env_var Character; name of the environment variable to check.
#' @param opt_var Character; name of the R option to check.
#' @param defaults Character vector of default paths to try.
#' @param is_path Logical; whether this setting represents a file/directory path.
#' @param simplify Logical; if `TRUE`, returns only the value. If `FALSE`,
#'   returns a list with detailed information (value, source, exists).
#' @param fs_home Character; FreeSurfer home directory.
#'
#' @return
#' When `simplify = TRUE`: Character string with the setting value, or `NA`.
#' When `simplify = FALSE`: List with `value`, `source`, and `exists` components.
#'
#' @seealso
#' [have_fs()] to check if FreeSurfer is accessible,
#' [fs_sitrep()] for comprehensive diagnostics,
#' [get_fs()] to generate environment setup commands
#'
#' @name get_fs_setting
#' @examples
#' # Get FreeSurfer home directory
#' fs_home <- get_fs_home()
#'
#' # Get detailed information
#' fs_home_info <- get_fs_home(simplify = FALSE)
#'
#' # Check license file
#' license <- get_fs_license()
#'
#' # Get subjects directory
#' subj_dir <- get_fs_subdir()
#'
#' # Check output format
#' format <- get_fs_output()  # Returns "nii.gz", "nii", "mgz", etc.
#'
#' # Check verbosity
#' verbose <- get_fs_verbosity()  # Returns TRUE/FALSE
#'
#' \dontrun{
#' # Set custom options
#' options(freesurfer.home = "/custom/path/freesurfer")
#' get_fs_home()  # Returns: "/custom/path/freesurfer"
#' }
NULL

#' @describeIn get_fs_setting Core function for retrieving settings
#' @export
get_fs_setting <- function(
  env_var,
  opt_var,
  defaults = NULL,
  is_path = TRUE
) {
  # Check R option first
  original_opt <- getOption(opt_var)
  if (!is.null(original_opt) && nzchar(as.character(original_opt))) {
    return(return_setting(
      as.character(original_opt),
      paste("R option:", opt_var),
      is_path
    ))
  }

  # Check environment variable
  original_env <- Sys.getenv(env_var)
  if (nzchar(original_env)) {
    return(return_setting(
      original_env,
      paste("Environment variable:", env_var),
      is_path
    ))
  }

  # Try defaults
  if (!is.null(defaults)) {
    if (is_path) {
      # Find first existing default
      existing_defaults <- batch_file_exists(
        defaults,
        error = FALSE,
        warn = FALSE
      )
      valid_defaults <- defaults[existing_defaults]

      if (length(valid_defaults) > 0) {
        return(return_setting(
          valid_defaults[1],
          "Default path",
          TRUE
        ))
      }
    } else {
      # For non-paths, just return first default
      return(return_setting(
        defaults[1],
        "Default value",
        FALSE
      ))
    }
  }
  # Nothing found
  return_setting(
    NA,
    "Not found",
    is_path
  )
}

#' @describeIn get_fs_setting Retrieve FreeSurfer installation directory
#' @export
get_fs_home <- function(simplify = TRUE) {
  ret <- get_fs_setting(
    "FREESURFER_HOME",
    "freesurfer.home",
    c(
      "/usr/freesurfer",
      "/usr/bin/freesurfer",
      "/usr/local/freesurfer",
      "/Applications/freesurfer"
    )
  )
  if (simplify) {
    return(ret$value)
  }
  ret
}

#' @describeIn get_fs_setting Retrieve FreeSurfer license file path
#' @export
get_fs_license <- function(
  fs_home = get_fs_home(),
  simplify = TRUE
) {
  if (is.na(fs_home)) {
    ret <- return_setting(NA, "FreeSurfer home not found", TRUE)
    if (simplify) {
      return(ret$value)
    }
    return(ret)
  }

  ret <- get_fs_setting(
    "FS_LICENSE",
    "freesurfer.license",
    c(
      file.path(fs_home, ".license"),
      file.path(fs_home, "license.txt")
    )
  )

  if (simplify) {
    return(ret$value)
  }
  ret
}

#' @describeIn get_fs_setting Retrieve FreeSurfer subjects directory
#' @export
get_fs_subdir <- function(
  fs_home = get_fs_home(),
  simplify = TRUE
) {
  default_subj_dir <- if (!is.na(fs_home)) {
    file.path(fs_home, "subjects")
  } else {
    NULL
  }

  ret <- get_fs_setting(
    "SUBJECTS_DIR",
    "freesurfer.subj_dir",
    default_subj_dir
  )

  if (simplify) {
    return(ret$value)
  }
  ret
}

#' @describeIn get_fs_setting Retrieve FreeSurfer source script path
#' @export
get_fs_source <- function(
  fs_home = get_fs_home(),
  simplify = TRUE
) {
  default_source <- if (!is.na(fs_home)) {
    file.path(fs_home, "FreeSurferEnv.sh")
  } else {
    NULL
  }

  ret <- get_fs_setting(
    "FREESURFER_SH",
    "freesurfer.sh",
    default_source
  )

  if (simplify) {
    return(ret$value)
  }
  ret
}

#' @describeIn get_fs_setting Retrieve FreeSurfer verbosity setting
#' @export
get_fs_verbosity <- function(simplify = TRUE) {
  ret <- get_fs_setting(
    "FREESURFER_VERBOSE",
    "freesurfer.verbose",
    "TRUE", # Default to verbose
    is_path = FALSE
  )

  if (!ret$value %in% c("TRUE", "FALSE")) {
    fs_warn(
      "Unrecognized verbosity setting, defaulting to FALSE",
      details = paste(
        "Got:",
        shQuote(ret$value),
        "Using: 'TRUE'"
      )
    )
    ret$value <- TRUE
    ret$source <- "Default"
  }

  ret$value <- as.logical(ret$value)

  if (simplify) {
    return(ret$value)
  }
  ret
}

#' @describeIn get_fs_setting Retrieve FreeSurfer output format
#' @export
get_fs_output <- function(simplify = TRUE) {
  ret <- get_fs_setting(
    "FSF_OUTPUT_FORMAT",
    "freesurfer.output_type",
    "nii.gz", # Default format
    is_path = FALSE
  )

  # Validate output format, use default if invalid
  valid_formats <- c("nii", "nii.gz", "mgz", "mgh", "hdr")
  if (!is.na(ret$value) && !ret$value %in% valid_formats) {
    fs_warn(
      "Invalid FreeSurfer output format, using default",
      details = paste("Got:", ret$value, "Using: nii.gz")
    )
    ret$value <- "nii.gz"
    ret$source <- "Default"
  }

  if (simplify) {
    return(ret$value)
  }
  ret
}

#' @describeIn get_fs_setting Retrieve MNI tools directory
#' @export
get_mni_bin <- function(
  fs_home = get_fs_home(),
  simplify = TRUE
) {
  default_mni_dir <- if (!is.na(fs_home)) {
    file.path(fs_home, "mni")
  } else {
    NULL
  }

  ret <- get_fs_setting(
    "MNI_DIR",
    "freesurfer.mni_dir",
    default_mni_dir
  )

  if (!ret$exists) {
    result <- list(
      value = NA,
      source = "No MNI directory found",
      exists = FALSE
    )
    if (simplify) {
      return(result$value)
    }
    return(result)
  }

  # Look for MNI.pm file to find bin directory
  mni_files <- list.files(
    pattern = "MNI[.]pm",
    path = ret$value,
    full.names = TRUE,
    recursive = TRUE
  )

  if (length(mni_files) > 0) {
    result <- return_setting(
      dirname(mni_files),
      ret$source,
      TRUE
    )
  } else {
    result <- list(
      value = NA,
      source = "MNI.pm file not found",
      exists = FALSE
    )
  }

  if (simplify) {
    return(result$value[1])
  }
  result
}

#' Simple helper to create setting objects
#' @noRd
return_setting <- function(value, source, is_path = TRUE) {
  exists <- FALSE

  if (!is_path) {
    exists <- NA
  }

  if (is_path && !all(is.na(value))) {
    if (length(value) == 1) {
      exists <- file.exists(value)
    } else {
      exists <- batch_file_exists(
        value,
        error = FALSE,
        warn = FALSE
      )
    }
  }

  list(
    value = value,
    source = source,
    exists = exists
  )
}

#' Helper to return single value from multi-value setting
#' @noRd
return_single <- function(setting) {
  if (length(setting$value) <= 1) {
    return(setting)
  }

  # Use first existing value, or first value if none exist
  idx <- which(setting$exists)[1]

  setting$value <- setting$value[idx]
  setting$exists <- isTRUE(setting$exists[idx])
  setting
}
