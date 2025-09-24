#' Freesurfer Reconstruction Pipeline for All Processing Steps
#'
#' This function is a streamlined interface to Freesurfer's
#' `recon-all` command, designed to perform full MRI processing and cortical
#' reconstruction workflow. It executes all processing steps, including motion
#' correction, skull stripping, intensity normalization, cortical and subcortical
#' segmentation, and generating cortical surfaces. Customization is possible
#' through additional arguments passed to \code{\link{reconner}}.
#'
#' @details This function acts as a wrapper for the Freesurfer `recon-all`
#' command, handling preprocessing, segmentation, and cortical surface analysis
#' in a single pipeline. Users can specify inputs, outputs, and additional
#' options to adjust the behavior of the pipeline. It provides an easy way
#' to restart a reconstruction by modifying the `opts` parameter, giving
#' users flexibility for iterative processing.
#'
#' @template subjid
#' @param infile A character string specifying the input filename, which must
#' be in DICOM (`.dcm`) or NIfTI (`.nii`) format.
#' @param outdir An optional character string specifying the output directory.
#' If provided, the results of the pipeline will be saved to this directory.
#' @template opts
#' @param ... Additional arguments passed to \code{\link{reconner}}, which
#' handles execution of the reconstruction pipeline with customizable options
#' for individual steps.
#'
#' @note To restart or refine a prior reconstruction, modify the `opts` parameter,
#' e.g., use `opts = "-make all"` to initiate the pipeline from an intermediate step.
#'
#' @return The result of executing the Freesurfer command via \code{\link{system}}.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Full reconstruction pipeline with default options
#' recon_all(
#'   infile = "subject.nii",
#'   subjid = "subject01",
#'   outdir = "output_dir"
#' )
#'
#' # Restart pipeline processing from existing data
#' recon_all(
#'   infile = "subject.nii",
#'   subjid = "subject01",
#'   opts = "-make all",
#'   verbose = TRUE
#' )
#' }
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


