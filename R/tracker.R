#' @title Tract Reconstruction Helper for trac-all from Freesurfer
#' @description Wrapper for the \code{trac-all} function in Freesurfer
#'
#' @param infile Input filename (dcm or nii)
#' @template outdir
#' @template subjid
#' @template verbose
#' @template opts
#'
#' @return Result of \code{\link{system}}
#' @export
tracker <- function(
  infile,
  outdir = NULL,
  subjid,
  verbose = get_fs_verbosity(),
  opts = ""
) {
  if (is.null(subjid)) {
    subjid = nii.stub(infile, bn = TRUE)
    subjid = file_path_sans_ext(subjid)
  }
  if (!is.null(infile)) {
    infile = checknii(infile)
    in_opts = paste0("-i ", infile)
  } else {
    in_opts = ""
  }

  if (!is.null(outdir)) {
    sd_opts = paste0(" -sd ", shQuote(outdir))
  } else {
    sd_opts = ""
  }

  opts = paste(
    in_opts,
    sd_opts,
    paste0(" -s ", subjid),
    opts
  )

  cmd = get_fs()
  cmd = paste0(cmd, "trac-all")
  cmd = paste(cmd, opts)
  if (verbose) {
    cli::cli_code(cmd)
  }
  try_cmd(cmd)
}
