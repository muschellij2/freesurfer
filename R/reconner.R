#' Reconstruction Helper for FreeSurfer's recon-all
#'
#' @description
#' Wrapper around FreeSurfer's `recon-all` command for brain surface
#' reconstruction from MRI data. Handles input processing, subject directory
#' creation, and command flag management.
#'
#' @details
#' FreeSurfer's `recon-all` performs cortical reconstruction and volumetric
#' segmentation. This function simplifies usage by:
#' * Automatically deriving subject ID from input filename if not provided
#' * Managing subject directory paths
#' * Providing force option for re-running on existing subjects
#'
#' @template subjid
#' @param infile Character; path to input file in DICOM or NIfTI format.
#' @template outdir
#' @template verbose
#' @template opts
#' @param force Logical; force execution even if subject directory exists.
#'   Default is `FALSE`.
#'
#' @return Result of [base::system()] call, typically exit status (0 = success).
#'
#' @seealso [tracker()] for diffusion tractography pipeline
#'
#' @examplesIf have_fs()
#' \dontrun{
#' reconner(infile = "input.nii", outdir = "/output_dir", subjid = "subj01")
#' reconner(infile = "input.nii", outdir = "/output_dir")
#' reconner(infile = "input.nii", opts = "-autorecon2", force = TRUE)
#' }
#'
#' @importFrom tools file_path_sans_ext
#' @importFrom neurobase nii.stub
#' @export
reconner <- function(
  subjid = NULL,
  infile = NULL,
  outdir = NULL,
  opts = "-all",
  force = FALSE,
  verbose = get_fs_verbosity()
) {
  validate_fs_env(check_license = FALSE)

  if (is.null(subjid) && is.null(infile)) {
    cli::cli_abort("Either {.arg subjid} or {.arg infile} must be specified!")
  }

  if (!is.null(infile)) {
    check_path(infile)
    infile <- checknii(infile)
  }

  if (is.null(subjid)) {
    subjid <- gsub("[.]mg(z|h)$", "", infile)
    subjid <- nii.stub(subjid, bn = TRUE)
    subjid <- file_path_sans_ext(subjid)
    if (verbose) {
      cli::cli_alert_info("Subject set to: {.val {subjid}}")
    }
  }

  subject_directory <- if (!is.null(outdir)) {
    file.path(outdir, subjid)
  } else {
    file.path(fs_subj_dir(), subjid)
  }

  if (!is.null(infile) && dir.exists(subject_directory)) {
    fs_warn(
      "Subject Directory {.path {subject_directory}} already exists",
      details = "Use {.code force = TRUE} or delete directory"
    )
  }

  cmd_args <- c(
    paste("-subjid", subjid),
    if (!is.null(outdir)) paste("-sd", shQuote(outdir)),
    if (!is.null(infile)) paste("-i", infile),
    if (force) "-force",
    opts
  )

  cmd <- paste(
    get_fs(),
    "recon-all",
    paste(cmd_args, collapse = " ")
  )

  if (verbose) {
    cli::cli_code(cmd)
  }

  try_fs_cmd(cmd, context = "recon-all")
}
