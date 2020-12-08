#' @title Use Freesurfers MRI Converter 
#' @description This function calls \code{mri_convert} to convert an image
#' @param file (character) input filename
#' @param outfile (character) output filename
#' @param opts (character) additional options to \code{mri_convert}
#' @return Result of \code{system} command
#' @export
#' @examples 
#' if (have_fs() && requireNamespace("oro.nifti", quietly = TRUE)) {
#'    img = oro.nifti::nifti(array(rnorm(5*5*5), dim = c(5,5,5))) 
#'    res = mri_convert(img, outfile = tempfile(fileext = ".mgz"))
#' } 
mri_convert = function(
  file, 
  outfile,
  opts = ""){
  res = fs_cmd(
    func = "mri_convert",
    file = file,
    outfile = outfile,
    frontopts = opts,
    retimg = FALSE,
    samefile = FALSE,
    add_ext = FALSE)
  return(res)
}


#' @title MRI Normalize Help
#' @description This calls Freesurfer's \code{mri_convert} help 
#'
#' @return Result of \code{fs_help}
#' @export
mri_convert.help = function(){
  fs_help(func_name = "mri_convert")
}