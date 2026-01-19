#' Check existence of multiple files efficiently
#' @param files Character vector of file paths
#' @param error Should missing files trigger an error?
#' @param warn Should missing files trigger warnings?
#' @return Named logical vector indicating which files exist
#' @noRd
batch_file_exists <- function(files, error = FALSE, warn = FALSE) {
  if (length(files) == 0) {
    return(logical(0))
  }

  exists_result <- file.exists(files)
  names(exists_result) <- files

  missing_files <- files[!exists_result]
  if (length(missing_files) > 0) {
    if (error) {
      fs_abort(
        "Missing required files",
        details = paste(
          "Files not found:",
          paste(missing_files, collapse = ", ")
        )
      )
    }
    if (warn) {
      fs_warn(
        "Some files are missing",
        details = paste("Missing files:", paste(missing_files, collapse = ", "))
      )
    }
  }

  exists_result
}

#' Enhanced single path check for backward compatibility
#' @param path Single file path
#' @param error Should missing file trigger error?
#' @noRd
check_path <- function(path, error = TRUE) {
  if (length(path) != 1) {
    fs_abort(
      "check_path expects a single path, use batch_file_exists for multiple"
    )
  }

  x <- file.exists(path)
  if (error && !x) {
    fs_abort("File does not exist", details = path)
  }
  x
}

#' Validate FreeSurfer input files with batch checking
#' @param files Character vector or single file path
#' @param must_exist Should all files be required to exist?
#' @param formats Valid file extensions (optional)
#' @return Validated file paths
#' @noRd
validate_fs_inputs <- function(files, must_exist = TRUE, formats = NULL) {
  if (length(files) == 0) {
    fs_abort("No input files provided")
  }

  files <- path.expand(files)

  # Check file extensions if specified
  if (!is.null(formats)) {
    file_exts <- tools::file_ext(files)
    file_exts[grepl("\\.nii\\.gz$", files)] <- "nii.gz"

    valid_exts <- file_exts %in% formats
    if (!all(valid_exts)) {
      invalid_files <- files[!valid_exts]
      fs_abort(
        "Invalid file formats detected",
        details = paste(
          "Expected:",
          paste(formats, collapse = ", "),
          "\nInvalid:",
          paste(invalid_files, collapse = ", ")
        )
      )
    }
  }

  # Batch check file existence
  if (must_exist) {
    batch_file_exists(files, error = TRUE)
  }

  files
}

#' Enhanced outfile validation and preparation
#' @param outfile Output file path (can be NULL)
#' @param retimg Should image be returned?
#' @param default_ext Default file extension
#' @return Valid output file path
#' @noRd
validate_outfile <- function(outfile, retimg = TRUE, default_ext = ".nii.gz") {
  if (retimg && is.null(outfile)) {
    return(temp_file(fileext = default_ext))
  }

  if (!retimg && is.null(outfile)) {
    fs_abort(
      "Output file path required when retimg = FALSE",
      details = "Either provide outfile or set retimg = TRUE"
    )
  }

  if (!is.null(outfile)) {
    outfile <- path.expand(outfile)
    parent_dir <- dirname(outfile)
    if (!dir.exists(parent_dir)) {
      mkdir(parent_dir)
    }
  }

  outfile
}

# Legacy function for backward compatibility
check_outfile <- function(outfile, retimg, fileext = ".nii.gz") {
  validate_outfile(outfile, retimg, fileext)
}
