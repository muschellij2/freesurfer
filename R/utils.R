#' Create a Temporary File with a Newly Created Directory
#' @param tmpdir Directory in which to create the temporary file
#' @param ... Arguments passed to tempfile()
#' @return Full file path to temporary file with created directory
#' @export
temp_file <- function(tmpdir = tempdir(check = TRUE), ...) {
  tempfile(..., tmpdir = tmpdir) |>
    normalizePath(mustWork = FALSE)
}

#' Utility to silently create directories
#' @noRd
mkdir <- function(path) {
  dir.create(path, showWarnings = FALSE, recursive = TRUE)
}

#' Simple FreeSurfer environment validation
#' @param check_license Should license file be checked?
#' @return Invisible TRUE if valid, error if not
#' @noRd
validate_fs_env <- function(check_license = FALSE) {
  if (!have_fs()) {
    fs_abort(
      "FreeSurfer installation not found",
      details = "Set FREESURFER_HOME environment variable or freesurfer.home R option"
    )
  }

  if (check_license) {
    license_info <- get_fs_license(simplify = FALSE)
    if (is.na(license_info$value) || !license_info$exists) {
      fs_warn(
        "FreeSurfer license file not found",
        details = "Some functions may not work without a valid license"
      )
    }
  }

  invisible(TRUE)
}

#' Gather basic system information
#' @return List with platform, R version, and shell
#' @keywords internal
#' @noRd
sys_info <- function() {
  list(
    platform = R.version$platform,
    r_version = sub("R version ", "", R.version.string),
    shell = Sys.getenv("SHELL")
  )
}

# nocov start
knit_vignettes <- function() {
  vf <- list.files("vignettes", ".orig$", full.names = TRUE)

  mapply(
    knitr::knit,
    input = vf,
    output = gsub("\\.orig", "", vf)
  )

  cp <- file.copy(
    "figure",
    "vignette/figure",
    overwrite = TRUE,
    recursive = TRUE
  )
}
# nocov end
