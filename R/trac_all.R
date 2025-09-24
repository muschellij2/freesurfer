#' @title Tract Reconstruction Helper for trac-all from Freesurfer for All Steps
#' @description Wrapper for the \code{trac-all} function in Freesurfer
#' for All Steps
#'
#' @param infile Input filename (dcm or nii)
#' @template outdir
#' @template subjid
#' @template verbose
#' @template opts
#'
#' @return Result of \code{\link{system}}
#' @export
trac_all <- function(
  infile,
  outdir = NULL,
  subjid,
  verbose = get_fs_verbosity(),
  opts = ""
) {
  tracker(
    infile = infile,
    outdir = outdir,
    subjid = subjid,
    verbose = verbose,
    opts = opts
  )
}
