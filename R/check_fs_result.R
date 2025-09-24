#' @title Check Freesurfer Result
#' @description Checks the Freesurfer system command result and will
#' stop or warning based on whether output files exist.
#' @param res (numeric) Result from system command
#' @param fe_before (logical) did the output file exist before the command ran
#' @param fe_after (logical) did the output file exist after the command ran
#'
#' @return No return value, called for side effects
#' @noRd
check_fs_result = function(res, fe_before, fe_after) {
  if ((length(res) == 1 && res != 0) && !fe_after) {
    cli::cli_abort("Command Failed, no output produced!")
  }
  if ((length(res) > 1 || res == 0) & !fe_after) {
    cli::cli_warn("Command assumed passed, but no output produced")
  }
  if ((length(res) == 1 && res != 0) & fe_after & fe_before) {
    cli::cli_warn(
      "Command had non-zero exit status (probably failed), 
      outfile exists but existed before command was run. 
      Please check output."
    )
  }

  if ((length(res) == 1 && res != 0) & fe_after & !fe_before) {
    cli::cli_warn(
      "Command had non-zero exit status (probably failed), 
      outfile exists and did {.strong not} before command was run. 
      Please check output."
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
#' @param ... Additional arguments to pass to \code{\link{system}}
#' @seealso \code{\link{check_fs_result}}
#'
#' @return Invisible NULL
#' @noRd
run_check_fs_cmd = function(cmd, outfile, verbose = get_fs_verbosity(), ...) {
  fe_before = check_path(outfile, error = FALSE)
  if (verbose) {
    cli::cli_code(cmd)
  }
  res = try_fs_cmd(cmd, ...)
  fe_after = check_path(outfile, error = FALSE)

  check_fs_result(res = res, fe_before = fe_before, fe_after = fe_after)
  invisible(NULL)
}
