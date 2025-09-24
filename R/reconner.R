#' Reconstruction Helper for Freesurfer's `recon-all`
#'
#' This function is a wrapper around Freesurfer's `recon-all` command used
#' for reconstructing brain surfaces or handling input files (DICOM or NIfTI
#' format) for medical image analysis. It provides convenient interfaces
#' for specifying input/output paths, subject IDs, custom options, and
#' additional flags.
#'
#' @section Overview:
#' Freesurfer’s `recon-all` is a robust tool for brain image processing,
#' including cortical reconstruction and segmentation. The `reconner` function
#' simplifies its usage by automating subject directory creation, flag handling,
#' and input processing.
#'
#' @param infile Input filename (DICOM or NIfTI format). If `NULL`, the `-i` flag
#' will be omitted from the command.
#' @param outdir Output directory where reconstruction results will be stored.
#' If `NULL`, Freesurfer's default subject directory (`fs_subj_dir`) will
#' be used.
#' @param subjid Subject ID used to name the reconstructed directory. If `NULL`,
#' it is auto-generated from the filename.
#' @param opts Additional options for `recon-all`. Default is `"-all"`, which
#' runs all available reconstruction steps. You can include other flags or
#' custom options.
#' @param force Logical flag to force execution of `recon-all`, even if the
#' subject directory already exists. Default is `FALSE`.
#' @param verbose Logical flag controlling verbosity of logs and command-line
#' outputs.
#'
#' @return Returns the result of executing the `recon-all`.
#'
#' @examples
#' \dontrun{
#' # Example 1: Run reconstruction with infile and default opts
#' reconner(infile = "input_01.nii", outdir = "/output_dir", subjid = "subj01")
#'
#' # Example 2: Auto-generate subject ID from input file
#' reconner(infile = "input_02.nii", outdir = "/output_dir")
#'
#' # Example 3: Run with custom options and force execution
#' reconner(infile = "input_03.nii", opts = "-autorecon2", force = TRUE)
#'
#' # Example 4: Run reconstruction in default subject directory
#' reconner(infile = "input_04.nii", subjid = "subj04")
#'
#' # Example 5: Run without verbosity
#' reconner(infile = "input_05.nii", verbose = FALSE)
#' }
#'
#' @importFrom tools file_path_sans_ext
#' @export
reconner <- function(
  subjid = NULL,
  infile = NULL,
  outdir = NULL,
  opts = "-all",
  force = FALSE,
  verbose = get_fs_verbosity()
) {
  if (is.null(subjid) && is.null(infile)) {
    cli::cli_abort("Either {.val subjid} or {.val infile} must be specified!")
  }
  if (!is.null(infile)) {
    check_path(infile)
    infile = checknii(infile)
  }

  cmd <- paste0(get_fs(), "recon-all")
  subject_directory = file.path(fs_subj_dir(), subjid)

  if (is.null(subjid)) {
    subjid = gsub("[.]mg(z|h)$", "", infile)
    subjid = nii.stub(subjid, bn = TRUE)
    subjid = file_path_sans_ext(subjid)
    if (verbose) {
      cli::cli_alert_info("Subject set to: {.val {subjid}}")
    }
    cmd <- c(cmd, paste(" -subjid", subjid))
  }

  if (!is.null(outdir)) {
    cmd <- c(cmd, paste(" -sd", shQuote(outdir)))
    subject_directory = file.path(outdir, subjid)
  }

  if (!is.null(infile)) {
    cmd <- c(cmd, paste("-i", infile))
    if (dir.exists(subject_directory)) {
      fs_warn(
        "Subject Directory {.path subject_directory} already exists - 
        either use {.code force = TRUE}, or delete directory"
      )
    }
  }

  if (force) {
    cmd <- c(cmd, "-force")
  }

  cmd <- paste(c(cmd, opts), collapse = " ")

  if (verbose) {
    cli::cli_code(cmd)
  }
  try_fs_cmd(cmd)
}
