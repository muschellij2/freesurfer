#' @title Read MNC File
#' @description This function calls \code{\link{mnc2nii}}
#' to convert MNC files to NIfTI, then reads it in using
#' \code{\link[neurobase]{readnii}}
#' @param file (character) input filename
#' @return Object of class \code{nifti}
#' @importFrom neurobase readnii
#' @export
read_mnc = function(file) {
  check_path(file)
  outfile = temp_file(fileext = ".nii.gz")
  mnc2nii(file, outfile = outfile)
  readnii(outfile)
}
