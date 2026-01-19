#' Convert Surface Annotation Files
#'
#' @description
#' This function calls `mris_convert` with the `--annot` option to convert
#' annotation or gifti label data.
#'
#' @details
#' This is a convenience wrapper around [mris_convert()] specifically for
#' annotation files. See [mris_convert.help()] for full command options.
#'
#' @param annot Character; annotation or gifti label data file path.
#' @template opts
#' @param ... Additional arguments passed to [mris_convert()].
#'
#' @return Result of [mris_convert()].
#'
#' @export
#'
#' @seealso
#' [mris_convert()] for the underlying conversion function,
#' [mris_convert.help()] for FreeSurfer help
#'
#' @examplesIf have_fs()
#' \dontrun{
#' bert_dir <- file.path(fs_subj_dir(), "bert")
#' gii_file <- mris_convert_annot(
#'   infile = file.path(bert_dir, "surf", "lh.white"),
#'   annot = file.path(bert_dir, "label", "lh.aparc.annot"),
#'   ext = ".gii"
#' )
#' }
mris_convert_annot <- function(annot, opts = "", ...) {
  ######################################################
  # Making output file if not specified
  ######################################################
  opts <- paste(opts, collapse = " ")
  opts <- paste0("--annot ", annot, " ", opts)
  mris_convert(..., opts = opts)
}
