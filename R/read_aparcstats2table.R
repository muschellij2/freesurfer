#' @title Read Parcellation Stats to Table Output
#' @description This function reads a \code{aparcstats2table} output
#' file
#' @param file (character path) filename of text file
#' @param sep separator to override attribute of file, to 
#' pass to \code{\link{read.table}}.
#' @param stringsAsFactors (logical) passed to \code{\link{read.table}} 
#' @param ... additional arguments to \code{\link{read.table}}
#' 
#' @return \code{data.frame} from the file
#' @export
#' @examples 
#' if (have_fs()) {
#'    outfile = aparcstats2table(subjects = "bert",
#'                     hemi = "lh",
#'                     meas = "thickness")
#'    df = read_aparcstats2table(outfile)
#' }
read_aparcstats2table = function(
  file,
  sep = NULL,
  stringsAsFactors = FALSE,
  ...
  ){
  
  if (is.null(sep)) {
    sep = attr(file, "separator") 
  }
  x = read.table(file = file, header = TRUE, sep = sep, 
                 stringsAsFactors = stringsAsFactors, ...)  
  return(x)
}

