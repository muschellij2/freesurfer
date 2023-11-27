#' @title Convert Curvature file
#' @description This function call \code{mris_convert}, 
#' using the \code{-c} option
#' @param curv (character) scalar curv overlay file
#' @param opts (character) additional options to 
#' \code{\link{mris_convert}}
#' @param ... additional arguments to \code{\link{mris_convert}}
#' 
#' @note The filename of the output may change due to how Freesurfer
#' does curvature conversions and you may need to paste the prefix to get
#' the correct filename, as seen in the example.
#' 
#' @return Result of \code{\link{mris_convert}}
#' @export
#' @examples 
#' if (have_fs()) {
#'  bert_surf_dir = file.path(fs_subj_dir(), "bert", "surf")
#'  asc_file = mris_convert_curv(
#'  infile = file.path(bert_surf_dir, "lh.white"),
#'  curv = file.path(bert_surf_dir, "lh.thickness")
#'  )
#'  if (!file.exists(asc_file)) {
#'    asc_file = file.path(dirname(asc_file), paste0("lh.",
#'    basename(asc_file)))
#'  }
#'  res = read_fs_table(asc_file, header = FALSE)
#'  colnames(res) = c("index", "coord_1", "coord_2", "coord_3", "value")
#'  head(res)
#' }  
mris_convert_curv = function(
  curv,
  opts = "",
  ...
){
  
  ######################################################    
  # Making output file if not specified
  ######################################################      
  opts = paste(opts, collapse = " ")
  opts = paste0("-c ", curv, " ", opts)
  outfile = mris_convert(..., opts = opts)
  return(outfile)
}

