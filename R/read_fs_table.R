# Final R/read_fs_table.R - Clean table reader with auto-detection

#' Read FreeSurfer Table Output
#' @description This function reads output from a FreeSurfer table command,
#' e.g. \code{aparcstats2table}, \code{asegstats2table}
#'
#' @param file (character path) filename of text file
#' @param sep separator to override attribute of file, to
#' pass to \code{\link[utils]{read.table}}.
#' @param stringsAsFactors (logical) passed to \code{\link{read.table}}
#' @param header Is there a header in the data
#' @param validate_format (logical) Whether to warn about unexpected formats
#' @param ... additional arguments to \code{\link{read.table}}
#'
#' @return \code{data.frame} from the file
#' @importFrom utils read.table
#' @export
#' @examplesIf have_fs()
#' outfile = aparcstats2table(
#'    subjects = "bert",
#'    hemi = "lh",
#'    meas = "thickness"
#' )
#' df = read_fs_table(outfile)
#' seg_outfile = asegstats2table(subjects = "bert", meas = "mean")
#' df_seg = read_fs_table(seg_outfile)
read_fs_table <- function(
  file,
  sep = NULL,
  header = TRUE,
  validate_format = TRUE,
  stringsAsFactors = FALSE,
  ...
) {
  # Simple validation
  check_path(file)

  # Format validation - just warn for unexpected extensions
  if (validate_format) {
    valid_extensions <- c("txt", "stats", "dat", "csv", "tsv", "table")
    file_ext <- tools::file_ext(file)

    if (nzchar(file_ext) && !file_ext %in% valid_extensions) {
      fs_warn(
        "Unexpected file extension for statistics table",
        details = paste(
          "Got:",
          file_ext,
          "Expected one of:",
          paste(valid_extensions, collapse = ", ")
        )
      )
    }
  }

  # Auto-detect separator if not provided
  if (is.null(sep)) {
    # First check if file has a delimiter attribute (from FreeSurfer functions)
    sep <- attr(file, "delimiter")

    if (is.null(sep)) {
      # Simple auto-detection
      sample_lines <- readLines(file, n = 5, warn = FALSE)

      if (length(sample_lines) == 0) {
        fs_abort("File appears to be empty", details = file)
      }

      # Filter out comment lines for separator detection
      data_lines <- sample_lines[
        !grepl("^#", sample_lines) & nzchar(trimws(sample_lines))
      ]

      if (length(data_lines) == 0) {
        sep <- " " # Default fallback
      } else {
        # Test common separators and pick the one that gives most consistent column counts
        separators <- c("\t", ",", " ", "|")
        names(separators) <- c("tab", "comma", "space", "pipe")

        sep_scores <- sapply(separators, function(s) {
          cols <- sapply(data_lines, function(line) {
            length(strsplit(line, s, fixed = TRUE)[[1]])
          })
          mean(cols[cols > 1]) # Only count if results in more than 1 column
        })

        # Remove NaN values and pick best
        sep_scores <- sep_scores[!is.nan(sep_scores)]

        if (length(sep_scores) > 0) {
          sep <- separators[which.max(sep_scores)]
        } else {
          sep <- " " # Ultimate fallback
        }
      }

      if (get_fs_verbosity()) {
        fs_inform(
          paste("Auto-detected separator:", dQuote(sep)),
          details = paste("Analyzed", length(data_lines), "data lines")
        )
      }
    }
  }

  # Read table - let read.table handle its own errors
  result <- read.table(
    file,
    header = header,
    sep = sep,
    stringsAsFactors = stringsAsFactors,
    ...
  )

  # Simple validation with helpful warnings
  if (nrow(result) == 0) {
    fs_warn(
      "Table file appears to be empty or contains no data rows",
      details = paste("File:", file)
    )
  }

  if (ncol(result) == 1 && sep != " ") {
    fs_warn(
      "Table has only one column - separator may be incorrect",
      details = paste(
        "Detected separator:",
        dQuote(sep),
        "- try specifying sep manually"
      )
    )
  }

  # Informative summary if verbose
  if (get_fs_verbosity()) {
    fs_inform(
      paste(
        "Successfully read table:",
        nrow(result),
        "rows,",
        ncol(result),
        "columns"
      ),
      details = paste("File:", basename(file))
    )
  }

  return(result)
}

#' @rdname read_fs_table
#' @export
read_stats_table <- read_fs_table
