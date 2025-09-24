#' @title Read MGH or MGZ File
#' @description This function calls \code{mri_convert}
#' to convert MGH/MGZ files to NIfTI, then reads it in using
#' \code{\link[neurobase]{readnii}}
#' @param file (character) input filename
#' @param ... Additional arguments to pass to \code{\link{fs_cmd}}
#' @return Object of class \code{nifti}
#' @importFrom neurobase readnii
#' @export
read_mgz = function(file, ...) {
  check_path(file)
  outfile = temp_file(fileext = ".nii.gz")
  dir.create(
    dirname(outfile),
    showWarnings = FALSE,
    recursive = TRUE
  )
  mri_convert(file, outfile, ...)
  readnii(outfile)
}

#' @rdname read_mgz
#' @export
read_mgh = read_mgz
