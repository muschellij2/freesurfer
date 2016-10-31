#' @title Read MGH or MGZ File
#' @description This function calls \code{mri_convert} 
#' to convert MGH/MGZ files to NIfTI, then reads it in using 
#' \code{\link{readnii}}
#' @param file (character) input filename
#' @return Object of class \code{nifti}
#' @export
readmgz = function(file){
  outfile = tempfile(fileext = ".nii.gz")
  mri_convert(file, 
              outfile)
  ret = readnii(outfile)

  return(ret)
}

#' @rdname readmgz
#' @export
readmgh = function(file){
  ret = readmgz(file)
  return(ret)
}