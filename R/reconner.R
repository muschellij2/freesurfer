#' @title Reconstruction Helper for recon from Freesurfer
#' @description Wrapper for the \code{recon-all} function in Freesurfer
#' 
#' @param infile Input filename (dcm or nii)
#' @param outdir Output directory
#' @param subjid subject id
#' @param verbose print diagnostic messages
#' @param opts Additional options
#'
#' @return Result of \code{\link{system}}
#' @importFrom tools file_path_sans_ext
#' @export
reconner <- function(
  infile,
  outdir,
  subjid,
  verbose = TRUE,
  opts = "-all"
) {
  
  if (is.null(subjid)) {
    subjid = nii.stub(infile, bn = TRUE)
    subjid = file_path_sans_ext(subjid)
  }  
  infile = checknii(infile)
  
  opts = paste(
    paste0("-i ", infile),
    paste0(" -sd ", shQuote(outdir)),
    paste0(" -subjid ", subjid),
    opts)
  
  cmd = get_fs()
  cmd = paste(cmd, opts)
  if (verbose) {
    message(cmd, "\n")
  }
  res = system(cmd)
  return(res)
}