#' @title MRI Euler Number
#' @description This function calls \code{mris_euler_number} to
#' calculate the Euler Number
#' @param file (character) input filename
#' @param outfile (character) output filename
#' @param opts (character) additional options to \code{mris_euler_number}
#' @param ... Additional arguments to pass to \code{\link{fs_cmd}}
#' @return Result of \code{system} command
#' @export
#' @examples \dontrun{
#' if (have_fs() && requireNamespace("oro.nifti", quietly = TRUE)) {
#'    img = oro.nifti::nifti(array(rnorm(5*5*5), dim = c(5,5,5)))
#'    res = mris_euler_number(img, outfile = tempfile(fileext = ".mgz"))
#' }
#' }
mris_euler_number = function(
  file,
  outfile = NULL,
  opts = "",
  ...
) {
  ###########################
  # Making output file if not specified
  ###########################
  if (is.null(outfile)) {
    outfile = tempfile(fileext = ".txt")
  }
  # args = paste0("-o ", outfile)
  args = paste0("2> ", outfile)

  args = paste(args, collapse = " ")
  opts = paste(opts, args)

  res = fs_cmd(
    func = "mris_euler_number",
    file = file,
    outfile = NULL,
    opts = opts,
    retimg = FALSE,
    samefile = TRUE,
    add_ext = FALSE,
    ...
  )

  res = readLines(outfile)
  return(res)
}


#' @title MRI Euler Number Help
#' @description This calls Freesurfer's \code{mris_euler_number} help
#'
#' @return Result of \code{fs_help}
#' @export
mris_euler_number.help = function() {
  fs_help(func_name = "mris_euler_number")
}
