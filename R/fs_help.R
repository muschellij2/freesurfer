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