#' Convert Medical Image Formats with FreeSurfer
#'
#' @description
#' Calls FreeSurfer's `mri_convert` to convert between different medical imaging
#' formats (NIfTI, MGZ, MINC, etc.) with enhanced format validation and error
#' handling.
#'
#' @details
#' Runtime FreeSurfer CLI help is available via the helper
#' function \code{mri_convert.help()}. When called, that helper will attempt
#' to fetch and display the underlying FreeSurfer command-line help if
#' FreeSurfer is installed on the system. The package does not embed the
#' CLI help into the installed Rd at package build time.
#'
#' This function provides format validation and informative messages about
#' conversions between different image types.
#'
#' @param file Character; input filename or nifti object.
#' @param outfile Character; output filename.
#' @template opts
#' @param format_check Logical; whether to validate input/output formats and
#'   warn about unexpected formats. Default is `TRUE`.
#' @param timeout_seconds Numeric; command timeout in seconds. Default is 300.
#' @param ... Additional arguments passed to [fs_cmd()].
#'
#' @return
#' Result of [base::system()] command, typically exit status.
#'
#' @section FreeSurfer Command Help:
#' When FreeSurfer is installed and available, detailed command-line help
#' for the underlying `mri_convert` command can be accessed via
#' `mri_convert.help()`. This provides comprehensive information about
#' FreeSurfer's native command options, file format support, and usage examples.
#'
#' To see FreeSurfer CLI help: `mri_convert.help()`
#'
#' @seealso
#' [fs_cmd()] for the underlying command wrapper
#'
#' @name mri_convert
#' @export
#'
#' @examplesIf have_fs()
#' # Convert nifti object to MGZ format
#' img <- oro.nifti::nifti(array(rnorm(5*5*5), dim = c(5, 5, 5)))
#' res <- mri_convert(img, outfile = temp_file(fileext = ".mgz"))
#'
#' \dontrun{
#' # Convert MGZ to NIfTI
#' mri_convert("brain.mgz", "brain.nii.gz")
#'
#' # With additional options
#' mri_convert("brain.mgz", "brain.nii.gz", opts = "--conform")
#' }
mri_convert <- function(
  file,
  outfile,
  opts = "",
  format_check = TRUE,
  timeout_seconds = 300,
  ...
) {
  # Simple validation
  validate_fs_env(check_license = FALSE)

  # Format validation - just warn for unexpected formats, don't block
  if (format_check && !inherits(file, "nifti")) {
    valid_input_formats <- c("nii", "nii.gz", "mgz", "mgh", "mnc")
    valid_output_formats <- c("nii", "nii.gz", "mgz", "mgh", "mnc")

    # Check input format
    input_ext <- tools::file_ext(file)
    if (grepl("\\.nii\\.gz$", file)) {
      input_ext <- "nii.gz"
    }

    if (nzchar(input_ext) && !input_ext %in% valid_input_formats) {
      fs_warn(
        "Unexpected input file format for mri_convert",
        details = paste(
          "Got:",
          input_ext,
          "| Expected:",
          paste(valid_input_formats, collapse = ", ")
        )
      )
    }

    # Check output format
    output_ext <- tools::file_ext(outfile)
    if (grepl("\\.nii\\.gz$", outfile)) {
      output_ext <- "nii.gz"
    }

    if (nzchar(output_ext) && !output_ext %in% valid_output_formats) {
      fs_warn(
        "Unexpected output file format for mri_convert",
        details = paste(
          "Got:",
          output_ext,
          "| Expected:",
          paste(valid_output_formats, collapse = ", ")
        )
      )
    }

    # Inform about format conversion if verbose
    if (get_fs_verbosity() && nzchar(input_ext) && nzchar(output_ext)) {
      input_type <- if (input_ext %in% c("mgz", "mgh")) {
        "FreeSurfer"
      } else {
        "NIfTI"
      }
      output_type <- if (output_ext %in% c("mgz", "mgh")) {
        "FreeSurfer"
      } else {
        "NIfTI"
      }

      if (input_type != output_type) {
        fs_inform(
          paste("Converting from", input_type, "to", output_type, "format"),
          details = paste(input_ext, "->", output_ext)
        )
      }
    }
  }

  fs_cmd(
    func = "mri_convert",
    file = file,
    outfile = outfile,
    frontopts = opts,
    retimg = FALSE,
    timeout_seconds = timeout_seconds,
    validate_inputs = !inherits(file, "nifti"),
    ...
  )
}

#' @describeIn mri_convert Display FreeSurfer help for mri_convert
#' @param ... Additional arguments passed to [fs_help()]
#' @export
mri_convert.help <- function(...) {
  fs_help("mri_convert", ...)
}
