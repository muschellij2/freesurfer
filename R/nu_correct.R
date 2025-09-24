#' @title Use Freesurfers Non-Uniformity Correction
#' @description This function calls \code{nu_correct}
#' to correct for non-uniformity
#' @param file (character) input filename
#' @param mask (character or nifti) Mask to use for correction.
#' @template opts
#' @template verbose
#' @param ... additional arguments passed to \code{\link{fs_cmd}}.
#' @return Object of class nifti depending on \code{retimg}
#' @importFrom neurobase parse_img_ext readnii
#' @export
#' @examples
#' \dontrun{
#' nu_correct("/path/to/T1.nii.gz")
#' }
nu_correct = function(
  file,
  mask = NULL,
  opts = "",
  verbose = get_fs_verbosity(),
  ...
) {
  file = checkimg(file)
  ext = neurobase::parse_img_ext(file)
  infile = file
  if (ext %in% c("nii", "nii.gz")) {
    infile = nii2mnc(file)
  }
  # no.outfile = FALSE
  # if (is.null(outfile)) {
  outfile = temp_file(fileext = ".nii")
  # no.outfile = TRUE
  # }

  out_ext = neurobase::parse_img_ext(outfile)
  if (!(ext %in% c("nii", "mnc"))) {
    cli::cli_abort("outfile extension must be nii/nii.gz or mnc")
  }
  tmpfile = temp_file(fileext = ".mnc")

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
    verbose = verbose,
    bin_app = "mni/bin",
    ...
  )
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
nu_correct.help = function() {
  fs_help("nu_correct", help.arg = "-help", bin_app = "mni/bin")
}
