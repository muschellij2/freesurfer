#' @rdname recon_manual
#' @aliases recon_con1,recon_con2,recon_con3
#' @title Reconstruction from Motion Correction to Skull Strip 
#' @description Reconstruction from Freesurfer for Step 1-5 
#' (Motion Correction to Skull Strip), which calls \code{-autorecon1}
#' in \code{recon-all}
#'
#' @note See https://surfer.nmr.mgh.harvard.edu/fswiki/recon-all for the 
#' steps of each \code{autorecon1-3}. 
#' If you set \code{infile = NULL}, then you can omit the 
#' \code{-i} flag in \code{recon-all}.
#' @param infile Input filename (dcm or nii)
#' @param outdir Output directory
#' @param subjid subject id
#' @param verbose print diagnostic messages
#'
#' @return Result of \code{\link{system}}
#' @export
recon_con1 <- function(
  infile,
  outdir = NULL,
  subjid,
  verbose = TRUE
  ) {
  
  reconner(infile = infile,
           outdir = outdir,
           subjid = subjid,
           verbose = verbose,
           opts = "-autorecon1")
}

#' @rdname recon_manual
#' @export
autorecon1 <- function(
  infile,
  outdir = NULL,
  subjid,
  verbose = TRUE
) {
  recon_con1(
    infile = infile,
    outdir = outdir,
    subjid = subjid,
    verbose = verbose)
}
  
#' @rdname recon_manual
#' @export
recon_con2 <- function(
  infile,
  outdir = NULL,
  subjid,
  verbose = TRUE
) {
  
  reconner(infile = infile,
           outdir = outdir,
           subjid = subjid,
           verbose = verbose,
           opts = "-autorecon2")
}

#' @rdname recon_manual
#' @export
autorecon2 <- function(
  infile,
  outdir = NULL,
  subjid,
  verbose = TRUE
) {
  recon_con2(
    infile = infile,
    outdir = outdir,
    subjid = subjid,
    verbose = verbose)
}

#' @rdname recon_manual
#' @export
recon_con3 <- function(
  infile,
  outdir = NULL,
  subjid,
  verbose = TRUE
) {
  
  reconner(infile = infile,
           outdir = outdir,
           subjid = subjid,
           verbose = verbose,
           opts = "-autorecon3")
}

#' @rdname recon_manual
#' @export
autorecon3 <- function(
  infile,
  outdir = NULL,
  subjid,
  verbose = TRUE
) {
  recon_con3(
    infile = infile,
    outdir = outdir,
    subjid = subjid,
    verbose = verbose)
}
