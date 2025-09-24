#' @title Use Freesurfers MRI Watershed Algorithm
#' @description This function calls \code{mri_watershed} to extract a brain
#' from an image, usually for skull stripping.
#' @param file (character) input filename
#' @param outfile (character) output filename
#' @param retimg (logical) return image of class nifti
#' @template opts
#' @param ... additional arguments passed to \code{\link{fs_cmd}}.
#' @return Character or nifti depending on \code{retimg}
#' @export
#' @examples
#' \dontrun{
#' mri_watershed("/path/to/T1.nii.gz")
#' }
mri_watershed = function(file, outfile = NULL, retimg = TRUE, opts = "", ...) {
  res = fs_cmd(
    func = "mri_watershed",
    file = file,
    outfile = outfile,
    frontopts = opts,
    retimg = retimg,

    ...
  )
  return(res)
}


#' @title MRI Watershed Help
#' @description This calls Freesurfer's \code{mri_watershed} help
#'
#' @return Result of \code{fs_help}
#' @export
mri_watershed.help = function() {
  fs_help("mri_watershed")
}
