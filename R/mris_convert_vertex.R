#' @title Convert Surface to vertex file
#' @description This function call \code{mris_convert},
#' using the \code{-v} option
#' @template opts
#' @param ... additional arguments to \code{\link{mris_convert}}
#'
#' @return Result of \code{\link{mris_convert}}
#' @export
#' @examplesIf have_fs()
#'  bert_surf_dir = file.path(fs_subj_dir(), "bert", "surf")
#'  asc_file = mris_convert_vertex(
#'  infile = file.path(bert_surf_dir, "lh.white")
#'  )
#'  readLines(asc_file, n = 6)
mris_convert_vertex = function(
  opts = "",
  ...
) {
  ######################################################
  # Making output file if not specified
  ######################################################
  opts = paste(opts, collapse = " ")
  opts = paste0(opts, " ", "-v ")
  outfile = mris_convert(..., opts = opts)
  return(outfile)
}