#' @title Reconstruction from Freesurfer
#'
#' @description Performs a reconstruction pipeline using Freesurfer. This
#' function enables precise customization of the reconstruction process
#' through a unified `options` argument, simplifying control over the
#' various stages of processing.
#'
#' @details The function provides an interface to Freesurfer's
#' reconstruction tools, allowing users to process input MRI files,
#' correct motion artifacts, perform cortical and subcortical segmentation,
#' generate 3D cortical surfaces, and apply various transformations and
#' labelings. Each process can be activated or skipped using the `options`
#' parameter, which controls specific steps in the pipeline.
#'
#' @param infile A string specifying the input filename, which must be
#' either a DICOM file (`.dcm`) or a NIfTI file (`.nii`).
#' @param subjid A string specifying the subject identifier. If left
#' `NULL`, it will be derived from the input filename.
#' @param outdir An optional string specifying the output directory. If
#' provided, the results will be saved to this location.
#' @param verbose A logical value controlling verbose output of the
#' reconstruction command. Defaults to the setting from
#' \code{\link{get_fs_verbosity}}.
#' @param opts Additional optional arguments passed to the Freesurfer
#' reconstruction command as a string.
#' @param options A named list of logical values specifying which
#' steps to include in the pipeline. Each option corresponds to a
#' specific stage in the Freesurfer processing workflow. Defaults
#' to enabling all options (`TRUE`). The possible options are:
#'
#' \itemize{
#'   \item \code{motioncor}: Corrects small motions between multiple source
#'   volumes and averages them. Input: volumes in `mri/orig/`. Output:
#'   `mri/orig.mgz`.
#'   \item \code{nuintensitycor}: Applies Non-parametric Non-uniform intensity
#'   Normalization (N3) to correct MR intensity non-uniformity.
#'   \item \code{talairach}: Computes an affine transform to the MNI305 atlas,
#'   outputting the files `mri/transform/talairach.auto.xfm` and
#'   `talairach.xfm`.
#'   \item \code{normalization}: Performs intensity normalization of the orig
#'   volume, storing the result at `mri/T1.mgz`.
#'   \item \code{skullstrip}: Removes the skull from the normalized T1 volume
#'   and stores the result as `mri/brainmask.auto.mgz` and `mri/brainmask.mgz`.
#'   \item \code{gcareg}: Computes a transform to align the `mri/nu.mgz` volume
#'   with the General Cortical Atlas (GCA).
#'   \item \code{canorm}: Performs further normalization based on the GCA
#'   model, outputting the file `mri/norm.mgz`.
#'   \item \code{careg}: Computes a nonlinear transform to align with the GCA
#'   atlas, producing `mri/transform/talairach.m3z`.
#'   \item \code{rmneck}: Removes the neck region from the NU-corrected volume,
#'   saving it as `mri/nu_noneck.mgz`.
#'   \item \code{skull-lta}: Computes a transform to include the skull in the
#'   alignment process, generating
#'   `mri/transforms/talairach_with_skull.lta`.
#'   \item \code{calabel}: Labels subcortical structures, outputting
#'   `mri/aseg.auto.mgz` and `mri/aseg.mgz`.
#'   \item \code{normalization2}: Applies another normalization step using the
#'   brain-only volume, creating `brain.mgz`.
#'   \item \code{segmentation}: Segments white matter, stores the output in
#'   `mri/wm.mgz`, and optionally skips using `aseg.mgz` if the `-noaseg` flag
#'   is applied.
#'   \item \code{fill}: Prepares a subcortical mass, creating the direct input
#'   for cortical tessellation. Produces `mri/filled.mgz`.
#'   \item \code{tessellate}: Generates an initial tessellated cortical
#'   surface. Output: `surf/?h.orig.nofix`.
#'   \item \code{smooth1}: Runs the first smoothing process post-tessellation.
#'   \item \code{inflate1}: Inflates the smooth surface for better topology
#'   analysis. Output: `surf/?h.inflated`.
#'   \item \code{qsphere}: Identifies topological defects with a quasi-spherical
#'   transformation, outputting `surf/?h.qsphere.nofix`.
#'   \item \code{fix}: Fixes topological defects, updating `surf/?h.orig.nofix`
#'   to create `surf/?h.orig`.
#'   \item \code{finalsurfs}: Generates pial and white surfaces (`?h.pial` and
#'   `?h.white`), and computes cortical thickness and curvature.
#'   \item \code{smooth2}: Runs the second smoothing process post-topology
#'   fixing.
#'   \item \code{inflate2}: Further refines the inflated surface post-fixing.
#'   \item \code{cortribbon}: Creates binary volume masks for the cortical
#'   ribbon saved as `?h.ribbon.mgz`.
#'   \item \code{sphere}: Inflates the surface into a sphere while minimizing
#'   distortion, required for registration to the spherical atlas.
#'   \item \code{surfreg}: Registers the cortical surface to a spherical atlas
#'   based on folding patterns.
#'   \item \code{contrasurfreg}: Registers to the contralateral atlas, creating
#'   `lh.rh.sphere.reg` and `rh.lh.sphere.reg`.
#'   \item \code{avgcurv}: Resamples average curvature from the atlas, enabling
#'   group-level visualization.
#'   \item \code{cortparc}: Assigns neuroanatomical labels to the cortical
#'   surface, creating annotation files like `?h.aparc.annot`.
#'   \item \code{parcstats}: Computes summary statistics for cortical
#'   parcellation, outputting files such as `stats/?h.aparc.stats`.
#'   \item \code{cortparc2}: Generates annotation files with alternative
#'   parcellation schemes.
#'   \item \code{parcstats2}: Computes statistics for the alternative
#'   parcellations, outputting statistics like `stats/?h.aparc.a2005s.stats`.
#'   \item \code{aparc2aseg}: Maps cortical parcellation labels to the segmentation
#'   volume. Produces a modified `aseg` volume.
#' }
#'
#' @return The result of executing the Freesurfer command via \code{\link{system}}.
#' @export
#'
#' @examples
#' \dontrun{
#' # Basic usage with all steps enabled
#' recon(
#'   infile = "subject.nii",
#'   subjid = "subject01",
#'   outdir = "output_dir"
#' )
#'
#' # Custom pipeline disabling certain steps
#' recon(
#'   infile = "subject.nii",
#'   subjid = "subject01",
#'   options = list(
#'     motioncor = TRUE,
#'     nuintensitycor = TRUE,
#'     talairach = FALSE, # Skip Talairach alignment
#'     skullstrip = TRUE
#'   )
#' )
#'
#' # Adding verbose output
#' recon(
#'   infile = "subject.nii",
#'   subjid = "subject01",
#'   verbose = TRUE
#' )
#'
#' # Example with custom options
#' custom_steps <- recon_steps()
#' #' # Disable normalization step
#' custom_steps["normalization"] <- FALSE
#'
#' recon(
#'   infile = "subject.nii",
#'   subjid = "subject01",
#'   options = custom_steps
#' )
#' }
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


