#' FreeSurfer Diffusion Tractography Pipeline
#'
#' @description
#' These functions provide wrappers for FreeSurfer's `trac-all` command,
#' which performs automated reconstruction of diffusion pathways.
#'
#' @details
#' All functions call the same underlying FreeSurfer `trac-all` command with
#' different option flags.
#'
#' @param infile Character; input DWI (diffusion-weighted imaging) filename
#'   in DICOM or NIfTI format. Required for initial processing.
#' @template outdir
#' @template subjid
#' @template verbose
#' @template opts
#' @param display Logical; whether to display help output
#' @param warn Logical; whether to warn if help is not available
#' @param ... Additional arguments passed to [fs_help()]
#'
#' @return Result of [base::system()] call, typically exit status (0 = success).
#'
#' @seealso
#' [recon_all()] for structural reconstruction pipeline
#'
#' @name trac
#'
#' @examplesIf have_fs()
#' \dontrun{
#' # Run full tractography pipeline
#' trac_all(
#'   infile = "dwi.nii",
#'   subjid = "subject01",
#'   outdir = "~/tractography_output"
#' )
#'
#' # Run step-by-step
#' trac_prep(infile = "dwi.nii", subjid = "subject02")
#' trac_bedpost(infile = "dwi.nii", subjid = "subject02")
#' trac_path(infile = "dwi.nii", subjid = "subject02")
#'
#' # Run with custom options
#' tracker(
#'   infile = "dwi.nii",
#'   subjid = "subject03",
#'   opts = "-prep -bedp"
#' )
#' }
NULL

#' @describeIn trac Low-level wrapper for trac-all command with custom options
#' @export
tracker <- function(
  infile = NULL,
  outdir = NULL,
  subjid = NULL,
  verbose = get_fs_verbosity(),
  opts = ""
) {
  # Validate inputs
  if (is.null(subjid) && is.null(infile)) {
    fs_abort("Either {.arg subjid} or {.arg infile} must be specified")
  }

  # Derive subject ID from filename if needed
  if (is.null(subjid) && !is.null(infile)) {
    subjid <- nii.stub(infile, bn = TRUE)
    subjid <- file_path_sans_ext(subjid)
    if (verbose) {
      cli::cli_alert_info("Subject ID set to: {.val {subjid}}")
    }
  }

  # Build input options
  if (!is.null(infile)) {
    infile <- checknii(infile)
    in_opts <- paste0("-i ", shQuote(infile))
  } else {
    in_opts <- ""
  }

  # Build subject directory options
  if (!is.null(outdir)) {
    sd_opts <- paste0("-sd ", shQuote(outdir))
  } else {
    sd_opts <- ""
  }

  # Combine all options
  opts <- paste(
    in_opts,
    sd_opts,
    paste0("-s ", subjid),
    opts
  )

  # Build and execute command
  cmd <- get_fs()
  cmd <- paste0(cmd, "trac-all")
  cmd <- paste(cmd, opts)

  if (verbose) {
    cli::cli_code(cmd)
  }

  try_fs_cmd(cmd)
}

#' @describeIn trac High-level wrapper running complete tractography pipeline
#' @export
trac_all <- function(
  infile = NULL,
  outdir = NULL,
  subjid = NULL,
  verbose = get_fs_verbosity(),
  opts = ""
) {
  tracker(
    infile = infile,
    outdir = outdir,
    subjid = subjid,
    verbose = verbose,
    opts = opts
  )
}

#' @describeIn trac Run pre-processing step (step 1: image corrections, registration)
#' @export
trac_prep <- function(
  infile,
  outdir = NULL,
  subjid,
  verbose = get_fs_verbosity()
) {
  tracker(
    infile = infile,
    outdir = outdir,
    subjid = subjid,
    verbose = verbose,
    opts = "-prep"
  )
}

#' @describeIn trac Run bedpost step (step 2: ball-and-stick model fitting)
#' @export
trac_bedpost <- function(
  infile,
  outdir = NULL,
  subjid,
  verbose = get_fs_verbosity()
) {
  tracker(
    infile = infile,
    outdir = outdir,
    subjid = subjid,
    verbose = verbose,
    opts = "-bedp"
  )
}

#' @describeIn trac Run pathway reconstruction step (step 3: probabilistic tractography)
#' @export
trac_path <- function(
  infile,
  outdir = NULL,
  subjid,
  verbose = get_fs_verbosity()
) {
  tracker(
    infile = infile,
    outdir = outdir,
    subjid = subjid,
    verbose = verbose,
    opts = "-path"
  )
}

#' @describeIn trac Display FreeSurfer help for trac-all
#' @export
tracker.help <- function(...) {
  fs_help(
    "trac-all",
    ...
  )
}
