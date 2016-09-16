#' @title Tract Reconstruction Helper for trac-all from Freesurfer for All Steps
#' @description Wrapper for the \code{trac-all} function in Freesurfer 
#' for All Steps
#' 
#' @param infile Input filename (dcm or nii)
#' @param outdir Output directory
#' @param subjid subject id
#' @param verbose print diagnostic messages
#' @param opts Additional options
#'
#' @return Result of \code{\link{system}}
#' @export
trac_all <- function(
  infile,
  outdir = NULL,
  subjid,
  verbose = TRUE,
  opts = ""
) {
  
  tracker(infile = infile,
           outdir = outdir,
           subjid = subjid,
           verbose = verbose,
           opts = opts)
}