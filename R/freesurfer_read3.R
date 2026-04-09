#' @title Freesurfer Read 3 records
#' @description Reads first 3 records of file and returns the
#' rotated value,
#' for checking for other functions.
#' @param file thickness file or anything in surf/ directory
#' from Freesurfer subject
#'
#' @return Numeric
#' @noRd
#' @keywords internal
#' @examplesIf have_fs()
#' \dontshow{
#' options(freesurfer.verbose = FALSE)
#' }
#' bert_dir = file.path(fs_subj_dir(), "bert", "surf")
#' file = file.path(bert_dir, "lh.thickness")
#' out = freesurfer_read3(file)
freesurfer_read3 <- function(file) {
  fid <- file
  if (!inherits(file, "connection")) {
    fid <- file(file, open = "rb")
    on.exit({
      close(fid)
    })
  }

  b <- as.integer(readBin(fid, 3, what = "raw", endian = "big"))
  bitwShiftL(b[1], 16) + bitwShiftL(b[2], 8) + b[3]
}

#' @title Read Freesufer Curv file
#' @description Reads a Freesurfer curvature file according to the
#' FREESURFER_HOME/matlab/read_curv.m file.
#' @param file file name of a curvature file
#'
#' @return Numeric vector
#' @export
#'
#' @examplesIf have_fs()
#' \dontshow{
#' options(freesurfer.verbose = FALSE)
#' }
#' bert_dir = file.path(fs_subj_dir(), "bert", "surf")
#' file = file.path(bert_dir, "lh.thickness")
#' fid = file(file, open = "rb")
#' out = freesurfer_read_curv(file)
freesurfer_read_curv <- function(file) {
  fid <- file(file, open = "rb")
  on.exit({
    close(fid)
  })
  vnum <- freesurfer_read3(fid)

  if (vnum != 16777215) {
    cli::cli_abort(
      "Unknown version of curv file ({.val {vnum}}) - may not implemented yet"
    )
  }
  vnum <- readBin(fid, 1, what = integer(), endian = "big")
  fnum <- readBin(fid, 1, what = integer(), endian = "big")

  vals_per_vertex <- readBin(fid, 1, what = integer(), endian = "big")
  readBin(fid, double(), n = vnum, size = 4, endian = "big")
}


#' @title Read Freesurfer Surface file
#' @description Reads a Freesurfer Surface file from
#' the \code{surf/} directory
#' from \code{recon-all}
#' @param file surface file (e.g. \code{lh.inflated})
#' @template verbose
#'
#' @return List of length 2: vertices and faces are the elements
#' @export
#'
#' @examplesIf have_fs()
#' \dontshow{
#' options(freesurfer.verbose = FALSE)
#' }
#' fname = file.path(fs_subj_dir(), "bert", "surf", "lh.inflated")
#' out = freesurfer_read_surf(fname)
freesurfer_read_surf <- function(file, verbose = get_fs_verbosity()) {
  fid <- file(file, open = "rb")
  on.exit({
    close(fid)
  })
  TRIANGLE_FILE_MAGIC_NUMBER <- 16777214
  QUAD_FILE_MAGIC_NUMBER <- 16777215

  magic <- freesurfer_read3(fid)

  if (
    magic != TRIANGLE_FILE_MAGIC_NUMBER &&
      magic != QUAD_FILE_MAGIC_NUMBER
  ) {
    cli::cli_abort(
      "Unknown vertex shape {.val {magic}} in file {.file {file}}"
    )
  }

  if (magic == QUAD_FILE_MAGIC_NUMBER) {
    vnum <- freesurfer_read3(fid)
    fnum <- freesurfer_read3(fid)
    # int16
    vertices <- readBin(
      fid,
      n = vnum * 3,
      integer(),
      endian = "big",
      size = 2
    ) /
      100

    faces <- matrix(nrow = fnum, ncol = 4)
    for (iface in seq(fnum)) {
      for (n in 1:4) {
        faces[iface, n] = freesurfer_read3(fid)
      }
    }
    # faces =
    # b = as.integer(readBin(fid, 3 * fnum * 4,
    # what = "raw", endian = "big"))
    # b = matrix(b, nrow = 3)
    # retval = bitwShiftL(b[1,], 16) + bitwShiftL(b[2,],8) + b[3,]
    #
    # faces = matrix(NA, ncol = 4, nrow = fnum, byrow = TRUE)
    #
    # # if (nargout > 1) {
    #   for (i in 1:fnum) {
    #     for (n in 1:4) {
    #       faces[i,n] = freesurfer_read3(fid) ;
    #     }
    #   }
    # }
    # faces = NULL
  } else if (magic == TRIANGLE_FILE_MAGIC_NUMBER) {
    tline <- readLines(fid, 1) # fgets similar to matlab
    if (verbose) {
      cli::cli_text(tline)
    }
    tline <- readLines(fid, 1)
    if (verbose) {
      cli::cli_text(tline)
    }
    vnum <- readBin(fid, 1, what = integer(), endian = "big")
    fnum <- readBin(fid, 1, what = integer(), endian = "big")
    # size = 4
    # "16" = readBin(fid, double(), n, nim@"bitpix"/8, endian=endian)
    # vertex_coords = fread(fid, vnum*3, 'float32') ;
    vertices <- readBin(fid, double(), n = vnum * 3, size = 4, endian = "big")
    faces <- readBin(fid, fnum * 3, what = integer(), endian = "big")
    faces <- matrix(faces, nrow = 3, ncol = fnum, byrow = FALSE)
    faces <- t(faces)
  }
  vertices <- matrix(vertices, nrow = 3, byrow = FALSE)
  vertices <- t(vertices)

  list(vertices = vertices, faces = faces)
}
