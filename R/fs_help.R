#' @title Wrapper for getting Freesurfer help
#' @description This function takes in the function and returns the
#' help from Freesurfer for that function
#' @param func_name Freesurfer function name
#' @param help.arg Argument to print help, usually "--help" 
#' @param extra.args Extra arguments to be passed other than 
#' \code{--help}
#' @param ... additional arguments to \code{\link{get_fs}}
#' @return Prints help output and returns output as character vector
#' @export
#' @examples 
#' if (have_fs()) {
#' fs_help(func_name = "mri_watershed")
#' }
fs_help = function(func_name, help.arg = "--help", extra.args = "", ...){
  cmd = get_fs(...)
  cmd <- paste0(cmd, sprintf('%s %s %s', func_name, 
                             help.arg, extra.args))
  #     args = paste(help.arg, extra.args, sep=" ", collapse = " ")
  suppressWarnings({res = system(cmd, intern = TRUE)})
  #     res = system2(func_name, args = args, stdout=TRUE, stderr=TRUE)
  cat(res, sep = "\n")
  return(invisible(res))
}

#' Render FreeSurfer CLI help as Rd markup
#'
#' Called at render time by `\Sexpr` in generated .Rd files.
#' Returns valid Rd markup showing CLI help or a fallback message.
#'
#' @param func_name FreeSurfer function name
#' @param help_arg Argument to print help
#' @param bin_app FreeSurfer bin directory appendix
#' @return Character string of Rd markup
#' @export
fs_help_rd <- function(func_name, help_arg = "--help", bin_app = "bin") {
  if (!have_fs()) {
    return(paste0(
      "FreeSurfer is not installed. Run \\code{",
      func_name,
      ".help()} in a FreeSurfer-enabled session."
    ))
  }

  help_text <- tryCatch(
    {
      cmd <- get_fs(bin_app = bin_app)
      cmd <- paste0(cmd, sprintf("%s %s", func_name, help_arg))
      suppressWarnings(system(cmd, intern = TRUE))
    },
    error = function(e) NULL
  )

  if (is.null(help_text) || length(help_text) == 0) {
    return(paste0("Help not available for \\code{", func_name, "}."))
  }

  escaped <- help_text
  escaped <- gsub("\\", "\\\\", escaped, fixed = TRUE)
  escaped <- gsub("{", "\\{", escaped, fixed = TRUE)
  escaped <- gsub("}", "\\}", escaped, fixed = TRUE)
  escaped <- gsub("%", "\\%", escaped, fixed = TRUE)

  paste0("\\preformatted{", paste(escaped, collapse = "\n"), "}")
}