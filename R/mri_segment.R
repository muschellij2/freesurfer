#' @title Use Freesurfers MRI Segmentation Algorithm
#' @description This function calls \code{mri_segment} 
#' to segment tissues from an image
#' @param file (character) input filename
#' @param outfile (character) output filename
#' @param retimg (logical) return image of class nifti
#' @param opts (character) additional options to \code{mri_segment}
#' @param ... additional arguments passed to \code{\link{fs_cmd}}.
#' @return Character or nifti depending on \code{retimg}
#' 
#' @note NOT COMPLETE
#' @examples \dontrun{
#' if (have_fs()){
#'     mri_segment("/path/to/T1.nii.gz")
#' } 
#' } 
mri_segment = function(
  file, 
  outfile = NULL,                  
  retimg = TRUE,
  opts = "", 
  ...){
  res = fs_cmd(
    func = "mri_segment",
    file = file,
    outfile = outfile,
    frontopts = opts,
    retimg = retimg,
    samefile = FALSE,
    ...)
  return(res)
}


#' @title MRI Segment Help
#' @description This calls Freesurfer's \code{mri_segment} help 
#'
#' @return Result of \code{fs_help}
#' @export
mri_segment.help = function(){
  fs_help(func_name = "mri_segment")
}