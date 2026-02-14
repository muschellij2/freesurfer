#' Generalized Stats to Table
#'
#' This function serves as a flexible abstraction to execute the FreeSurfer
#' commands `asegstats2table` or `aparcstats2table`, which are primarily
#' used to convert parcellation and segmentation statistics to tabular
#' formats. The function dynamically handles shared logic, constructs
#' command-line arguments, and runs the appropriate FreeSurfer command.
#' Users can specify the type of input (subjects or input file paths)
#' and various configuration options. With the appropriate parameters,
#' it constructs and executes the matching system command.
#'
#' @param type (character) Either "aparc" for cortical parcellation or
#'   "aseg" for subcortical segmentation.
#' @param input (character) A vector representing either subject IDs
#'   (for `input_type = "subjects"`) or file paths
#'   (for `input_type = "inputs"`, applicable only to `aseg`).
#' @param input_type (character) Specifies the type of `input`. Must be
#'   one of "subjects" or "inputs".
#' @param outfile (character) Name of the output file. If not specified,
#'   a temporary file will be created based on the specified delimiter.
#' @param measure (character) The measurement to calculate. For example,
#'   "thickness" for cortical measures or "volume" for subcortical.
#' @param delim (character) Delimiter for the output file. This can be one
#'   of: "tab", "space", "comma", or "semicolon". The output file's
#'   delimiter is stored as an attribute for programmatic access.
#' @param skip (logical) If `TRUE`, skips invalid inputs (e.g., missing
#'   files or data) without throwing errors.
#' @param ... Additional arguments passed to the internal function.
#'   These might include extra FreeSurfer
#'   flags or configurations.
#' @template subj_dir
#' @template opts
#' @template verbose
#' @return A character string: the path to the output file with its
#'   delimiter stored as an attribute.
#' @examplesIf have_fs()
#' \dontrun{
#' # Example for asegstats2table
#' outfile_aseg <- asegstats2table(
#'     subjects = "bert",
#'     measure = "mean",
#'     delim = "tab"
#' )
#' print(outfile_aseg)
#'
#' # Example for aparcstats2table
#' outfile_aparc <- aparcstats2table(
#'   subjects = "bert",
#'   hemi = "lh",
#'   measure = "thickness",
#'   delim = "tab",
#'   opts = "--etiv --scale=1.0"
#' )
#' print(outfile_aparc)
#' }
#'
#' @export
stats2table <- function(
  type = c("aseg", "aparc"),
  input,
  measure,
  input_type = c("subjects", "inputs"),
  outfile = NULL,
  delim = c("tab", "space", "comma", "semicolon"),
  skip = TRUE,
  subj_dir = NULL,
  opts = "",
  verbose = get_fs_verbosity(),
  ...
) {
  validate_fs_env(check_license = FALSE)

  if (is.null(input) || length(input) == 0) {
    cli::cli_abort("'input' must be specified and cannot be empty.")
  }

  type <- match.arg(type)
  input_type <- match.arg(input_type)
  delim <- match.arg(delim)

  delimiter_map <- list(
    tab = list(ext = ".tsv", delim = "\t"),
    space = list(ext = ".txt", delim = " "),
    comma = list(ext = ".csv", delim = ","),
    semicolon = list(ext = ".csv", delim = ";")
  )
  delim_values <- delimiter_map[[delim]]

  if (is.null(outfile)) {
    outfile <- temp_file(fileext = delim_values$ext)
  }

  func_name <- paste0(type, "stats2table")

  cmd_args <- c(
    sprintf("--%s %s", input_type, paste(input, collapse = " ")),
    paste("--delimiter", delim),
    paste("--meas", measure),
    if (verbose) "--debug",
    if (skip) "--skip",
    paste("--tablefile", outfile)
  )

  subdir_prefix <- ""
  if (!is.null(subj_dir)) {
    subj_dir <- path.expand(subj_dir)
    subdir_prefix <- sprintf("export SUBJECTS_DIR=%s; ", subj_dir)
  }

  cmd <- paste(
    subdir_prefix,
    get_fs(),
    func_name,
    paste(cmd_args, collapse = " "),
    opts
  )

  run_check_fs_cmd(
    cmd = cmd,
    outfile = outfile,
    verbose = verbose,
    func_name = func_name,
    ...
  )

  attr(outfile, "delimiter") <- delim_values$delim
  outfile
}

#' @describeIn stats2table Converts subcortical segmentation statistics
#'   into tabular format by calling the FreeSurfer `asegstats2table`
#'   command.
#'  `...` is passed to [stats2table] for additional options.
#'
#' @param inputs (character paths) A vector of input filenames,
#'   e.g. `aseg.stats`. Alternatively, use `subjects` to specify subject IDs.
#' @param subjects (character) A vector of subject identifiers. Only one
#'   of `subjects` or `inputs` should be specified.
#' @export
asegstats2table <- function(
  subjects = NULL,
  inputs = NULL,
  measure = c("volume", "mean", "std"),
  ...
) {
  if (!is.null(subjects) && !is.null(inputs)) {
    cli::cli_abort(
      "'subjects' and 'inputs' cannot both be specified for asegstats2table."
    )
  }
  if (is.null(subjects) && is.null(inputs)) {
    cli::cli_abort(
      "Either 'subjects' or 'inputs' must be specified for asegstats2table."
    )
  }

  if (!is.null(subjects)) {
    input_val <- subjects
    input_type_val <- "subjects"
  } else {
    input_val <- inputs
    input_type_val <- "inputs"
  }

  stats2table(
    type = "aseg",
    input = input_val,
    input_type = input_type_val,
    measure = match.arg(measure),
    ...
  )
}

#' @describeIn stats2table Converts cortical parcellation statistics
#'   into tabular format by calling the FreeSurfer `aparcstats2table`
#'   command.
#'   `...` is passed to [stats2table] for additional options.`
#'
#' @param subjects (character) A vector of subject identifiers. This is
#'   the primary way to specify inputs when using this function.
#' @param hemi (character) The hemisphere for which statistics are computed.
#'   Options are "lh" (left hemisphere) or "rh" (right hemisphere).
#' @param parc (character) Specifies the parcellation scheme to be used.
#'   Options include "aparc" or "aparc.a2009s".
#' @param ... Additional arguments passed to [stats2table].
#' @export
aparcstats2table <- function(
  subjects,
  hemi = c("lh", "rh"),
  measure = c(
    "area",
    "volume",
    "thickness",
    "thicknessstd",
    "meancurv",
    "gauscurv",
    "foldind",
    "curvind"
  ),
  parc = c("aparc", "aparc.a2009s"),
  opts = "",
  ...
) {
  if (is.null(subjects) || length(subjects) == 0) {
    cli::cli_abort("Subjects must be specified for aparcstats2table.")
  }

  stats2table(
    type = "aparc",
    input = subjects,
    input_type = "subjects",
    measure = match.arg(measure),
    opts = paste(
      "--hemi",
      match.arg(hemi),
      "--parc",
      match.arg(parc),
      opts
    ),
    ...
  )
}

#' @describeIn stats2table Display FreeSurfer help for aparcstats2table
#' @param ... Additional arguments passed to [fs_help()]
#' @export
aparcstats2table.help <- function(...) {
  fs_help("aparcstats2table", ...)
}

#' @describeIn stats2table Display FreeSurfer help for asegstats2table
#' @export
asegstats2table.help <- function(...) {
  fs_help("asegstats2table", ...)
}
