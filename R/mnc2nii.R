#' @title Convert MNC to NIfTI
#' @description This function calls \code{mnc2nii} 
#' to convert MNC files to NIfTI
#' @param file (character) input filename
#' @param outfile (character) output filename
#' @return Character filename of output
#' @importFrom tools file_ext 
#' @importFrom R.utils gzip
#' @export
mnc2nii = function(file, 
                   outfile = NULL){
  if (is.null(outfile)) {
    outfile = tempfile(fileext = ".nii.gz")
  }
  out_ext = file_ext(tolower(outfile))
  outfile = paste0(nii.stub(outfile), ".nii")
  fs_cmd(
    func = "mnc2nii",
    file = file,
    outfile = outfile,
    retimg = FALSE,
    frontopts = "",
    samefile = FALSE)
  if (out_ext %in% "gz") {
    outfile = gzip(outfile, remove = TRUE, temporary = FALSE)
  }
  return(outfile)
}


#' @title MNC to NIfTI Help
#' @description This calls Freesurfer's \code{mnc2nii} help 
#'
#' @return Result of \code{fs_help}
#' @export
mnc2nii.help = function(){
  fs_help(func_name = "mnc2nii", help.arg = "")
}