#' Read FreeSurfer Anatomical Segmentation Statistics
#'
#' @description
#' Reads and parses an `aseg.stats` file produced by FreeSurfer's anatomical
#' segmentation pipeline. Returns both global brain measures and structure-
#' specific statistics.
#'
#' @details
#' The `aseg.stats` file contains volumetric and morphometric statistics for
#' subcortical structures and global brain measures computed by FreeSurfer's
#' `recon-all` pipeline.
#'
#' ## Output Structure
#' The function returns a list with two data frames:
#'
#' **measures**: Global brain measures including:
#' * Brain segmentation volume
#' * Estimated total intracranial volume (eTIV)
#' * Normalization factors
#'
#' **structures**: Structure-specific measures including:
#' * Structure index and name
#' * Number of voxels
#' * Volume (mm³)
#' * Mean intensity and standard deviation
#' * Minimum, maximum, and range of intensities
#'
#' ## File Location
#' For a subject processed with `recon-all`, the file is typically located at:
#' `$SUBJECTS_DIR/<subject_id>/stats/aseg.stats`
#'
#' @param file Character; path to an `aseg.stats` file from FreeSurfer.
#' @param lowercase Logical; if `TRUE` (default), converts measure names and
#'   column names to lowercase for easier access. If `FALSE`, preserves
#'   FreeSurfer's original capitalization.
#'
#' @return
#' A list with two components:
#' * `measures`: A data frame with global brain measures, with columns:
#'   - `measure`: Short name of the measure
#'   - `measure_long`: Long descriptive name
#'   - `meaning`: Description of what the measure represents
#'   - `value`: Numeric value of the measure
#'   - `units`: Units of measurement
#' * `structures`: A data frame with structure-specific statistics, with columns:
#'   - `Index`: Structure index
#'   - `SegId`: Segmentation ID
#'   - `NVoxels`: Number of voxels
#'   - `Volume_mm3`: Volume in cubic millimeters
#'   - `StructName`: Name of the anatomical structure
#'   - `normMean`: Normalized mean intensity
#'   - `normStdDev`: Normalized standard deviation
#'   - `normMin`: Normalized minimum
#'   - `normMax`: Normalized maximum
#'   - `normRange`: Normalized range
#'
#' @export
#'
#' @seealso
#' * [read_fs_table()] for reading other FreeSurfer tables
#' * [recon_all()] for running the FreeSurfer pipeline
#' * [stats2table()] for combining stats from multiple subjects
#'
#' @examplesIf have_fs()
#' # Read stats for the "bert" example subject
#' file <- file.path(fs_subj_dir(), "bert", "stats", "aseg.stats")
#'
#' if (file.exists(file)) {
#'   out <- read_aseg_stats(file)
#'
#'   # Examine global measures
#'   print(head(out$measures))
#'
#'   # Get estimated total intracranial volume
#'   etiv <- out$measures$value[out$measures$measure == "estimatedtotalintracranialvol"]
#'   cat("eTIV:", etiv, "mm³\n")
#'
#'   # Examine structure-specific stats
#'   print(head(out$structures))
#'
#'   # Get hippocampal volumes
#'   hippo <- out$structures[grepl("Hippocampus", out$structures$StructName), ]
#'   print(hippo[, c("StructName", "Volume_mm3")])
#' }
read_aseg_stats <- function(file, lowercase = TRUE) {
  check_path(file)
  rl <- readLines(file)
  start_subj <- grep("^# subjectname", rl)
  n_rl <- length(rl)
  rl <- rl[seq(start_subj, n_rl)]

  ###############################################
  # Parse the measures table
  ###############################################
  meas <- rl[grep("^# Measure", rl)]

  vals <- strsplit(meas, ",")
  vals <- lapply(vals, trimws)
  vals <- sapply(vals, function(x) {
    x <- gsub("^# Measure", "", x)
    x <- trimws(x)
    if (lowercase) {
      x <- tolower(x)
    }
    x
  })
  vals <- t(vals)
  vals <- as.data.frame(vals, stringsAsFactors = FALSE)
  colnames(vals) <- c("measure", "measure_long", "meaning", "value", "units")

  ###############################################
  # Read in the structure-level table
  ###############################################
  start_subj <- grep("^# ColHeaders", rl)
  n_rl <- length(rl)
  rl <- rl[seq(start_subj, n_rl)]
  hdr <- rl[1]
  hdr <- gsub("^# ColHeaders", "", hdr)
  hdr <- trimws(hdr)
  hdr <- gsub("\\s+", " ", hdr)
  hdr <- strsplit(hdr, " ")[[1]]

  tab <- rl[-1]
  tab <- trimws(tab)
  tab <- gsub("\\s+", " ", tab)
  tab <- strsplit(tab, " ")
  tab <- do.call("rbind", tab)

  tab <- data.frame(tab, stringsAsFactors = FALSE)
  colnames(tab) <- hdr

  num_cols <- setdiff(hdr, "StructName")
  for (icol in num_cols) {
    tab[, icol] <- as.numeric(tab[, icol])
  }

  list(measures = vals, structures = tab)
  # out = surf_convert(file)
  # read_stats = function(file) {
}
