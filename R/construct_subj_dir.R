#' @title Construct Subject Directory
#' @description This function copies files specified by the types of data,
#' determined by the folder Freesurfer put them in, into a temporary directory
#' for easier separation of data and different structuring of data.
#' @param label Files to copy to \code{subj_root_dir/subj/label} folder
#' @param mri Files to copy to \code{subj_root_dir/subj/mri} folder
#' @param stats Files to copy to \code{subj_root_dir/subj/stats} folder
#' @param surf Files to copy to \code{subj_root_dir/subj/surf} folder
#' @param touch Files to copy to \code{subj_root_dir/subj/touch} folder
#' @param subj Name of subject to make folder for to use for Freesurfer functions.
#' If \code{NULL}, a temporary id will be generated
#' @param subj_root_dir Directory to put folder with contents of \code{subj}
#'
#' @return List with the subject name, the SUBJECTS_DIR to use (the directory
#' that contains the subject name), and the types of objects copied
#' @export
#'
#' @examples
#' \dontrun{
#' library(freesurfer)
#' label = "/Applications/freesurfer/subjects/bert/label/aparc.annot.a2009s.ctab"
#' mri = c(
#'   "/Applications/freesurfer/subjects/bert/mri/aparc.a2009s+aseg.mgz",
#'   "/Applications/freesurfer/subjects/bert/mri/aseg.auto.mgz")
#' stats = c("/Applications/freesurfer/subjects/bert/stats/lh.aparc.stats",
#'           "/Applications/freesurfer/subjects/bert/stats/aseg.stats")
#' surf = "/Applications/freesurfer/subjects/bert/surf/lh.thickness"
#' construct_subj_dir(
#'   label = label,
#'   mri = mri,
#'   stats = stats,
#'   surf = surf)
#' }
construct_subj_dir = function(
  label = NULL,
  mri = NULL,
  stats = NULL,
  surf = NULL,
  touch = NULL,
  subj = NULL,
  subj_root_dir = tempdir(check = TRUE)
) {
  if (is.null(subj)) {
    subj = basename(temp_file())
  }
  base_dir = file.path(subj_root_dir, subj)
  mkdir(base_dir)

  L = list(label = label, mri = mri, stats = stats, surf = surf, touch = touch)
  # REMOVE NULL
  nulls = sapply(L, is.null)
  L = L[!nulls]
  type_names = fol_names = names(L)
  fol_names = file.path(base_dir, fol_names)

  sapply(fol_names, mkdir)

  res = mapply(
    function(y, fol) {
      N = length(y)
      res = rep(TRUE, length = N)
      out_names = file.path(fol, basename(y))
      for (ix in seq(N)) {
        x = y[ix]
        check_path(x)
        out = out_names[ix]
        res[ix] = file.copy(from = x, to = out)
      }
      R = list(
        res = res,
        out_names = out_names
      )
      return(R)
    },
    L,
    fol_names,
    SIMPLIFY = FALSE
  )
  out_names = lapply(res, `[[`, "out_names")
  res = lapply(res, `[[`, "res")
  res = unlist(res)
  stopifnot(all(res))

  invisible(
    list(
      subj = subj,
      subj_dir = subj_root_dir,
      types = type_names
    )
  )
}
