
#' @title Check Freesurfer Result
#' @description Checks the Freesurfer system command result and will
#' stop or warning based on whether output files exist.
#' @param res (numeric) Result from system command 
#' @param fe_before (logical) did the output file exist before the command ran
#' @param fe_after (logical) did the output file exist after the command ran
#'
#' @return No return value, called for side effects
#' @export
check_fs_result = function(res, fe_before, fe_after) {
  if (res != 0 & !fe_after) {
    stop("Command Failed, no output produced!")
  }
  if (res == 0 & !fe_after) {
    warning("Command assumed passed, but no output produced")
  }  
  if (res != 0 & fe_after & fe_before) {
    warning(paste0(
      " Command had non-zero exit status (probably failed),",
      " outfile exists but existed before command was run. ",
      " Please check output.")
    )
  }  
  
  if (res != 0 & fe_after & !fe_before) {
    warning(paste0(
      " Command had non-zero exit status (probably failed),",
      " outfile exists and did NOT before command was run. ",
      " Please check output.")
    )
  }  
  return(invisible(NULL))
}