#' Reconstruction Steps for Neuroimaging Analysis
#'
#' This function generates a named vector of logical flags
#' corresponding to the steps involved in a neuroimaging processing
#' pipeline. The function is designed to facilitate the control and
#' customization of individual steps in processes such as brain image
#' reconstruction (e.g., as used in the [FreeSurfer](https://surfer.nmr.mgh.harvard.edu/)
#' software suite). Each step in the pipeline is associated with a
#' logical value (`TRUE`), indicating whether it is included as a default
#' part of the pipeline.
#'
#' @return
#' A named logical vector, where each name represents a reconstruction
#' step (e.g., "motioncor", "talairach"), and the corresponding value
#' (`TRUE`) indicates that the step is included in the standard pipeline.
#'
#' @details
#' Below is a description of the primary steps represented in the
#' returned vector:
#' - **motioncor**: Motion correction of images.
#' - **nuintensitycor**: Non-uniform intensity correction.
#' - **talairach**: Transformation to Talairach space.
#' - **normalization**: Normalization of brain image intensity levels.
#' - **skullstrip**: Skull stripping for isolating the brain region.
#' - **gcareg & canorm**: General and cortical surface alignment and normalization.
#' - **rmneck**: Removal of the neck region from the dataset.
#' - **skull-lta**: Linear transformation for skull registration.
#' - **calabel**: Surface labeling with anatomical structures.
#' - **normalization2**: Secondary normalization step.
#' - **segmentation**: Segmentation of brain regions.
#' - **fill**: Surface filling for better reconstruction.
#' - **tessellate**: Creation of a tessellated mesh for surface modeling.
#' - **inflate1 & inflate2**: Inflation of surface meshes for curvature evaluation.
#' - **smooth1 & smooth2**: Smoothing of the surface meshes.
#' - **qsphere & sphere**: Generation of spherical surface representations.
#' - **surfreg & contrasurfreg**: Surface registration processes.
#' - **finalsurfs**: Construction of final brain surface models.
#' - **avgcurv**: Calculation of average cortical curvature.
#' - **cortparc & cortparc2**: Cortical parcellation into anatomical regions.
#' - **parcstats & parcstats2**: Summarization of parcellation statistics.
#' - **aparc2aseg**: Label projection from parcellations to a volume segmentation.
#'
#' This logical vector can be directly used for toggling reconstruction
#' steps during neuroimaging workflows. Users may modify or customize
#' this output as needed for specific applications.
#'
#' @examples
#' # Get a vector of reconstruction steps
#' steps <- recon_steps()
#'
#' # Check the default inclusion of the 'motioncor' step
#' steps["motioncor"]  # Output: TRUE
#'
#' # Modify a specific reconstruction step (e.g., skip 'normalization')
#' steps["normalization"] <- FALSE
#'
#' print(steps)
#'
#' # Use the modified steps in a downstream neuroimaging script
#'
#'
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
