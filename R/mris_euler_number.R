#' MRIs Euler Number
#'
#' This function calls \code{mris_euler_number} to calculate the Euler Number
#' with improved error handling and output management.
#'
#'
#' @param file (character) input filename - surface file
#' @param outfile (character) output filename for results (optional)
#' @param opts Character. Additional options to FreeSurfer function.
#' @param cleanup_temp (logical) Whether to clean up temporary files
#' @param timeout_seconds (numeric) Command timeout in seconds (default 120)
#' @param validate_format (logical) Whether to validate input format
#' @param ... Additional arguments to pass to \code{\link{fs_cmd}}
#' @return Character vector containing the Euler number results
#' @export
#' @examplesIf have_fs()
#' img = oro.nifti::nifti(array(rnorm(5*5*5), dim = c(5,5,5)))
#' res = mris_euler_number(img, outfile = temp_file(fileext = ".mgz"))
mris_euler_number <- function(
  file,
  outfile = NULL,
  opts = "",
  cleanup_temp = TRUE,
  timeout_seconds = 120,
  validate_format = TRUE,
  ...
) {
  # Validate FreeSurfer environment
  validate_fs_env(check_license = FALSE)

  # Validate input file format if requested
  if (validate_format && !inherits(file, "nifti")) {
    valid_formats <- c("mgz", "mgh", "nii", "nii.gz")
    file_ext <- tools::file_ext(file)
    if (grepl("\\.nii\\.gz$", file)) {
      file_ext <- "nii.gz"
    }

    if (!file_ext %in% valid_formats) {
      fs_warn(
        "Unexpected file format for mris_euler_number",
        details = paste(
          "Expected formats:",
          paste(valid_formats, collapse = ", "),
          "\nDetected format:",
          file_ext
        )
      )
    }
  }

  # Create output file if not specified
  if (is.null(outfile)) {
    outfile <- temp_file(fileext = ".txt")
    if (cleanup_temp) {
      on.exit(unlink(outfile), add = TRUE)
    }
  } else {
    # Ensure output directory exists
    parent_dir <- dirname(outfile)
    if (!dir.exists(parent_dir)) {
      mkdir(parent_dir)
    }
  }

  # Build command arguments
  # mris_euler_number outputs to stderr by default, redirect to file
  redirect_args <- paste0("2> ", shQuote(outfile))
  opts <- paste(opts, redirect_args)

  if (get_fs_verbosity()) {
    fs_inform(
      "Calculating Euler number for surface",
      details = paste("Input file:", file, "\nOutput file:", outfile)
    )
  }

  # Execute command with enhanced error handling
  tryCatch(
    {
      fs_cmd(
        func = "mris_euler_number",
        file = file,
        outfile = file, # mris_euler_number modifies input file in-place
        opts = opts,
        retimg = FALSE,
        timeout_seconds = timeout_seconds,
        validate_inputs = !inherits(file, "nifti"),
        ...
      )
    },
    error = function(e) {
      fs_abort(
        "Failed to calculate Euler number",
        cmd = "mris_euler_number",
        details = paste("Input file:", file, "\nError:", e$message)
      )
    }
  )

  # Read and validate results
  if (!file.exists(outfile)) {
    fs_warn(
      "Euler number calculation completed but no output file created",
      details = paste("Expected output file:", outfile)
    )
    return(NULL)
  }

  # Read results with error handling
  results <- tryCatch(
    {
      readLines(outfile, warn = FALSE)
    },
    error = function(e) {
      fs_abort(
        "Failed to read Euler number results",
        details = paste("Output file:", outfile, "\nError:", e$message)
      )
    }
  )

  # Validate results content
  if (length(results) == 0) {
    fs_warn(
      "Euler number output file is empty",
      details = paste("Output file:", outfile)
    )
    return(NULL)
  }

  # Extract numerical results if possible
  if (
    get_fs_verbosity() && any(grepl("euler|chi", results, ignore.case = TRUE))
  ) {
    euler_lines <- grep("euler|chi", results, ignore.case = TRUE, value = TRUE)
    fs_inform(
      "Euler number calculation completed",
      details = paste("Results:", paste(euler_lines, collapse = "; "))
    )
  }

  results
}

#' @title MRI Euler Number Help
#' @description This calls FreeSurfer's \code{mris_euler_number} help
#'
#' @param display Logical; whether to display help output
#' @param warn Logical; whether to warn if help is not available
#' @param ... Additional arguments passed to [fs_help()]
#' @export
mris_euler_number.help <- function(...) {
  fs_help("mris_euler_number", ...)
}
