#' @title Run and Check a Freesurfer Command
#' @description Checks whether an output filename exists before a command
#' has run, prints and runs the command, and then checks the output from the
#' result.
#'
#' @param cmd Command to be run
#' @param outfile Output file to be produced
#' @param verbose print diagnostic messages
#' @param ... Additional arguments to pass to \code{\link{system}}
#' @seealso \code{\link{check_fs_result}}
#'
#' @return Invisible NULL
#' @export
run_check_fs_cmd = function(cmd, outfile, verbose = TRUE, ...) {
  fe_before = file.exists(outfile)
  if (verbose) {
    message(cmd, "\n")
  }
  res = system(cmd, ...)
  fe_after = file.exists(outfile)

  check_fs_result(res = res, fe_before = fe_before, fe_after = fe_after)
  return(invisible(NULL))
}
