#' FreeSurfer Reconstruction Pipeline Functions
#'
#' @description
#' Functions to run FreeSurfer's cortical reconstruction pipeline with varying
#' levels of control and customization.
#'
#' @details
#' ## Pipeline Overview
#' The reconstruction pipeline performs:
#' 1. Motion correction and intensity normalization
#' 2. Skull stripping and subcortical segmentation
#' 3. White matter segmentation
#' 4. Surface generation (white and pial)
#' 5. Cortical parcellation and thickness calculation
#'
#' ## Processing Time
#' A full reconstruction typically takes 6-24 hours. Use `opts = "-parallel"`
#' for parallel processing if available.
#'
#' ## Output Location
#' Results stored in `$SUBJECTS_DIR/<subjid>/` with subdirectories:
#' `mri/`, `surf/`, `label/`, `stats/`
#'
#' @param options Named list of logical values for [recon()], specifying which
#'   pipeline steps to include. See [recon_steps()] for available options.
#' @inheritParams reconner
#' @param ... Additional arguments passed to [reconner()].
#'
#' @return
#' Result from [base::system()] call, typically exit status (0 = success).
#'
#' @seealso
#' [read_aseg_stats()] to read segmentation statistics
#' [reconner()] for low-level control of `recon-all`
#'
#' @name recon
#' @examplesIf have_fs()
#' \dontrun{
#' # Full reconstruction with recon_all
#' recon_all(
#'   infile = "T1_scan.nii",
#'   subjid = "subject01",
#'   outdir = "~/freesurfer_output"
#' )
#'
#' # Step-by-step control with recon
#' steps <- recon_steps()
#' steps["normalization"] <- FALSE
#' recon(
#'   infile = "T1_scan.nii",
#'   subjid = "subject02",
#'   options = steps
#' )
#'
#' # Low-level control with reconner
#' reconner(
#'   infile = "T1_scan.nii",
#'   subjid = "subject03",
#'   opts = "-autorecon1 -parallel"
#' )
#' }
#'
#' @references
#' Dale et al. (1999) Neuroimage 9:179-194.
#' Fischl et al. (1999) Neuroimage 9:195-207.
NULL

#' @describeIn recon Run complete reconstruction pipeline with default settings
#' @export
recon_all <- function(
  subjid = NULL,
  infile = NULL,
  outdir = NULL,
  verbose = get_fs_verbosity(),
  opts = "-all",
  ...
) {
  reconner(
    infile = infile,
    outdir = outdir,
    subjid = subjid,
    verbose = verbose,
    opts = opts,
    ...
  )
}

#' @describeIn recon Run reconstruction with step-by-step control
#' @export
recon <- function(
  subjid = NULL,
  infile = NULL,
  outdir = NULL,
  opts = "",
  options = recon_steps(),
  verbose = get_fs_verbosity()
) {
  # Parse options
  args <- paste0(
    ifelse(options, "-", "-no"),
    names(options),
    collapse = " "
  )

  # Handle output directory
  sd_opts <- if (!is.null(outdir)) paste0(" -sd ", shQuote(outdir)) else NULL

  reconner(
    infile = infile,
    outdir = outdir,
    subjid = subjid,
    opts = paste(sd_opts, opts),
    force = FALSE,
    verbose = verbose
  )
}

#' @describeIn recon Get named vector of available reconstruction steps
#' @export
recon_steps <- function() {
  c(
    motioncor = TRUE,
    nuintensitycor = TRUE,
    talairach = TRUE,
    normalization = TRUE,
    skullstrip = TRUE,
    gcareg = TRUE,
    canorm = TRUE,
    careg = TRUE,
    rmneck = TRUE,
    "skull-lta" = TRUE,
    calabel = TRUE,
    normalization2 = TRUE,
    segmentation = TRUE,
    fill = TRUE,
    tessellate = TRUE,
    smooth1 = TRUE,
    inflate1 = TRUE,
    qsphere = TRUE,
    fix = TRUE,
    finalsurfs = TRUE,
    smooth2 = TRUE,
    inflate2 = TRUE,
    cortribbon = TRUE,
    sphere = TRUE,
    surfreg = TRUE,
    contrasurfreg = TRUE,
    avgcurv = TRUE,
    cortparc = TRUE,
    parcstats = TRUE,
    cortparc2 = TRUE,
    parcstats2 = TRUE,
    aparc2aseg = TRUE
  )
}
