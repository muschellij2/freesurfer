#' @importFrom roxygen2 roxy_tag_parse roxy_tag_rd rd_section
#' @export
roxy_tag_parse.roxy_tag_fsHelp <- function(x) {
  parts <- strsplit(trimws(x$raw), "\\s+")[[1]]
  x$val <- list(
    func_name = parts[1],
    help_arg  = if (length(parts) > 1) parts[2] else "--help",
    bin_app   = if (length(parts) > 2) parts[3] else "bin"
  )
  x
}

#' @export
roxy_tag_rd.roxy_tag_fsHelp <- function(x, base_path, env) {
  roxygen2::rd_section("fsHelp", x$val)
}

#' @export
format.rd_section_fsHelp <- function(x, ...) {
  paste0(
    "\\section{FreeSurfer CLI Help}{\n",
    "\\Sexpr[results=rd,stage=render]{freesurfer::fs_help_rd(\"",
    x$value$func_name, "\", \"",
    x$value$help_arg, "\", \"",
    x$value$bin_app, "\")}\n",
    "}\n"
  )
}
