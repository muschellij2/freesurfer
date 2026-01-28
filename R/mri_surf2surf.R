#' Resample Cortical Surface Data with FreeSurfer
#'
#' @description
#' Calls FreeSurfer's `mri_surf2surf` to resample one cortical surface onto
#' another, enabling comparison of surface data across subjects or atlases.
#'
#' @details
#' This function is commonly used to:
#' * Project individual subject data onto a template (e.g., fsaverage)
#' * Resample between different surface resolutions
#' * Convert between surface file formats
#'
#' The output filename is automatically prefixed with the hemisphere
#' (e.g., "lh.output.mgz").
#'
#' @param subject Character; source subject name.
#' @param target_subject Character; target subject name (e.g., "fsaverage").
#' @param trg_type Character; target file type. One of "curv", "w" (paint),
#'   "mgh", or "nii".
#' @param src_type Character; source file type. One of "curv" or "w" (paint).
#' @param outfile Character; output filename. If NULL, a temporary file is
#'   created.
#' @param hemi Character; hemisphere. One of "lh" or "rh".
#' @param sval Character; source value/measure (e.g., "thickness").
#' @template subj_dir
#' @template opts
#' @template verbose
#' @param ... Additional arguments passed to [base::system()].
#'
#' @return Character; path to the output file (prefixed with hemisphere).
#'
#' @seealso [fs_help()] for FreeSurfer command documentation
#'
#' @export
#' @examplesIf have_fs()
#' \dontrun{
#' out <- mri_surf2surf(
#'   subject = "bert",
#'   target_subject = "fsaverage",
#'   trg_type = "curv",
#'   src_type = "curv",
#'   hemi = "rh",
#'   sval = "thickness"
#' )
#' }
mri_surf2surf <- function(
  subject = NULL,
  target_subject = NULL,
  trg_type = c("curv", "w", "mgh", "nii"),
  src_type = c("curv", "w"),
  outfile = NULL,
  hemi = c("lh", "rh"),
  sval = c("thickness"),
  subj_dir = NULL,
  opts = "",
  verbose = get_fs_verbosity(),
  ...
) {
  validate_fs_env(check_license = FALSE)

  hemi <- match.arg(hemi)
  trg_type <- match.arg(trg_type)
  src_type <- match.arg(src_type)
  sval <- match.arg(sval)

  if (is.null(outfile)) {
    outfile <- temp_file()
  }
  outfile_final <- file.path(
    dirname(outfile),
    paste0(hemi, ".", basename(outfile))
  )

  cmd_args <- c(
    paste("--hemi", hemi),
    paste("--s", subject),
    paste("--trgsubject", target_subject),
    paste("--trg_type", trg_type),
    paste("--sval", sval),
    paste("--src_type", src_type),
    paste("--tval", outfile),
    if (verbose) "--debug"
  )

  subdir_prefix <- ""
  if (!is.null(subj_dir)) {
    subj_dir <- path.expand(subj_dir)
    subdir_prefix <- sprintf("export SUBJECTS_DIR=%s; ", subj_dir)
  }

  cmd <- paste(
    subdir_prefix,
    get_fs(),
    "mri_surf2surf",
    paste(cmd_args, collapse = " "),
    opts
  )

  run_check_fs_cmd(
    cmd = cmd,
    outfile = outfile_final,
    verbose = verbose,
    func_name = "mri_surf2surf",
    ...
  )

  outfile_final
}


#' @describeIn mri_surf2surf Display FreeSurfer help for mri_surf2surf
#' @param ... Additional arguments passed to [fs_help()]
#' @export
mri_surf2surf.help <- function(...) {
  fs_help("mri_surf2surf", ...)
}
