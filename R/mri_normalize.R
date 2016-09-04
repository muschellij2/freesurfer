#' @title Use Freesurfers MRI Normalize Algorithm
#' @description This function calls \code{mri_normalize} to extract a brain 
#' from an image, usually for skull stripping.
#' @param file (character) input filename
#' @param outfile (character) output filename
#' @param retimg (logical) return image of class nifti
#' @param opts (character) additional options to \code{mri_normalize}
#' @param ... additional arguments passed to \code{\link{fs_cmd}}.
#' @return Character or nifti depending on \code{retimg}
#' @export
mri_normalize = function(file, 
                         outfile = NULL,                  
                         retimg = TRUE,
                         opts = "", 
                         ...){
  res = fs_cmd(
    func = "mri_normalize",
    file = file,
    outfile = outfile,
    frontopts = opts,
    retimg = retimg,
    samefile = FALSE,
    ...)
  return(res)
}


#' @title MRI Normalize Help
#' @description This calls Freesurfer's \code{mri_normalize} help 
#'
#' @return Result of \code{fs_help}
#' @export
mri_normalize.help = function(){
  fs_help(func_name = "mri_normalize")
}