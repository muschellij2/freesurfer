#' @title Read MNC File
#' @description This function calls \code{mnc2nii} 
#' to convert MNC files to NIfTI, then reads it in using 
#' \code{\link{readnii}}
#' @param file (character) input filename
#' @return Object of class \code{nifti}
#' @export
readmnc = function(file){
  outfile = tempfile(fileext = ".nii.gz")
  mnc2nii(file, outfile = outfile)
  ret = readnii(outfile)

  return(ret)
}