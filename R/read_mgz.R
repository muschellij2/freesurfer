# Final R/read_mgz.R - Clean MGZ reader

#' Read MGH or MGZ File
#' @description This function calls \code{mri_convert}
#' to convert MGH/MGZ files to NIfTI, then reads it in using
#' \code{\link[neurobase]{readnii}} with enhanced validation.
#' @param file (character) input filename - MGH or MGZ file
#' @param validate_format (logical) Whether to validate file format
#' @param cleanup_temp (logical) Whether to clean up temporary files
#' @param ... Additional arguments to pass to \code{\link{fs_cmd}}
#' @return Object of class \code{nifti}
#' @importFrom neurobase readnii
#' @export
read_mgz <- function(file, validate_format = TRUE, cleanup_temp = TRUE, ...) {
  # Simple validation
  validate_fs_inputs(file, must_exist = TRUE)

  # Format validation - just warn, don't block
  if (validate_format) {
    valid_formats <- c("mgz", "mgh")
    file_ext <- tools::file_ext(file)

    if (nzchar(file_ext) && !file_ext %in% valid_formats) {
      fs_warn(
        "Unexpected file format for read_mgz",
        details = paste(
          "Got:",
          file_ext,
          "| Expected: mgz or mgh",
          "| For other formats, use mri_convert() directly"
        )
      )
    }
  }

  # Create temporary output file
  outfile <- temp_file(fileext = ".nii.gz")

  # Set up cleanup
  if (cleanup_temp) {
    on.exit(unlink(outfile), add = TRUE)
  }

  # Convert to NIfTI format - let mri_convert handle errors
  mri_convert(file, outfile, ...)

  # Verify conversion was successful
  if (!file.exists(outfile)) {
    fs_abort(
      "MGZ conversion failed - no output file created",
      details = paste("Input:", file, "| Expected output:", outfile)
    )
  }

  # Read the converted NIfTI file - let readnii handle its own errors
  result <- neurobase::readnii(outfile)

  # Add metadata about original file
  attr(result, "original_file") <- file
  attr(result, "original_format") <- tools::file_ext(file)

  if (get_fs_verbosity()) {
    fs_inform(
      paste("Successfully read", tools::file_ext(file), "file as NIfTI"),
      details = paste("Original file:", basename(file))
    )
  }

  result
}

#' @rdname read_mgz
#' @export
read_mgh <- read_mgz

# Deprecated aliases ----

#' @rdname read_mgz
#' @export
#' @usage NULL
readmgz <- function(file, ...) {

  lifecycle::deprecate_warn("1.8.2", "readmgz()", "read_mgz()")

  read_mgz(file, ...)
}

#' @rdname read_mgz
#' @export
#' @usage NULL
readmgh <- function(file, ...) {

  lifecycle::deprecate_warn("1.8.2", "readmgh()", "read_mgh()")
  read_mgh(file, ...)
}
