#' @title Find Freesurfer Version
#' @description Finds the Freesurfer version from \code{FREESURFER_HOME/build-stamp.txt}
#'
#' @note This will use \code{fs_dir()} to get the directory of FREESURFER
#' @return If the version file does not exist, it will throw a warning, but
#' it will return an empty string.  Otherwise it will be a string of the version.
#' @export
#' @examplesIf have_fs()
#'  fs_version()
fs_version <- function() {
  version_file <- file.path(
    fs_dir(),
    "build-stamp.txt"
  )
  if (!file.exists(version_file)) {
    fs_warn(
      "No version file exists at {.path {version_file}}."
    )
    return("")
  }
  readLines(version_file)
}
