#' @title Read MNC File
#' @description This function calls \code{mnc2nii} 
#' to convert MNC files to NIfTI, then reads it in using 
#' \code{\link{readnii}}
#' @param file (character) input filename
#' @return Object of class \code{nifti}
#' @export
readmnc = function(file){
  outfile = tempfile(fileext = ".nii.gz")
  
  ret = fs_cmd(
    func = "mnc2nii",
    file = file,
    outfile = outfile,
    retimg = TRUE,
    frontopts = "",
    samefile = FALSE,
    add_ext = FALSE,
    bin_app = "mni/bin")

  return(ret)
}