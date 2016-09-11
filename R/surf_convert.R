#' @title Convert Surface Data to ASCII
#' @description This function calls \code{mri_convert} to convert a measure
#' from surfaces to an ASCII file and reads it in.
#' @param file (character) input filename of curvature measure
#' @param outfile (character) output filename (if wanted to be saved)
#' @return \code{data.frame}
#' @export
#' @examples 
#' if (have_fs()) {
#'    fname = file.path(fs_subj_dir(), "bert", "surf", "lh.thickness")
#'    out = surf_convert(fname)
#' }
surf_convert = function(
  file, 
  outfile = NULL){
  
  if (is.null(outfile)) {
    outfile = tempfile(fileext = ".dat")
  }
  opts = "--ascii+crsf"
  res = fs_cmd(
    func = "mri_convert",
    file = file,
    outfile = outfile,
    frontopts = opts,
    retimg = FALSE,
    samefile = FALSE,
    add_ext = FALSE)
  stopifnot(res == 0)
  
  ###############################
  # Reading the data back in
  ###############################
  rl = readLines(outfile)
  rl = trimws(rl)
  rl = gsub("\\s+", " ", rl)
  rl = strsplit(rl, " ")
  rl = do.call("rbind", rl)
  class(rl) = "numeric"
  colnames(rl) = c("col", "row", "slice", "frame", "value")
  
  return(rl)
}