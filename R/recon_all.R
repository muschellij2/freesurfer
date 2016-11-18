#' @title Reconstruction from Freesurfer for All Steps
#' @description Reconstruction from Freesurfer for All Steps
#' 
#' @param infile Input filename (dcm or nii)
#' @param outdir Output directory
#' @param subjid subject id
#' @param verbose print diagnostic messages
#' @param opts Additional options
#' @param ... arguments passed to \code{\link{reconner}}
#'
#' @note If you would like to restart a \code{recon-all} run,
#' change opts so that \code{opts = "-make all"}
#' @return Result of \code{\link{system}}
#' @export
recon_all <- function(
  infile = NULL,
  outdir = NULL,
  subjid = NULL,
  verbose = TRUE,
  opts = "-all",
  ...
) {
  
  reconner(infile = infile,
           outdir = outdir,
           subjid = subjid,
           verbose = verbose,
           opts = opts,
           ...)
}
