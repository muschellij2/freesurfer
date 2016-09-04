#' @title MRI information
#' @description This calls Freesurfer's \code{mri_info} 
#'
#' @param file File to pass to \code{mri_info} 
#' @param ... Additional arguments to pass to \code{\link{fs_cmd}}
#'
#' @return Result of \code{fs_cmd}, which type depends on 
#' arguments to \code{...}
#' @export
mri_info = function(file, 
                    ...){
  fs_cmd(func = "mri_info",
    file = file,
    ...)
}