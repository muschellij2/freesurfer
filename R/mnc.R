#' @title Convert MNC to NIfTI
#' @description This function calls \code{mnc2nii}
#' to convert MNC files to NIfTI
#' @param file (character) input filename
#' @param outfile (character) output filename
#' @param ... Additional arguments to pass to \code{\link{fs_cmd}}
#' @return Character filename of output
#' @importFrom tools file_ext
#' @importFrom R.utils gzip
#' @export
#' @examplesIf have_fs()
#' img = oro.nifti::nifti(array(rnorm(5*5*5), dim = c(5,5,5)))
#' mnc = nii2mnc(img)
#' img_file = mnc2nii(mnc, outfile = temp_file(fileext = ".nii"))
#' neurobase::readnii(img_file, verbose = get_fs_verbosity())
mnc2nii <- function(file, outfile = NULL, ...) {
  if (is.null(outfile)) {
    outfile <- temp_file(fileext = ".nii.gz")
  }
  out_ext <- file_ext(tolower(outfile))
  outfile <- paste0(nii.stub(outfile), ".nii")

  # copy for bs stuff
  stopifnot(all(file.exists(file)))
  tfile <- temp_file()
  mkdir(tfile)
  infile <- file.path(tfile, basename(file))
  file.copy(from = file, to = infile, overwrite = TRUE)

  fs_cmd(
    func = "mnc2nii",
    file = file,
    outfile = outfile,
    retimg = FALSE,
    frontopts = "-float",
    bin_app = "mni/bin",
    ...
  )
  if (!file.exists(outfile)) {
    real_outfile <- outfile
    outfile <- paste0(outfile, ".nii")
    if (!file.exists(outfile)) {
      cli::cli_abort("mnc2nii did not produce outfile specified")
    }
    file.copy(outfile, real_outfile, overwrite = TRUE)
    outfile <- real_outfile
  }
  if (out_ext %in% "gz") {
    outfile <- gzip(outfile, remove = TRUE, temporary = FALSE, overwrite = TRUE)
  }
  outfile
}


#' @title MNC to NIfTI Help
#' @description This calls Freesurfer's \code{mnc2nii} help
#'
#' @return Result of \code{fs_help}
#' @export
#' @describeIn mnc_convert Display information about mnc2nii command
#' @param display Logical; whether to display help output
#' @param warn Logical; whether to warn if help is not available
#' @param ... Additional arguments passed to [fs_help()]
mnc2nii.help <- function(display = TRUE, ...) {
  if (display) {
    cli::cli_inform(c(
      "i" = "{.fn mnc2nii}: Convert MINC to NIfTI format",
      " " = "",
      "!" = "This command does not provide standard help output.",
      " " = "",
      "Usage:" = "{.code mnc2nii [-float] input.mnc output.nii}",
      " " = "",
      "Options:" = "",
      "*" = "{.code -float}: Output as floating point (automatically used)",
      " " = "",
      "i" = "Part of the MNI tools included with FreeSurfer.",
      "i" = "Converts MINC format (.mnc) to NIfTI format (.nii, .nii.gz)."
    ))
  }
  invisible(NULL)
}


#' @title Convert NIfTI to MNC
#' @description This function calls \code{nii2mnc}
#' to convert NIfTI to MNC files
#' @param file (character) input filename
#' @param outfile (character) output filename
#' @param ... Additional arguments to pass to \code{\link{fs_cmd}}
#' @return Character filename of output
#' @importFrom tools file_ext
#' @importFrom R.utils gzip gunzip
#' @importFrom neurobase checknii
#' @export
#' @examplesIf have_fs()
#' img = oro.nifti::nifti(array(rnorm(5*5*5), dim = c(5,5,5)))
#' mnc = nii2mnc(img)
#' img_file = mnc2nii(mnc)
nii2mnc <- function(
  file,
  outfile = tempfile(fileext = ".mnc"),
  ...
) {
  file <- neurobase::checknii(file)

  if (is.null(outfile)) {
    outfile <- temp_file(fileext = ".mnc")
  }
  out_ext <- file_ext(tolower(outfile))
  if (out_ext != "mnc") {
    cli::cli_abort("File format of output not MNC")
  }
  fs_cmd(
    func = "nii2mnc",
    file = file,
    outfile = outfile,
    retimg = FALSE,
    bin_app = "mni/bin",
    ...
  )
  if (!file.exists(outfile)) {
    cli::cli_abort("nii2mnc did not produce outfile specified")
  }
  outfile
}

#' @export
#' @describeIn mnc_convert Display information about nii2mnc command
nii2mnc.help <- function(display = TRUE, ...) {
  if (display) {
    cli::cli_inform(c(
      "i" = "{.fn nii2mnc}: Convert NIfTI to MINC format",
      " " = "",
      "!" = "This command does not provide standard help output.",
      " " = "",
      "Usage:" = "{.code nii2mnc input.nii output.mnc}",
      " " = "",
      "i" = "Part of the MNI tools included with FreeSurfer.",
      "i" = "Converts NIfTI format (.nii, .nii.gz) to MINC format (.mnc)."
    ))
  }
  invisible(NULL)
}
