#' @title Find Freesurfer Version
#' @description Finds the Freesurfer version from \code{FREESURFER_HOME/build-stamp.txt}
#' 
#' @note This will use \code{fs_dir()} to get the directory of FREESURFER
#' @return If the version file does not exist, it will throw a warning, but 
#' it will return an empty string.  Otherwise it will be a string of the version.
#' @export
#' @examples 
#' if (have_fs()) {
#'  fs_version()
#' }
fs_version = function(){
  
  fsdir = fs_dir()
  version_file = file.path(fsdir, "build-stamp.txt")
  if (!file.exists(version_file)) {
    warning("No version file exists, fun fs to see version")
    version = ""
  } else {
    version = readLines(version_file)
  }
  return(version)
}

