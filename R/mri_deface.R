#' MRI Deface
#' @description This calls Freesurfer's \code{mri_deface} 
#'
#' @param file File to pass to \code{mri_deface} 
#' @param brain_template \code{gca} brain template file to pass to \code{mri_deface} 
#' @param face_template \code{gca} face template file to pass to \code{mri_deface} 
#' @param ... Additional arguments to pass to \code{\link{fs_cmd}}
#' 
#' @note If \code{brain_template} or\code{face_template} is \code{NULL},
#' they will be downloaded.
#' @return Result of \code{fs_cmd}, which type depends on 
#' arguments to \code{...}
#' @export
#' @examples 
#' \donttest{
#' if (have_fs()){
#'    base_url = "https://surfer.nmr.mgh.harvard.edu/pub/dist/mri_deface"
#'    url = file.path(base_url, "sample_T1_input.mgz")
#'    x = tempfile(fileext = ".mgz")
#'    out = try({
#'    utils::download.file(url, destfile = x)
#'    })
#'    if (!inherits(out, "try-error")) {
#'       noface = mri_deface(x)
#'    } else {
#'       url = paste0(
#'          "https://raw.githubusercontent.com/muschellij2/kirby21.t1/master/", 
#'          "inst/visit_1/113/113-01-T1.nii.gz")
#'       x = tempfile(fileext = ".nii.gz")
#'       out = try({
#'           utils::download.file(url, destfile = x)
#'       })
#'       noface = mri_deface(x)
#'    }
#' }
#' }
mri_deface = function(
  file,
  brain_template = NULL,
  face_template = NULL,
  ...){
  base_url = "https://surfer.nmr.mgh.harvard.edu/pub/dist/mri_deface"
  brain_url = file.path(base_url, "talairach_mixed_with_skull.gca.gz")
  face_url = file.path(base_url, "face.gca.gz")
  download_unzip = function(url) {
    x = tempfile(fileext = ".gca.gz")
    utils::download.file(url, destfile = x)
    x = R.utils::gunzip(x)
    x
  }  
  if (is.null(brain_template)) {
    brain_template = download_unzip(brain_url)
  }
  if (is.null(face_template)) {
    face_template = download_unzip(face_url)
  }
  face_template = normalizePath(face_template)
  brain_template = normalizePath(brain_template)
  opts = paste0(brain_template, " ", face_template)
  fs_cmd(func = "mri_deface",
         file = file,
         opts_after_outfile = FALSE,
         opts = opts,
         ...)
}
