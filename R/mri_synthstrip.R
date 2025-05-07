#' @title Use Freesurfers MRI SynthStrip 
#' @description This function calls \code{mri_mask} to mask an image
#' @param file (character) input filename
#' @param outfile (character) output filename
#' @param maskfile (character) path for mask output
#' @param retimg (logical) return image of class nifti
#' @param opts (character) additional options to \code{mri_mask}
#' @param ... additional arguments passed to \code{\link{fs_cmd}}.
#' @return Character or nifti depending on \code{retimg}
#' @export
#' @examples 
#' if (have_fs() && requireNamespace("oro.nifti", quietly = TRUE)) {
#'    img = oro.nifti::nifti(array(rnorm(5*5*5), dim = c(5,5,5)))  
#'    res = mri_synthstrip(img)
#' }
mri_synthstrip = function(
    file, 
    outfile = NULL, 
    retimg = TRUE,
    maskfile = NULL,
    opts = "", 
    ...){

  if (is.null(maskfile)) {
    maskfile = tempfile(fileext = "_mask.nii.gz")
  } 
  maskfile = normalizePath(path.expand(maskfile), mustWork = FALSE)
  maskfile_attr = maskfile
  maskfile = shQuote(maskfile)
  res = fs_cmd(
    func = "mri_synthstrip",
    file = file,
    outfile = outfile,
    frontopts = "-i",
    opts = paste(c(opts, c("-m", maskfile), "-o"), collapse = " "),
    retimg = retimg,
    samefile = FALSE,
    ...)
  attr(res, "maskfile") = maskfile_attr
  return(res)
}

#' @export
#' @rdname mri_synthstrip
synthstrip = mri_synthstrip

#' @title MRI Normalize Help
#' @description This calls Freesurfer's \code{mri_mask} help 
#'
#' @return Result of \code{fs_help}
#' @export
mri_synthstrip.help = function(){
  fs_help(func_name = "mri_mask")
}

