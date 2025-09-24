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

  # Batch check all files at once
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
    } else if (warn) {
      fs_warn(
        "Some files are missing",
        details = paste("Missing files:", paste(missing_files, collapse = ", "))
      )
    }
  }

  exists_result
}

#' Validate FreeSurfer input files with batch checking
#' @param files Character vector or single file path
#' @param must_exist Should all files be required to exist?
#' @param formats Valid file extensions (optional)
#' @return Validated file paths
#' @export
validate_fs_inputs <- function(files, must_exist = TRUE, formats = NULL) {
  if (length(files) == 0) {
    fs_abort("No input files provided")
  }

  # Expand file paths
  files <- path.expand(files)

  # Check file extensions if specified
  if (!is.null(formats)) {
    file_exts <- tools::file_ext(files)
    valid_exts <- sapply(files, function(f) {
      ext <- tools::file_ext(f)
      any(ext %in% formats)
    })

    if (!all(valid_exts)) {
      invalid_files <- files[!valid_exts]
      fs_abort(
        "Invalid file formats detected",
        details = paste(
          "Expected formats:",
          paste(formats, collapse = ", "),
          "\nInvalid files:",
          paste(invalid_files, collapse = ", ")
        )
      )
    }
  }

  # Batch check file existence
  if (must_exist) {
    batch_file_exists(files, error = TRUE)
  }

  return(files)
}

#' Enhanced version of check_path with better error context
#' @param paths Character vector of paths to check
#' @param error Should missing paths trigger an error?
#' @param context Additional context for error messages
#' @return Named logical vector indicating which paths exist
#' @noRd
check_paths <- function(paths, error = TRUE, context = NULL) {
  if (length(paths) == 0) {
    if (error) {
      fs_abort("No paths provided to check")
    }
    return(logical(0))
  }

  exists_result <- batch_file_exists(paths, error = FALSE, warn = FALSE)
  missing_paths <- paths[!exists_result]

  if (length(missing_paths) > 0 && error) {
    msg <- if (length(missing_paths) == 1) {
      paste("Path does not exist:", missing_paths)
    } else {
      paste(
        "Multiple paths do not exist:",
        paste(missing_paths, collapse = ", ")
      )
    }

    details <- if (!is.null(context)) {
      paste("Context:", context)
    } else {
      NULL
    }

    fs_abort(msg, details = details)
  }

  return(exists_result)
}

#' utility to silently create directories
#' @noRd
mkdir <- function(path) {
  dir.create(
    path,
    showWarnings = FALSE,
    recursive = TRUE
  )
}

#' Create a Temporary File with a Newly Created Directory
#'
#' The `temp_file` function generates a temporary file path and ensures
#' that the directory containing the file exists by creating it if necessary.
#'
#' @param ... Arguments passed to the \code{\link{tempfile}} function, typically
#'        used to customize the prefix, suffix, or pattern of the
#'        temporary file name.
#'
#' @return A character string representing the full file path to the
#'         temporary file. The directory containing the file will be
#'         created if it does not already exist.
#'
#' @details This function leverages \code{\link{tempfile}} to create a unique
#'          file path within the system's temporary directory. Before
#'          returning the file path, it ensures any required
#'          directories are created using the \code{\link{dir.create}} function.
#'
#' @examples
#' # Create a temporary file and its directory
#' file_path <- temp_file(pattern = "example_")
#'
#' # Print the file path
#' print(file_path)
#'
#' # Check if the directory exists
#' dir.exists(dirname(file_path))
#'
#' @export
temp_file <- function(...) {
  x <- tempfile(...)
  mkdir(dirname(x))
  x
}


#' Check if a file path exists
#' @noRd
check_path <- function(path, error = TRUE) {
  x <- file.exists(path)
  if (error && !x) {
    cli::cli_abort("File {.path {path}} does not exist")
  }
  x
}

check_outfile <- function(outfile, retimg, fileext = ".nii.gz") {
  if (retimg && is.null(outfile)) {
    return(tempfile(fileext = fileext))
  }

  if (is.null(outfile)) {
    cli::cli_abort(
      "Outfile is {.code NULL}, and {.code retimg = FALSE}, one of these must be changed"
    )
  }

  path.expand(outfile)
}

#' Batch validation for multiple file types commonly used together
#' @param input_files Input files to validate
#' @param output_files Output files to prepare (optional)
#' @param must_exist_input Should input files be required to exist?
#' @param create_output_dirs Should output directories be created?
#' @return List with validated input and output file paths
#' @noRd
batch_validate_files <- function(
  input_files = NULL,
  output_files = NULL,
  must_exist_input = TRUE,
  create_output_dirs = TRUE
) {
  result <- list()

  # Validate input files
  if (!is.null(input_files)) {
    result$input <- validate_fs_inputs(
      input_files,
      must_exist = must_exist_input
    )
  }

  # Validate/prepare output files
  if (!is.null(output_files)) {
    output_files <- path.expand(output_files)

    if (create_output_dirs) {
      # Create parent directories for all output files
      output_dirs <- unique(dirname(output_files))
      sapply(output_dirs, mkdir)
    }

    result$output <- output_files
  }

  result
}


#' Validate and prepare output file path
#' @param outfile Output file path (can be NULL)
#' @param retimg Should image be returned?
#' @param default_ext Default file extension
#' @return Valid output file path
#' @noRd
validate_outfile <- function(outfile, retimg = TRUE, default_ext = ".nii.gz") {
  # If returning image and no outfile specified, create temp file
  if (retimg && is.null(outfile)) {
    outfile <- temp_file(fileext = default_ext)
    return(outfile)
  }

  # If not returning image, outfile is required
  if (!retimg && is.null(outfile)) {
    fs_abort(
      "Output file path required when retimg = FALSE",
      details = "Either provide outfile or set retimg = TRUE"
    )
  }

  # Expand and validate path
  if (!is.null(outfile)) {
    outfile <- path.expand(outfile)

    # Create parent directory if it doesn't exist
    parent_dir <- dirname(outfile)
    if (!dir.exists(parent_dir)) {
      mkdir(parent_dir)
    }
  }

  return(outfile)
}

#' Check if file has valid FreeSurfer/neuroimaging format
#' @param files Character vector of file paths
#' @param valid_formats Valid file extensions (default: common neuroimaging formats)
#' @return Logical vector indicating which files have valid formats
#' @noRd
check_neuro_formats <- function(
  files,
  valid_formats = c("nii", "nii.gz", "mgz", "mgh")
) {
  if (length(files) == 0) {
    return(logical(0))
  }

  file_exts <- tools::file_ext(files)
  # Handle .nii.gz case
  file_exts[grepl("\\.nii\\.gz$", files)] <- "nii.gz"

  valid <- file_exts %in% valid_formats
  names(valid) <- files

  return(valid)
}
