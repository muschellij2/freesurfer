#' @title Use Freesurfers MRI Segmentation Algorithm
#' @description This function calls \code{mri_segment}
#' to segment tissues from an image
#' @param file (character) input filename
#' @param outfile (character) output filename
#' @param retimg (logical) return image of class nifti
#' @template opts
#' @param ... additional arguments passed to \code{\link{fs_cmd}}.
#' @return Character or nifti depending on \code{retimg}
#'
#' @note NOT COMPLETE
mri_segment = function(
  file,
  outfile = NULL,
  retimg = TRUE,
  opts = "",
  ...
) {
  res = fs_cmd(
    func = "mri_segment",
    file = file,
    outfile = outfile,
    frontopts = opts,
    retimg = retimg,

    ...
  )
  return(res)
}


#' @title MRI Segment Help
#' @description This calls Freesurfer's \code{mri_segment} help
#'
#' @return Result of \code{fs_help}
mri_segment.help = function() {
  fs_help("mri_segment")
}
