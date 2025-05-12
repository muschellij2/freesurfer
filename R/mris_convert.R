#' @title Use Freesurfers MRIs Converter
#' @description This function call  \code{mris_convert}, a
#' general conversion program for converting between cortical surface file formats
#' @param infile (character) file path for input file
#' @param outfile (character) output file path
#' @param ext (character) output file extension, default is set to .asc
#' @param opts (character) additional options to add to front of command
#' @param verbose (logical) print diagnostic messages
#' @param ... Additional arguments to pass to \code{\link{system}}
#' @return Name of output file
#' @export
#' @examples
#' if (have_fs()) {
#'  bert_surf_dir = file.path(fs_subj_dir(), "bert", "surf")
#'  asc_file = mris_convert(
#'  infile = file.path(bert_surf_dir, "lh.white")
#'  )
#' }
mris_convert = function(
  infile,
  outfile = NULL,
  ext = ".asc",
  opts = "",
  verbose = TRUE,
  ...
) {
  ######################################################
  # Making output file if not specified
  ######################################################
  if (is.null(outfile)) {
    outfile = tempfile(fileext = ext)
  }

  opts = paste(opts, collapse = " ")
  cmd <- paste("mris_convert ", opts, infile, outfile, sep = " ")
  cmd <- paste0(get_fs(), cmd)

  run_check_fs_cmd(cmd = cmd, outfile = outfile, verbose = verbose, ...)
  attr(outfile, "separator") = " "
  return(outfile)
}


#' @title Help file for Freesurfers MRIs Converter
#' @description This calls Freesurfer's \code{mris_convert} help
#'
#' @return Result of \code{fs_help}
#' @export
mris_convert.help = function() {
  fs_help(func_name = "mris_convert")
}
