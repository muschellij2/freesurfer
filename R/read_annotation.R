#' Read Freesurfer annotation file
#'
#' Reads Freesurfer binary annotation files
#' that contain information on vertex labels
#' and colours for use in analyses and
#' brain area lookups.
#'
#' This function is heavily
#' based on Freesurfer's read_annotation.m
#' Original Author: Bruce Fischl
#' CVS Revision Info:
#'     $Author: greve $
#'     $Date: 2014/02/25 19:54:10 $
#'     $Revision: 1.10 $
#'
#' @param path path to annotation file, usually with extension \code{annot}
#' @param verbose logical.
#'
#' @return list of 3 with vertices, labels, and colortable
#' @export
#' @examplesIf have_fs()
#' bert_dir = file.path(fs_subj_dir(), "bert")
#' annot_file = file.path(bert_dir, "label", "lh.aparc.annot")
#' res = read_annotation(annot_file)
read_annotation <- function(path, verbose = get_fs_verbosity()) {
  check_path(path)

  ff <- file(path, "rb")
  on.exit(close(ff))

  annot <- readBin(ff, integer(), endian = "big")

  if (length(annot) == 0) {
    cli::cli_abort("File {.path {path}} does not have the expected content")
  }

  tmp <- readBin(ff, integer(), n = 2 * annot, endian = "big")

  vertices <- tmp[seq(1, by = 2, length.out = length(tmp) / 2)]
  label <- tmp[seq(2, by = 2, length.out = length(tmp) / 2)]

  bool <- readBin(ff, integer(), endian = "big")
  if (bool == 0 || length(bool) == 0 || is.null(bool)) {
    colortable <- data.frame(matrix(NA, ncol = 6, nrow = 0))
    names(colortable) <- c("label", "R", "G", "B", "A", "code")
    if (verbose) fs_warn("No colortable in file")
  } else if (bool == 1) {
    # Read colortable
    numEntries <- readBin(ff, integer(), endian = "big")

    if (numEntries > 0) {
      if (verbose) cli::cli_text('Reading from Original Version')
    } else {
      version <- numEntries

      if (verbose) {
        if (version != 2) {
          fs_warn(
            "Reading from version {.code {version}}, there may be issues."
          )
        } else {
          cli::cli_text("Reading from version {.code {version}}")
        }
      }
    }

    numEntries <- readBin(ff, integer(), endian = "big")
    colortable.numEntries <- numEntries
    len <- readBin(ff, integer(), endian = "big")

    colortable.orig_tab <- readBin(ff, character(), n = 1, endian = "big")
    colortable.orig_tab <- t(colortable.orig_tab)

    numEntriesToRead <- readBin(ff, integer(), endian = "big")
    colortable <- data.frame(
      matrix(NA, ncol = 6, nrow = numEntriesToRead)
    )
    names(colortable) <- c("label", "R", "G", "B", "A", "code")

    for (i in 1:numEntriesToRead) {
      struct <- readBin(ff, integer(), endian = "big")

      if (struct < 0 & verbose) {
        cli::cli_alert_danger('Error! Read entry, index {.val {struct}}')
      }

      if ((struct %in% colortable$label) & verbose) {
        cli::cli_alert_danger("Error! Duplicate Structure: {.val {struct}}")
      }

      len <- readBin(ff, integer(), endian = "big")

      colortable$label[struct] <- t(readBin(
        ff,
        character(),
        n = 1,
        endian = "big"
      ))

      colortable$R[struct] <- readBin(ff, integer(), endian = "big")
      colortable$G[struct] <- readBin(ff, integer(), endian = "big")
      colortable$B[struct] <- readBin(ff, integer(), endian = "big")
      colortable$A[struct] <- readBin(ff, integer(), endian = "big")

      colortable$code[struct] <- colortable$R[struct] +
        colortable$G[struct] * 2^8 +
        colortable$B[struct] * 2^16
    } # for i

    if (verbose) {
      cli::cli_text(
        "colortable with {.val {nrow(colortable)}} entries read (from {.val {colortable.orig_tab}}"
      )
    }
  } else {
    cli::cli_abort("Error! Should not be expecting bool == {.val 0}")
  }

  # This makes it so that each empty entry at least has a string, even
  # if it is an empty string. This can happen with average subjects.
  if (any(is.na(colortable$label))) {
    colortable$label[is.na(colortable$label)] <- ""
  }

  list(
    vertices = vertices,
    label = label,
    colortable = colortable
  )
}
