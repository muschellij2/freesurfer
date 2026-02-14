#' @title Use Freesurfers MRI Mask
#' @description This function calls \code{mri_mask} to mask an image
#'
#'
#' @param file (character) input filename
#' @param mask (character) mask filename
#' @param outfile (character) output filename
#' @param retimg (logical) return image of class nifti
#' @template opts
#' @param ... additional arguments passed to \code{\link{fs_cmd}}.
#' @return Character or nifti depending on \code{retimg}
#' @export
#' @examplesIf have_fs()
#' \dontrun{
#' img = oro.nifti::nifti(array(rnorm(5*5*5), dim = c(5,5,5)))
#' mask = img > 1
#' res = mri_mask(img, mask)
#' }
mri_mask <- function(
  file,
  mask,
  outfile = NULL,
  retimg = TRUE,
  opts = "",
  ...
) {
  mask <- neurobase::checkimg(mask)

  # mri_mask expects: <input> <mask> <output>
  # Use opts_after_outfile = TRUE to place outfile after mask
  fs_cmd(
    func = "mri_mask",
    file = file,
    outfile = outfile,
    frontopts = opts,
    opts = mask,
    opts_after_outfile = TRUE,
    retimg = retimg,
    ...
  )
}


#' @title MRI Normalize Help
#' @description This calls Freesurfer's \code{mri_mask} help
#'
#' @param ... Additional arguments passed to [fs_help()]
#' @export
mri_mask.help <- function(...) {
  fs_help("mri_mask", ...)
}
