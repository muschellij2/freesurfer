#' @title Read Label File 
#' @description Reads an \code{label} file from an individual subject
#' 
#' @param file label file from Freesurfer
#'
#' @return \code{data.frame} with 5 columns:
#'   \describe{
#'     \item{\code{vertex_num}:}{Vertex Number}
#'     \item{\code{r_coord}:}{Coordinate in RL direction}
#'     \item{\code{a_coord}:}{Coordinate in AP direction}
#'     \item{\code{s_coord}:}{Coordinate in SI direction}
#'     \item{\code{value}:}{ Value of label (depends on file)}
#'  }
#' @export
#'
#' @examples
#' if (have_fs()) {
#'  file = file.path(fs_subj_dir(), "bert", "label", "lh.BA1.label")
#'  if (!file.exists(file)) {
#'  file = file.path(fs_subj_dir(), "bert", "label", "lh.BA1_exvivo.label")
#'  }
#'  out = read_fs_label(file)
#' }
read_fs_label = function(file) {
  header = readLines(con = file)
  comment = header[1]
  n_lines = as.numeric(header[2])
  header = header[-c(1:2)]
  if (length(header) != n_lines) {
    warning("Number of lines do not match file specification! ")
  } 
  ss = strsplit(header, " ")
  ss = lapply(ss, function(x) {
    x[ !x %in% ""]
  })
  ss = do.call("rbind", ss)
  colnames(ss) = c("vertex_num", "r_coord", "a_coord", "s_coord", "value")
  ss = data.frame(ss, stringsAsFactors = FALSE)
  attr(ss, "comment") = comment
  return(ss)
}