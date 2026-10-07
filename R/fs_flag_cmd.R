#' Run a Flag-Based FreeSurfer Command
#'
#' The flag-based counterpart to [fs_cmd()], for FreeSurfer tools that take
#' `--flag value` arguments (such as `mri_vol2vol`). The command is assembled
#' from a named list of flags and run with the FreeSurfer environment set up.
#'
#' @param func Character; the FreeSurfer command, e.g. `"mri_vol2vol"`.
#' @param args Named list of command flags: `name = value` becomes
#'   `--name <value>`, `TRUE` becomes a bare `--name`, and `NULL` or `FALSE` are
#'   dropped. Order is preserved and values are quoted with [base::shQuote()].
#' @param outfile Character; the file the command is expected to create, checked
#'   after it runs.
#' @template opts
#' @template verbose
#' @param ... Additional arguments controlling command execution, such as a
#'   timeout.
#'
#' @return The `outfile`, invisibly.
#' @seealso [fs_cmd()] for positional-argument commands.
#' @export
#'
#' @examplesIf have_fs()
#' \dontrun{
#' out <- temp_file(fileext = ".nii.gz")
#' fs_flag_cmd(
#'   "mri_vol2vol",
#'   args = list(
#'     mov = "mov.nii.gz",
#'     targ = "targ.mgz",
#'     regheader = TRUE,
#'     o = out
#'   ),
#'   outfile = out
#' )
#' }
fs_flag_cmd <- function(
  func,
  args = list(),
  outfile = NULL,
  opts = "",
  verbose = get_fs_verbosity(),
  ...
) {
  if (!is.list(args)) {
    cli::cli_abort("{.arg args} must be a named list of command flags.")
  }
  if (length(args) > 0 && is.null(names(args))) {
    cli::cli_abort("{.arg args} must be named; each name becomes a `--flag`.")
  }

  flags <- character(0)
  for (nm in names(args)) {
    val <- args[[nm]]
    is_dropped <- is.null(val) || (is.logical(val) && !isTRUE(val))
    if (is_dropped) {
      next
    }
    is_boolean <- isTRUE(val)
    flag <- if (is_boolean) {
      paste0("--", nm)
    } else {
      paste0("--", nm, " ", shQuote(val))
    }
    flags <- c(flags, flag)
  }

  fs_call <- paste0(get_fs(), func)
  cmd_parts <- c(fs_call, flags, opts)
  cmd <- trimws(paste(cmd_parts, collapse = " "))

  run_check_fs_cmd(
    cmd = cmd,
    outfile = outfile,
    verbose = verbose,
    func_name = func,
    ...
  )
  invisible(outfile)
}
