#' @title Reconstruction Helper for recon from Freesurfer
#' @description Wrapper for the \code{recon-all} function in Freesurfer
#' 
#' @note If you set \code{infile = NULL}, then you can omit the 
#' \code{-i} flag in \code{recon-all}
#' @param infile Input filename (dcm or nii)
#' @param outdir Output directory
#' @param subjid subject id
#' @param verbose print diagnostic messages
#' @param opts Additional options
#' @param force Force running of the reconstruction
#'
#' @return Result of \code{\link{system}}
#' @importFrom tools file_path_sans_ext
#' @export
reconner <- function(
  infile = NULL,
  outdir = NULL,
  subjid = NULL,
  verbose = TRUE,
  opts = "-all",
  force = FALSE
) {
  
  #####################################
  # Checking
  #####################################  
  if (is.null(subjid) && is.null(infile)) {
    stop("Either subjid or infile must be specified!")
  }
  if (!is.null(infile)) {
    infile = checknii(infile)
  }
  #####################################
  # Making subjid from filename
  #####################################  
  if (is.null(subjid)) {
    subjid = gsub("[.]mg(z|h)$", "", infile)
    subjid = nii.stub(subjid, bn = TRUE)
    subjid = file_path_sans_ext(subjid)
    if (verbose) {
      message(paste0("Subject set to: ", subjid))  
    }
  }
  
  #####################################
  # Checking outdir - otherwise using fs_subj_dir
  #####################################   
  if (!is.null(outdir)) {
    sd_opts = paste0(" -sd ", shQuote(outdir))
    subject_directory = file.path(sd_opts, subjid)
  } else {
    sd_opts = ""
    subject_directory = file.path(fs_subj_dir(), subjid)
  }
  
  #####################################
  # Processing infile
  #####################################     
  if (!is.null(infile)) {
    in_opts = paste0("-i ", infile)
    if (dir.exists(subject_directory)) {
      warning(paste0("Subject Directory already exists - either",
                     " use force = TRUE, or delete directory"))
    }    
  } else {
    in_opts = ""
  }
  
  
  opts = paste(
    in_opts,
    sd_opts,
    paste0(" -subjid ", subjid),
    opts)
  if (force) {
    opts = paste(opts, "-force")
  }
  
  cmd = get_fs()
  cmd = paste0(cmd, "recon-all")
  cmd = paste(cmd, opts)
  if (verbose) {
    message(cmd, "\n")
  }
  res = system(cmd)
  return(res)
}