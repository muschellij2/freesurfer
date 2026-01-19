#' Wrapper for getting FreeSurfer help
#'
#' This function takes in the function and returns the
#' help from FreeSurfer for that function with simple validation.
#'
#' @param func_name FreeSurfer function name
#' @param help_arg Argument to print help, usually "--help"
#' @param extra_args Extra arguments to be passed other than
#'   \code{--help}
#' @param timeout_seconds Timeout for help command (default 30 seconds)
#' @param display Logical; whether to display help output
#' @param warn Logical; whether to warn if help is not available
#' @param bin_app Character string specifying the FreeSurfer bin directory
#'   appendix. Options are `"bin"` (default) or `"mni/bin"` for MNI tools.
#' @param ... additional arguments to \code{\link{get_fs}}
#' @return Prints help output and returns output as character vector
#' @export
#' @examplesIf have_fs()
#' fs_help("mri_watershed")
#'
#' # For MNI tools
#' fs_help("nu_correct", help_arg = "-help", bin_app = "mni/bin")
fs_help <- function(
  func_name,
  help_arg = "--help",
  extra_args = "",
  timeout_seconds = 30,
  display = TRUE,
  warn = TRUE,
  bin_app = "bin",
  ...
) {
  # Simple validation
  validate_fs_env(check_license = FALSE)

  if (
    !is.character(func_name) || length(func_name) != 1 || !nzchar(func_name)
  ) {
    fs_abort("{.arg func_name} must be a non-empty character string")
  }

  # Build help command
  cmd <- get_fs(bin_app = bin_app, ...)
  cmd <- paste0(cmd, func_name)
  help_args <- paste(help_arg, extra_args, collapse = " ")
  help_args <- trimws(help_args)

  cmd <- paste(cmd, help_args)

  res <- suppressWarnings({
    try_fs_cmd(
      cmd,
      context = paste("Getting help for", func_name),
      timeout_seconds = timeout_seconds,
      intern = TRUE
    )
  })

  # Simple validation of results
  if (warn) {
    if (length(res) == 0) {
      fs_warn(
        "No help output returned for command: {.val {func_name}}",
        details = "Command may not support help or may not exist"
      )
    } else if (
      any(grepl(
        "command not found|not recognized|unknown command",
        res,
        ignore.case = TRUE
      ))
    ) {
      fs_warn(
        "Command {.val {func_name}} appears to be unrecognized by FreeSurfer",
        details = "Check command spelling and FreeSurfer installation"
      )
    }
  }

  if (display) {
    cli::cli_code(res)
  }

  invisible(res)
}
