#' FS Command Wrapper
#'
#' This function serves as a wrapper for Freesurfer commands,
#' with error handling, batch file validation, and performance optimizations.
#'
#' @param func (character) Freesurfer command to be executed.
#' @param file (character) Path to input image file(s). Can be vector for multiple files.
#' @param outfile (character, optional) Path to output image file. If `NULL` (default),
#'                and `retimg = TRUE`, a temporary file is created.
#' @param retimg (logical, default = `TRUE`) Whether to return output as nifti image.
#' @param reorient (logical, default = `FALSE`) If `retimg = TRUE`, whether to reorient when loading.
#' @param intern (logical, default = `FALSE`) Whether to capture command output.
#' @param opts (character, default = `""`) Additional options for the command.
#' @param verbose (logical, default = from `get_fs_verbosity()`) Whether to print command.
#' @param opts_after_outfile (logical, default = `FALSE`) Whether opts appear after outfile.
#' @param frontopts (character, default = `""`) Options to prepend before input file.
#' @param bin_app (character, default = `"bin"`) FreeSurfer bin directory appendix.
#' @param timeout_seconds (numeric, optional) Command timeout in seconds.
#' @param validate_inputs (logical, default = `TRUE`) Whether to validate input files.
#' @param create_output_dirs (logical, default = `TRUE`) Whether to create output directories.
#' @param ... Additional arguments passed to [base::system()].
#'
#' @return If `retimg = TRUE`, returns nifti object. Otherwise, returns system command result.
#'
#' @export
fs_cmd <- function(
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
  timeout_seconds = NULL,
  validate_inputs = TRUE,
  create_output_dirs = TRUE,
  ...
) {
  # Validate FreeSurfer environment first
  validate_fs_env(check_license = FALSE)

  # Batch validate inputs and prepare outputs
  if (validate_inputs) {
    file_validation <- batch_validate_files(
      input_files = file,
      output_files = outfile,
      must_exist_input = TRUE,
      create_output_dirs = create_output_dirs
    )
    file <- file_validation$input
    if (!is.null(outfile)) outfile <- file_validation$output
  } else {
    # Still need to expand paths even without validation
    file <- path.expand(file)
    if (!is.null(outfile)) outfile <- path.expand(outfile)
  }

  # Handle nifti objects - convert to file if needed
  if (inherits(file, "nifti")) {
    temp_input <- temp_file(fileext = ".nii.gz")
    neurobase::writenii(file, filename = temp_input)
    file <- temp_input
    on.exit(unlink(temp_input), add = TRUE)
  }

  # Validate and prepare output file
  outfile <- validate_outfile(outfile, retimg = retimg)

  # Check if input and output are the same (warn user)
  if (
    !is.null(outfile) &&
      length(file) == 1 &&
      normalizePath(file) == normalizePath(outfile)
  ) {
    fs_warn(
      "Input and output files are identical - file will be overwritten",
      details = paste("File:", outfile)
    )
  }

  # Check output file existence before command
  fe_before <- if (!is.null(outfile)) {
    check_paths(outfile, error = FALSE)
  } else {
    FALSE
  }

  # Build command string efficiently
  fs_prefix <- get_fs(bin_app = bin_app)

  # Construct command parts
  cmd_parts <- c(
    fs_prefix,
    func,
    if (frontopts != "") frontopts,
    file,
    if (!is.null(outfile) && !opts_after_outfile) outfile,
    if (opts != "") opts,
    if (!is.null(outfile) && opts_after_outfile) outfile
  )

  cmd <- paste(cmd_parts[cmd_parts != ""], collapse = " ")

  # Print command if verbose
  if (verbose) {
    cli::cli_code(cmd)
  }

  # Execute command with enhanced error handling
  context <- paste("FreeSurfer", func, "command")
  res <- try_fs_cmd(
    cmd,
    context = context,
    timeout_seconds = timeout_seconds,
    intern = intern,
    ...
  )

  # Check output file existence after command
  fe_after <- if (!is.null(outfile)) {
    check_paths(outfile, error = FALSE)
  } else {
    FALSE
  }

  # Enhanced result checking
  if (!is.null(outfile)) {
    check_fs_result_enhanced(
      res = if (is.null(attr(res, "status"))) 0 else attr(res, "status"),
      outfile = outfile,
      cmd = cmd,
      fe_before = fe_before,
      fe_after = fe_after
    )
  }

  # Return appropriate result
  if (retimg && !is.null(outfile)) {
    if (fe_after) {
      return(neurobase::readnii(outfile, reorient = reorient))
    } else {
      fs_warn("Cannot return image - output file was not created")
      return(NULL)
    }
  }
  res
}

