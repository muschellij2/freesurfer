#' @title Convert Surface to Surface normals
#' @description This function call \code{mris_convert}, 
#' using the \code{-n} option
#' @param opts (character) additional options to 
#' \code{\link{mris_convert}}
#' @param ... additional arguments to \code{\link{mris_convert}}
#' 
#' @return Result of \code{\link{mris_convert}}
#' @export
#' @examples 
#' if (have_fs()) {
#'  bert_dir = file.path(fs_subj_dir(), "bert")
#'  asc_file = mris_convert_normals(
#'  infile = file.path(bert_dir, "surf", "lh.white")
#'  )  
#' readLines(asc_file, n = 6)
#' }   
mris_convert_normals = function(
  opts = "",
  ...
){
  
  ######################################################    
  # Making output file if not specified
  ######################################################      
  opts = paste(opts, collapse = " ")
  opts = paste0(opts, " ", "-n ")
  outfile = mris_convert(..., opts = opts)
  return(outfile)
}

