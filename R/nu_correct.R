#' @title Use Freesurfers Non-Uniformity Correction
#' @description This function calls \code{nu_correct} 
#' to correct for non-uniformity
#' @param file (character) input filename
#' @param mask (character or nifti) Mask to use for correction.
#' @param opts (character) additional options to \code{mri_segment}
#' @param verbose print diagnostic messages
#' @param ... additional arguments passed to \code{\link{fs_cmd}}.
#' @return Object of class nifti depending on \code{retimg}
#' @importFrom fslr parse_img_ext
#' @export
#' @examples \dontrun{
#' if (have_fs()){
#'     nu_correct("/path/to/T1.nii.gz")
#' } 
#' } 
nu_correct = function(
  file, 
  mask = NULL,
  opts = "", 
  verbose = TRUE,
  ...){
  
  file = checkimg(file)
  ext = fslr::parse_img_ext(file)
  infile = file
  if (ext %in% c("nii", "nii.gz")) {
    infile = nii2mnc(file)
  }
  # no.outfile = FALSE
  # if (is.null(outfile)) {
  outfile = tempfile(fileext = ".nii")
  # no.outfile = TRUE
  # }
  
  out_ext = fslr::parse_img_ext(outfile)
  if ( !(ext %in% c("nii", "mnc"))) {
    stop("outfile extension must be nii/nii.gz or mnc")
  }
  tmpfile = tempfile(fileext = ".mnc")
  
  opts = trimws(opts)
  if (!is.null(mask)) {
    mask = ensure_mnc(mask)
    opts = paste0(opts, " -mask ", shQuote(mask))
  }
  if (!verbose) {
    opts = paste0(opts, " -quiet")
  }
  fs_cmd(
    func = "nu_correct",
    file = infile,
    outfile = tmpfile,
    frontopts = opts,
    retimg = FALSE,
    samefile = FALSE,
    add_ext = FALSE,
    verbose = verbose,
    ...)
  if (out_ext == "nii") {
    outfile = mnc2nii(tmpfile, outfile = outfile)
    outfile = readnii(outfile)
  } else {
    file.copy(from = tmpfile, to = outfile, overwrite = TRUE)
  }
  return(outfile)
}


#' @title Non-Uniformity Correction Help
#' @description This calls Freesurfer's \code{nu_correct} help 
#'
#' @return Result of \code{fs_help}
#' @export
nu_correct.help = function(){
  fs_help(func_name = "nu_correct", help.arg = "-help")
}