#' Run FreeSurfer command with batch file processing
#'
#' Process multiple files with a single FreeSurfer command efficiently.
#'
#' @param func FreeSurfer command name
#' @param input_files Vector of input file paths
#' @param output_files Vector of output file paths (same length as input_files)
#' @param parallel (logical) Whether to process files in parallel (requires parallel package)
#' @param max_cores (numeric) Maximum number of cores to use for parallel processing
#' @param ... Additional arguments passed to fs_cmd_enhanced
#' @return List of results from each file processing
#' @export
fs_batch_process <- function(
  func,
  input_files,
  output_files = NULL,
  parallel = FALSE,
  max_cores = 2,
  ...
) {
  # Validate inputs
  if (length(input_files) == 0) {
    fs_abort("No input files provided for batch processing")
  }

  if (!is.null(output_files) && length(output_files) != length(input_files)) {
    fs_abort(
      "Mismatch between input and output file counts",
      details = paste(
        "Input files:",
        length(input_files),
        "Output files:",
        length(output_files)
      )
    )
  }

  # Batch validate all input files at once
  batch_file_exists(input_files, error = TRUE)

  # Create output file paths if not provided
  if (is.null(output_files)) {
    output_files <- sapply(input_files, function(f) {
      temp_file(fileext = paste0(".", tools::file_ext(f)))
    })
  }

  # Process function
  process_single <- function(i) {
    fs_cmd_enhanced(
      func = func,
      file = input_files[i],
      outfile = output_files[i],
      validate_inputs = FALSE, # Already validated in batch
      ...
    )
  }

  # Execute processing
  if (parallel && requireNamespace("parallel", quietly = TRUE)) {
    n_cores <- min(max_cores, parallel::detectCores() - 1, length(input_files))
    fs_inform(paste(
      "Processing",
      length(input_files),
      "files using",
      n_cores,
      "cores"
    ))

    results <- parallel::mclapply(
      seq_along(input_files),
      process_single,
      mc.cores = n_cores
    )
  } else {
    if (parallel) {
      fs_warn(
        "Parallel processing requested but 'parallel' package not available"
      )
    }
    fs_inform(paste("Processing", length(input_files), "files sequentially"))
    results <- lapply(seq_along(input_files), process_single)
  }

  names(results) <- basename(input_files)
  return(results)
}

#' Check FreeSurfer command availability
#'
#' Verify that a FreeSurfer command is available before attempting to use it.
#'
#' @param func_name FreeSurfer command name
#' @param bin_app FreeSurfer bin directory appendix
#' @return Logical indicating if command is available
#' @export
check_fs_cmd_available <- function(func_name, bin_app = "bin") {
  if (!have_fs()) {
    return(FALSE)
  }

  cmd <- paste(get_fs(bin_app = bin_app), func_name, "--help 2>/dev/null")

  result <- tryCatch(
    {
      system(cmd, intern = TRUE, ignore.stderr = TRUE)
      TRUE
    },
    error = function(e) FALSE
  )

  return(result)
}

#' Execute a System Command with Error Handling
#'
#' This function executes a system command using `system()` and handles potential
#' errors gracefully by capturing and reporting them in a user-friendly way.
#'
#' @param cmd Command to execute
#' @param context Description of what the command does
#' @param timeout_seconds Timeout in seconds (optional)
#' @param ... Additional arguments passed to system()
#' @return Result of system command
#' @keywords internal
#' @noRd
try_fs_cmd <- function(cmd, context = NULL, timeout_seconds = NULL, ...) {
  if (is.null(context)) {
    context <- paste("FreeSurfer command:", strsplit(cmd, " ")[[1]][1])
  }

  result <- tryCatch(
    {
      if (!is.null(timeout_seconds)) {
        # Use R.utils::withTimeout if available, otherwise fall back to system()
        if (requireNamespace("R.utils", quietly = TRUE)) {
          R.utils::withTimeout(
            system(cmd, ...),
            timeout = timeout_seconds,
            onTimeout = "error"
          )
        } else {
          fs_warn(
            "Timeout requested but R.utils not available, executing without timeout"
          )
          system(cmd, ...)
        }
      } else {
        system(cmd, ...)
      }
    },
    error = function(e) {
      if (grepl("timeout", e$message, ignore.case = TRUE)) {
        fs_abort(
          paste(context, "timed out"),
          cmd = cmd,
          details = paste("Timeout after", timeout_seconds, "seconds")
        )
      } else {
        fs_abort(
          paste(context, "failed with error"),
          cmd = cmd,
          details = e$message
        )
      }
    }
  )

  result
}

#' Enhanced version of check_fs_result with better messaging
#' @param res System command result
#' @param outfile Expected output file
#' @param cmd Command that was executed
#' @param fe_before Did output file exist before command?
#' @param fe_after Does output file exist after command?
#' @return Invisible NULL
#' @keywords internal
#' @noRd
check_fs_result_enhanced <- function(
  res,
  outfile,
  cmd,
  fe_before = FALSE,
  fe_after = FALSE
) {
  cmd_name <- strsplit(cmd, " ")[[1]][1]

  # Command failed and no output produced
  if (length(res) == 1 && res != 0 && !fe_after) {
    fs_abort(
      "FreeSurfer command failed with no output produced",
      cmd = cmd_name,
      details = paste("Expected output file:", outfile)
    )
  }

  # Command succeeded but no output produced (warning)
  if ((length(res) > 1 || res == 0) && !fe_after) {
    fs_warn(
      "Command completed but no output file was created",
      cmd = cmd_name,
      details = paste("Expected output file:", outfile)
    )
  }

  # Command failed but output exists (check if it existed before)
  if (length(res) == 1 && res != 0 && fe_after) {
    if (fe_before) {
      fs_warn(
        "Command failed but output file exists from previous run",
        cmd = cmd_name,
        details = "Please check if output is from a previous successful run"
      )
    }
    fs_warn(
      "Command failed but created output file",
      cmd = cmd_name,
      details = "Output may be incomplete or corrupted - please verify"
    )
  }

  invisible(NULL)
}

#' Validate FreeSurfer environment before command execution
#' @param check_license Should license file be checked?
#' @return Invisible TRUE if valid, error if not
#' @keywords internal
#' @noRd
validate_fs_env <- function(check_license = TRUE) {
  # Check if FreeSurfer is available
  if (!have_fs()) {
    fs_abort(
      "FreeSurfer installation not found",
      details = "Set FREESURFER_HOME environment variable or freesurfer.home R option"
    )
  }

  # Check license if requested
  if (check_license && !get_fs_license(simplify = FALSE)$exists) {
    fs_warn(
      "FreeSurfer license file not found",
      details = "Some functions may not work without a valid license"
    )
  }

  invisible(TRUE)
}
