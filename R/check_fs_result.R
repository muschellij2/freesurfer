#' Check Freesurfer Result
#'
#' Checks the Freesurfer system command result and will
#' stop or warn based on exit status and whether output files exist.
#' @param res (numeric) Exit status from system command (0 = success)
#' @param fe_before (logical) Did the output file exist before the command ran?
#' @param fe_after (logical) Does the output file exist after the command ran?
#' @param outfile (character, optional) Output file path for more informative messages
#' @param func_name (character, optional) Function name for context in messages
#'
#' @return No return value, called for side effects
#' @noRd
check_fs_result <- function(
  res,
  fe_before,
  fe_after,
  outfile = NULL,
  func_name = NULL
) {
  # Extract exit status - handle both direct numeric and system() result with status attribute
  exit_status <- if (!is.null(attr(res, "status"))) {
    attr(res, "status")
  } else if (is.numeric(res) && length(res) == 1) {
    res
  } else {
    0 # Assume success if we got output (length > 1 means stdout was captured)
  }

  # Build context for messages
  context <- if (!is.null(func_name)) {
    paste("FreeSurfer command:", func_name)
  } else {
    "FreeSurfer command"
  }

  file_info <- if (!is.null(outfile)) {
    paste("Expected output:", outfile)
  } else {
    NULL
  }

  # Check 1: Command failed AND no output produced
  if (exit_status != 0 && !fe_after) {
    fs_abort(
      "Command failed with no output produced",
      cmd = func_name,
      details = file_info
    )
  }

  # Check 2: Command succeeded but no output produced
  if (exit_status == 0 && !fe_after) {
    fs_warn(
      "Command completed but no output file was created",
      cmd = func_name,
      details = file_info
    )
  }

  # Check 3: Command failed but output exists from before
  if (exit_status != 0 && fe_after && fe_before) {
    fs_warn(
      "Command failed but output file exists from previous run",
      cmd = func_name,
      details = "Please verify the output file is correct"
    )
  }

  # Check 4: Command failed but created output anyway
  if (exit_status != 0 && fe_after && !fe_before) {
    fs_warn(
      "Command failed but created output file",
      cmd = func_name,
      details = "Output may be incomplete - please verify before using"
    )
  }

  invisible(NULL)
}


#' @title Run and Check a Freesurfer Command
#' @description Checks whether an output filename exists before a command
#' has run, prints and runs the command, and then checks the output from the
#' result.
#'
#' @param cmd Command to be run
#' @param outfile Output file to be produced
#' @template verbose
#' @param func_name Optional function name for better error messages
#' @param ... Additional arguments to pass to \code{\link{system}}
#' @seealso \code{\link{check_fs_result}}
#' @keywords internal
#' @noRd
#' @return Invisible NULL
run_check_fs_cmd <- function(
  cmd,
  outfile,
  verbose = get_fs_verbosity(),
  func_name = NULL,
  ...
) {
  fe_before <- check_path(outfile, error = FALSE)

  if (verbose) {
    cli::cli_code(cmd)
  }

  res <- try_fs_cmd(cmd, ...)
  fe_after <- check_path(outfile, error = FALSE)

  check_fs_result(
    res = res,
    fe_before = fe_before,
    fe_after = fe_after,
    outfile = outfile,
    func_name = func_name
  )

  invisible(NULL)
}
