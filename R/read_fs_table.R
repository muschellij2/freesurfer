#' @title Read Freesurfer Table Output
#' @description This function reads output from a Freesurfer table command,
#' e.g. \code{aparcstats2table}, \code{asegstats2table}
#' 
#' @param file (character path) filename of text file
#' @param sep separator to override attribute of file, to 
#' pass to \code{\link[utils]{read.table}}.
#' @param stringsAsFactors (logical) passed to \code{\link{read.table}} 
#' @param header Is there a header in the data
#' @param ... additional arguments to \code{\link{read.table}}
#' 
#' @return \code{data.frame} from the file
#' @importFrom utils read.table
#' @export
#' @examples 
#' if (have_fs()) {
#'    outfile = aparcstats2table(subjects = "bert",
#'                     hemi = "lh",
#'                     meas = "thickness")
#'    df = read_fs_table(outfile)
#'    seg_outfile = asegstats2table(subjects = "bert", meas = "mean")
#'    df_seg = read_fs_table(seg_outfile)
#' }
#' \dontrun{
#' ### using the pipe
#' if (requireNamespace("magrittr", quietly = TRUE)) {
#' df_seg = asegstats2table(subjects = "bert", meas = "mean") %>% 
#'             read_fs_table
#'             }
#' }
read_fs_table = function(
  file,
  sep = NULL,
  stringsAsFactors = FALSE,
  header = TRUE,
  ...
  ){
  
  if (is.null(sep)) {
    sep = attr(file, "separator") 
  }
  x = utils::read.table(file = file, header = header, sep = sep, 
                 stringsAsFactors = stringsAsFactors, ...)  
  return(x)
}

