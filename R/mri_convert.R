#' @title Use Freesurfers MRI Converter
#' @description This function calls \code{mri_convert} to convert an image
#' @param file (character) input filename
#' @param outfile (character) output filename
#' @template opts
#' @param ... Additional arguments to pass to \code{\link{fs_cmd}}
#' @return Result of \code{system} command
#' @export
#' @examplesIf have_fs()
#' img = oro.nifti::nifti(array(rnorm(5*5*5), dim = c(5,5,5)))
#' res = mri_convert(img, outfile = temp_file(fileext = ".mgz"))
mri_convert = function(
  file,
  outfile,
  opts = "",
  ...
) {
  fs_cmd(
    func = "mri_convert",
    file = file,
    outfile = outfile,
    frontopts = opts,
    retimg = FALSE,
    ...
  )
}


#' @title MRI Normalize Help
#' @description This calls Freesurfer's \code{mri_convert} help
#'
#' @return Result of \code{fs_help}
#' @export
mri_convert.help = function() {
  fs_help("mri_convert")
}
