#' @title Convert NIfTI to MNC 
#' @description This function calls \code{nii2mnc} 
#' to convert NIfTI to MNC files 
#' @param file (character) input filename
#' @param outfile (character) output filename
#' @return Character filename of output
#' @importFrom tools file_ext 
#' @importFrom R.utils gzip gunzip
#' @export
nii2mnc = function(
  file, 
  outfile = NULL){
  file = checkimg(file, gzipped = FALSE)
  ext = file_ext(tolower(file))
  if (ext %in% "gz") {
    file = R.utils::gunzip(filename = file, 
                           remove = FALSE,
                           temporary = TRUE)
  }
  if (is.null(outfile)) {
    outfile = tempfile(fileext = ".mnc")
  }
  out_ext = file_ext(tolower(outfile))
  if (out_ext != "mnc") {
    stop("File format of output not MNC")
  }
  fs_cmd(
    func = "nii2mnc",
    file = file,
    outfile = outfile,
    retimg = FALSE,
    samefile = FALSE,
    add_ext = FALSE)
  return(outfile)
}


#' @title onvert NIfTI to MNC Help
#' @description This calls Freesurfer's \code{mnc2nii} help 
#'
#' @return Result of \code{fs_help}
#' @export
nii2mnc.help = function(){
  fs_help(func_name = "nii2mnc", help.arg = "")
}