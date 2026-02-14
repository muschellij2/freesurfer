#' Convert Cortical Surface File Formats with FreeSurfer
#'
#' @description
#' These functions call FreeSurfer's `mris_convert` to convert between cortical
#' surface file formats. The base function `mris_convert()` provides general
#' conversion, while specialized variants handle specific data types.
#'
#' @details
#' FreeSurfer's `mris_convert` is a general conversion program for cortical
#' surface file formats. It can convert between binary and ASCII formats,
#' extract specific data types, and transform between coordinate systems.
#'
#' @param infile Character; path to input surface file.
#' @param outfile Character; path to output file. If NULL, a temporary file
#'   with the specified extension is created.
#' @param ext Character; output file extension when `outfile` is NULL.
#'   Default is ".asc".
#' @template opts
#' @template verbose
#' @param ... Additional arguments passed to `mris_convert`.
#'
#' @return Character; path to the output file. For `mris_convert()`, the
#'   output has a "separator" attribute indicating the file's field separator.
#'
#'
#' @name mris_convert
#' @export
#'
#' @examplesIf have_fs()
#' \dontrun{
#' bert_dir <- file.path(fs_subj_dir(), "bert")
#' bert_surf <- file.path(bert_dir, "surf", "lh.white")
#'
#' # Basic conversion to ASCII
#' asc_file <- mris_convert(infile = bert_surf)
#'
#' # Convert with annotation data
#' gii_file <- mris_convert_annot(
#'   infile = bert_surf,
#'   annot = file.path(bert_dir, "label", "lh.aparc.annot"),
#'   ext = ".gii"
#' )
#'
#' # Convert with curvature overlay
#' curv_file <- mris_convert_curv(
#'   infile = bert_surf,
#'   curv = file.path(bert_dir, "surf", "lh.thickness")
#' )
#'
#' # Extract surface normals
#' normals_file <- mris_convert_normals(infile = bert_surf)
#'
#' # Extract vertex coordinates
#' vertex_file <- mris_convert_vertex(infile = bert_surf)
#' }
mris_convert <- function(
  infile,
  outfile = NULL,
  ext = ".asc",
  opts = "",
  verbose = get_fs_verbosity(),
  ...
) {
  validate_fs_env(check_license = FALSE)

  if (is.null(outfile)) {
    outfile <- temp_file(fileext = ext)
  }

  cmd_args <- c(
    paste(opts, collapse = " "),
    infile,
    outfile
  )

  cmd <- paste0(
    get_fs(),
    "mris_convert ",
    paste(cmd_args, collapse = " ")
  )

  run_check_fs_cmd(
    cmd = cmd,
    outfile = outfile,
    verbose = verbose,
    func_name = "mris_convert",
    ...
  )

  attr(outfile, "separator") <- " "
  outfile
}

#' @describeIn mris_convert Convert with annotation or gifti label data
#' @param annot Character; path to annotation or gifti label file.
#' @export
mris_convert_annot <- function(annot, opts = "", ...) {
  opts <- paste(opts, collapse = " ")
  opts <- paste0("--annot ", annot, " ", opts)
  mris_convert(..., opts = opts)
}

#' @describeIn mris_convert Convert with scalar curvature overlay
#' @param curv Character; path to scalar curvature overlay file.
#' @note For curvature conversions, the output filename may be modified by
#'   FreeSurfer. You may need to prepend the hemisphere prefix to get the
#'   correct path.
#' @export
mris_convert_curv <- function(curv, opts = "", ...) {
  opts <- paste(opts, collapse = " ")
  opts <- paste0("-c ", curv, " ", opts)
  mris_convert(..., opts = opts)
}

#' @describeIn mris_convert Extract surface normals
#' @export
mris_convert_normals <- function(opts = "", ...) {
  opts <- paste(opts, collapse = " ")
  opts <- paste0(opts, " -n")
  mris_convert(..., opts = opts)
}

#' @describeIn mris_convert Extract vertex coordinates
#' @export
mris_convert_vertex <- function(opts = "", ...) {
  opts <- paste(opts, collapse = " ")
  opts <- paste0(opts, " -v")
  mris_convert(..., opts = opts)
}

#' @describeIn mris_convert Display FreeSurfer help for mris_convert
#' @export
mris_convert.help <- function(...) {
  fs_help("mris_convert", ...)
}
