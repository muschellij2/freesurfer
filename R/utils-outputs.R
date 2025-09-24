#' FreeSurfer-specific error with context
#' @param msg Main error message
#' @param cmd FreeSurfer command that failed (optional)
#' @param details Additional error details (optional)
#' @param call Should the calling function be included? Default TRUE
#' @keywords internal
#' @noRd
fs_abort <- function(msg, cmd = NULL, details = NULL, .envir = parent.frame()) {
  error_msgs <- c("x" = msg)

  if (!is.null(cmd)) {
    error_msgs <- c(error_msgs, "!" = paste("FreeSurfer command:", cmd))
  }

  if (!is.null(details)) {
    error_msgs <- c(error_msgs, "i" = details)
  }

  cli::cli_abort(
    error_msgs,
    .envir = .envir
  )
}

#' FreeSurfer-specific warning with context
#' @param msg Warning message
#' @param cmd FreeSurfer command (optional)
#' @param details Additional details (optional)
#' @keywords internal
#' @noRd
fs_warn <- function(msg, cmd = NULL, details = NULL, .envir = parent.frame()) {
  warning_msgs <- c("!" = msg)

  if (!is.null(cmd)) {
    warning_msgs <- c(warning_msgs, "i" = paste("Command:", cmd))
  }

  if (!is.null(details)) {
    warning_msgs <- c(warning_msgs, "i" = details)
  }

  fs_warn(warning_msgs, .envir = .envir)
}

#' FreeSurfer-specific informational message
#' @param msg Information message
#' @param details Additional details (optional)
#' @keywords internal
#' @noRd
fs_inform <- function(msg, details = NULL, .envir = parent.frame()) {
  info_msgs <- c("v" = msg)

  if (!is.null(details)) {
    info_msgs <- c(info_msgs, "i" = details)
  }

  cli::cli_inform(info_msgs, .envir = .envir)
}
