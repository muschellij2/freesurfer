#' @title Reconstruction from Freesurfer for All Steps
#' @description Reconstruction from Freesurfer for All Steps
#' 
#' @param infile Input filename (dcm or nii)
#' @param outdir Output directory
#' @param subjid subject id
#' @param verbose print diagnostic messages
#' @param opts Additional options
#'
#' @return Result of \code{\link{system}}
#' @export
recon_all <- function(
  infile,
  outdir,
  subjid,
  verbose = TRUE,
  opts = "-all"
) {
  
  reconner(infile = infile,
           outdir = outdir,
           subjid = subjid,
           verbose = verbose,
           opts = "-all")
}