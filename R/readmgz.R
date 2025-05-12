#' @title Read MGH or MGZ File
#' @description This function calls \code{mri_convert}
#' to convert MGH/MGZ files to NIfTI, then reads it in using
#' \code{\link[neurobase]{readnii}}
#' @param file (character) input filename
#' @param ... Additional arguments to pass to \code{\link{fs_cmd}}
#' @return Object of class \code{nifti}
#' @importFrom neurobase readnii
#' @export
readmgz = function(file, ...) {
  outfile = tempfile(fileext = ".nii.gz")
  mri_convert(file, outfile, ...)
  readnii(outfile)
}

#' @rdname readmgz
#' @export
readmgh = readmgz
