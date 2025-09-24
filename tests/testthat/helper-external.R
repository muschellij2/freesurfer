#' Skip test if FreeSurfer is not installed
#'
#' @keywords internal
skip_if_no_freesurfer <- function() {
  if (!have_fs()) {
    testthat::skip(
      "FreeSurfer not found. Skipping FreeSurfer-dependent test(s)."
    )
  }
}

#' Mock Nifti object for readnii
#' @keywords internal
mock_nifti_image <- function(dims = c(2, 2, 2)) {
  img <- array(1:(prod(dims)), dim = dims)
  attr(img, "dim_") <- c(4, dims, rep(0, 3))
  class(img) <- "nifti"
  return(img)
}

#' Temporarily unset FreeSurfer environment variables and options
#' @keywords internal
local_fs_unset <- function(env = parent.frame()) {
  withr::local_options(
    freesurfer.home = NULL,
    freesurfer.subj_dir = NULL,
    freesurfer.output_type = NULL,
    freesurfer.sh = NULL,
    freesurfer.mni_dir = NULL,
    freesurfer.license = NULL,
    freesurfer.verbose = NULL,
    .local_envir = env
  )

  withr::local_envvar(
    FSF_OUTPUT_FORMAT = "",
    FREESURFER_HOME = "",
    SUBJECTS_DIR = "",
    FREESURFER_SH = "",
    FS_LICENSE = "",
    MNI_DIR = "",
    FREESURFER_VERBOSE = "",
    .local_envir = env
  )
}
