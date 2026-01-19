#' @title MRI information
#' @description This calls Freesurfer's \code{mri_info}
#'
#'
#' @param file File to pass to \code{mri_info}
#' @param ... Additional arguments to pass to \code{\link{fs_cmd}}
#'
#' @return Result of \code{fs_cmd}, which type depends on
#' arguments to \code{...}
#' @export
#' @examplesIf have_fs()
#' img = oro.nifti::nifti(array(rnorm(5*5*5), dim = c(5,5,5)))
#' mri_info(img)
mri_info <- function(file, ...) {
  fs_cmd(func = "mri_info", file = file, outfile = file, ...)
}

#' @title MRI information Help
#' @description This calls Freesurfer's \code{mri_info} help
#'
#' @param display Logical; whether to display help output
#' @param warn Logical; whether to warn if help is not available
#' @param ... Additional arguments passed to [fs_help()]
#' @export
mri_info.help <- function(...) {
  fs_help("mri_info", ...)
}
