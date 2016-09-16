#' @rdname trac_manual
#' @title Tract Reconstruction for Each Step
#' @description Reconstruction from Freesurfer for Preprocessing,
#' Bedpost, and Path reconstruction
#' 

#' @param infile Input filename (dcm or nii)
#' @param outdir Output directory
#' @param subjid subject id
#' @param verbose print diagnostic messages
#'
#' @return Result of \code{\link{system}}
#' @export
trac_prep <- function(
  infile,
  outdir = NULL,
  subjid,
  verbose = TRUE
) {
  
  reconner(infile = infile,
           outdir = outdir,
           subjid = subjid,
           verbose = verbose,
           opts = "-prep")
}

#' @rdname trac_manual
#' @export
trac_bedpost <- function(
  infile,
  outdir = NULL,
  subjid,
  verbose = TRUE
) {
  
  reconner(infile = infile,
           outdir = outdir,
           subjid = subjid,
           verbose = verbose,
           opts = "-bedp")
}


#' @rdname trac_manual
#' @export
trac_path <- function(
  infile,
  outdir = NULL,
  subjid,
  verbose = TRUE
) {
  
  reconner(infile = infile,
           outdir = outdir,
           subjid = subjid,
           verbose = verbose,
           opts = "-path")
}