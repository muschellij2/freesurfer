#' Get FreeSurfer Configuration Settings
#'
#' Functions to manage FreeSurfer configuration settings, including determining directories, license files, and output formats. These settings are prioritized based on environment variables, R options, default fallback paths, and other predefined rules.
#'
#' @param env_var [character] Environment variable name to check.
#' @param opt_var [character] R option name to check.
#' @param defaults [character] A vector of default paths to check; used as fallbacks if the environment or options are not set (optional).
#' @param is_path [logical]. Does the setting point to a path. If `TRUE` the returned `exists` element will be `TRUE`/`FALSE` depending on whether the path exists or not. `
#' @param simplify [logical] If `TRUE`, returns only the value of the setting; if `FALSE`, returns a list with detailed information about the setting.
#'
#' @return If `simplify` = `TRUE`, returns a single value, else returns a list containing the following components:
#' \describe{
#'   \item{value}{[character] The resolved configuration value (e.g., directory path, file path, or setting).}
#'   \item{source}{[character] Indicates how the value was determined (in order of search; R option, environment variable, default location).}
#'   \item{exists}{[logical] Whether the value corresponds to an existing file or path.}
#' }
#'
#'
#' @seealso [Sys.getenv()], [getOption()], [file.exists()], [file.path()]
#'
#' @examples
#' # Retrieve FreeSurfer home directory
#' get_fs_home()
#'
#' # Retrieve FreeSurfer license file
#' get_fs_license()
#'
#' # Retrieve FreeSurfer subjects directory
#' get_fs_subdir()
#'
#' # Retrieve FreeSurfer output format
#' get_fs_output()
#' @export
get_fs_setting <- function(env_var, opt_var, defaults = NULL, is_path = TRUE) {
  original_opt <- getOption(opt_var)
  if (!is.null(original_opt)) {
    return(return_setting(
      original_opt,
      "getOption",
      is_path
    ))
  }

  original_env <- Sys.getenv(env_var)
  if (nzchar(original_env)) {
    return(return_setting(
      original_env,
      "Sys.getenv",
      is_path
    ))
  }

  if (!is.null(defaults)) {
    for (def_path in defaults) {
      if (file.exists(def_path)) {
        return(return_setting(
          def_path,
          "Default",
          is_path
        ))
      }
    }
  }

  return_setting(
    value = NA,
    source = NA,
    is_path
  )
}

#' @describeIn get_fs_setting Retrieve the FreeSurfer installation directory
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

#' @describeIn get_fs_setting Retrieve the FreeSurfer license file path
#' @export
get_fs_license <- function(simplify = TRUE) {
  fs_home <- get_fs_home()

  ret <- get_fs_setting(
    "FS_LICENSE",
    "freesurfer.license",
    c(
      file.path(fs_home, ".license"),
      file.path(fs_home, "license.txt")
    )
  )

  if (is.na(ret$value) && !ret$exists) {
    ret <- return_setting(NA, "No license found.")
  }

  if (simplify) {
    return(ret$value)
  }
  ret
}

#' @describeIn get_fs_setting Retrieve the FreeSurfer "subjects" directory
#' @export
get_fs_subdir <- function(simplify = TRUE) {
  ret <- get_fs_setting(
    "SUBJECTS_DIR",
    "freesurfer.subj_dir",
    file.path(fs_dir(), "subjects")
  )

  if (!is.na(ret$source)) {
    if (ret$source == "Default") {
      ret$source = "fs_dir()"
    }
  }

  if (simplify) {
    return(ret$value)
  }
  ret
}

#' @describeIn get_fs_setting Retrieve the FreeSurfer source script
#' @export
get_fs_source <- function(simplify = TRUE) {
  ret <- get_fs_setting(
    "FREESURFER_SH",
    "freesurfer.sh",
    file.path(fs_dir(), "FreeSurferEnv.sh")
  )
  if (!is.na(ret$source)) {
    if (ret$source == "Default") {
      ret$source = "fs_dir()"
    }
  }
  if (simplify) {
    return(ret$value)
  }
  ret
}

#' @describeIn get_fs_setting Retrieve the FreeSurfer source script
#' @export
get_fs_verbosity <- function(simplify = TRUE) {
  ret <- get_fs_setting(
    "FREESURFER_VERBOSE",
    "freesurfer.verbose",
    is_path = FALSE
  )
  if (is.na(ret$value)) {
    if (simplify) {
      return(TRUE)
    }
    return(
      list(
        value = TRUE,
        source = "Default",
        exists = NA
      )
    )
  }
  ret$value <- as.logical(ret$value)

  if (simplify) {
    return(ret$value)
  }
  ret
}

#' @describeIn get_fs_setting Retrieve the output format for FreeSurfer
#' @export
get_fs_output <- function(simplify = TRUE) {
  ret <- get_fs_setting(
    "FSF_OUTPUT_FORMAT",
    "freesurfer.output_type",
    is_path = FALSE
  )
  if (is.na(ret$value)) {
    ret <- return_setting(
      "nii.gz",
      "Default",
      FALSE
    )
  }
  if (simplify) {
    return(ret$value)
  }
  ret
}

#' @describeIn get_fs_setting Retrieve mni bin folder
#' @export
get_mni_bin <- function(simplify = TRUE) {
  ret <- get_fs_setting(
    "MNI_DIR",
    "freesurfer.mni_dir",
    file.path(fs_dir(), "mni")
  )

  if (!ret$exists) {
    return(
      list(
        value = NA,
        source = "No MNI directory found",
        exists = FALSE
      )
    )
  }

  mni <- list.files(
    pattern = "MNI[.]pm",
    path = ret$value,
    full.names = TRUE,
    recursive = TRUE
  )

  ret <- return_setting(
    dirname(mni),
    ret$source
  )

  if (simplify) {
    return(ret$value)
  }
  ret
}

#' @noRd
return_setting <- function(value, source, is_path = TRUE) {
  exists <- if (is_path) {
    if (all(is.na(value))) {
      rep(FALSE, length(value))
    } else {
      file.exists(value)
    }
  } else {
    NA
  }

  list(
    value = value,
    source = source,
    exists = exists
  )
}

#' @noRd
return_single <- function(setting) {
  if (length(setting$value) == 1 || all(is.na(setting$value))) {
    return(setting)
  }

  idx <- which(setting$exists)[1]
  setting$value <- setting$value[idx]
  setting$exists <- setting$exists[idx]
  setting
}
