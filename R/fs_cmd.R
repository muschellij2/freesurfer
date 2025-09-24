#' FS Command Wrapper
#'
#' This function serves as a wrapper for Freesurfer commands,
#' enabling flexible execution of image manipulation tasks.
#' It allows users to define input and output files, manage
#' command-line arguments, and optionally process images in memory.
#'
#' @param func (character) Freesurfer command to be executed.
#' @param file (character) Path to the input image file.
#' @param outfile (character, optional) Path to the output image file. If `NULL` (default), the command assumes no separate output file.
#'                Set `outfile = file` to overwrite the input file.
#' @param retimg (logical, default = `TRUE`) Whether to return the output as an image of class `nifti`.
#' @param reorient (logical, default = `FALSE`) If `retimg = TRUE`, determines whether the image is reoriented when loaded. Passed to [neurobase::readnii()].
#' @param intern (logical, default = `FALSE`) Specifies whether to capture the command's output. Passed to [base::system()].
#' @param opts (character, default = `""`) Additional options to be passed to the Freesurfer command.
#' @param verbose (logical, default = `TRUE`) Whether to print the generated command before execution. Useful for debugging.
#' @param opts_after_outfile (logical, default = `FALSE`) Determines whether `opts` appear after `outfile` in the command.
#' @param frontopts (character, default = `""`) Options to prepend before the input file in the command.
#' @param bin_app (character, default = `"bin"`) Appendix for the Freesurfer bin directory, as returned by [get_fs()].
#' @param ... Additional arguments passed to [base::system()].
#'
#' @return
#' If `retimg = TRUE`, returns an object of class `nifti` containing the output image.
#' Otherwise, returns the result of the system command execution.
#'
#' @details
#' - To overwrite the input file, set `outfile = file`. A warning will be displayed for safety.
#' - `opts` and `frontopts` let you define custom options fielded before or after the file inputs.
#' - If opts_after_outfile is `TRUE`, the `opts` string will be placed after the output file in the command.
#'
#' @examples
#' \dontrun{
#'
#' # Basic usage
#' fs_cmd(
#'   func = "mri_convert",
#'   file = "input.mgz",
#'   outfile = "output.nii.gz",
#'   opts = "--conform"
#' )
#'
#' # Overwriting the input file
#' fs_cmd(
#'   func = "mri_convert",
#'   file = "image.nii.gz",
#'   outfile = "image.nii.gz",
#'   opts = "--conform"
#' )
#'
#' # Returning output as a nifti object
#' img <- fs_cmd(
#'   func = "mri_convert",
#'   file = "input.mgz",
#'   retimg = TRUE
#' )
#' }
#' @importFrom neurobase checkimg check_outfile readnii nii.stub
#' @importFrom cli cli_warn cli_code
#' @export
fs_cmd = function(
  func,
  file,
  outfile = NULL,
  retimg = TRUE,
  reorient = FALSE,
  intern = FALSE,
  opts = "",
  verbose = get_fs_verbosity(),
  opts_after_outfile = FALSE,
  frontopts = "",
  bin_app = "bin",
  ...
) {
  # Ensure file exists
  file <- checkimg(file)

  # Warn if outfile and file are the same to prevent accidental overwrite
  if (!is.null(outfile)) {
    if (normalizePath(file) == normalizePath(outfile)) {
      cli::cli_warn(
        "Input file and output file are the same. This will overwrite the input file."
      )
    }
  }

  # Get Freesurfer command base
  cmd = get_fs(bin_app = bin_app)

  # Construct the command with frontopts
  base_cmd <- sprintf('%s %s', func, frontopts)
  base_cmd <- gsub("\\s\\s+", " ", base_cmd)
  base_cmd <- sub("[ \t\r\n]+$", "", base_cmd, perl = TRUE)
  cmd <- sprintf('%s %s "%s"', cmd, base_cmd, file)

  # Handle outfile and extensions
  no_outfile = is.null(outfile)

  if (!no_outfile) {
    outfile <- check_outfile(
      outfile = outfile,
      retimg = retimg,
      fileext = ext
    )

    cmd <- sprintf(
      '%s %s "%s"',
      cmd,
      ifelse(!opts_after_outfile, opts, outfile),
      ifelse(opts_after_outfile, opts, outfile)
    )
  } else {
    cmd <- paste(cmd, opts)
  }

  # Debug log
  if (verbose) {
    cli::cli_text("Freesurfer command: {.code {cmd}}")
  }

  res <- try_fs_cmd(cmd, intern = intern)

  # Process output if retimg is TRUE
  if (retimg) {
    img_path <- if (no_outfile) file else outfile
    check_path(img_path, error = TRUE)

    img <- readnii(img_path, reorient = reorient)
    return(img)
  }

  return(res)
}
