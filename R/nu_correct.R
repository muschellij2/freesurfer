#' Use FreeSurfer's Non-Uniformity Correction
#'
#' @description
#' This function calls `nu_correct` to correct for intensity non-uniformity
#' in MRI images using N3 (nonparametric nonuniform normalization).
#'
#' @details
#' The `nu_correct` command performs N3 (nonparametric nonuniform intensity
#' normalization) to correct for intensity inhomogeneity in MRI images.
#' This is particularly useful for T1-weighted images where intensity
#' varies across the image due to magnetic field inhomogeneities.
#'
#' Common options:
#' * `-mask <file>`: Use a binary mask
#' * `-distance <value>`: N3 spline distance (default 200mm)
#' * `-iterations <value>`: Maximum iterations (default 4)
#' * `-stop <value>`: Stopping criterion (default 0.01)
#'
#' Note: This is an MNI tool and uses different help syntax (`-help` instead of `--help`).
#'
#' @param file Character; input filename.
#' @param mask Character or nifti; mask to use for correction.
#' @template opts
#' @template verbose
#' @param ... Additional arguments passed to [fs_cmd()].
#'
#' @return Object of class nifti.
#'
#' @export
#'
#' @seealso
#' [mri_normalize()] for FreeSurfer's normalization,
#' [nu_correct.help()] for command information
#'
#' @examplesIf have_fs()
#' \dontrun{
#' # Basic usage
#' nu_correct("/path/to/T1.nii.gz")
#'
#' # With mask
#' nu_correct("/path/to/T1.nii.gz", mask = "/path/to/mask.nii.gz")
#' }
nu_correct <- function(
  file,
  mask = NULL,
  opts = "",
  verbose = get_fs_verbosity(),
  ...
) {
  file <- neurobase::checkimg(file)
  ext <- neurobase::parse_img_ext(file)
  infile <- file
  if (ext %in% c("nii", "nii.gz")) {
    infile <- nii2mnc(file)
  }
  # no.outfile = FALSE
  # if (is.null(outfile)) {
  outfile <- temp_file(fileext = ".nii")
  # no.outfile = TRUE
  # }

  out_ext <- neurobase::parse_img_ext(outfile)
  if (!(ext %in% c("nii", "mnc"))) {
    cli::cli_abort("outfile extension must be nii/nii.gz or mnc")
  }
  tmpfile <- temp_file(fileext = ".mnc")

  opts <- trimws(opts)
  if (!is.null(mask)) {
    mask <- ensure_mnc(mask)
    opts <- paste0(opts, " -mask ", shQuote(mask))
  }
  if (!verbose) {
    opts <- paste0(opts, " -quiet")
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
    outfile <- mnc2nii(tmpfile, outfile = outfile)
    outfile <- readnii(outfile)
  } else {
    file.copy(from = tmpfile, to = outfile, overwrite = TRUE)
  }
  outfile
}

#' @describeIn nu_correct Display information about nu_correct
#' @param ... Additional arguments passed to [fs_help()]
#' @export
nu_correct.help <- function(...) {
  # nu_correct uses -help instead of --help
  fs_help(
    "nu_correct",
    help_arg = "-help",
    bin_app = "mni/bin",
    ...
  )
}
