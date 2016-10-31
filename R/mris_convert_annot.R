#' @title Convert Annotation file
#' @description This function call \code{mris_convert}, 
#' using the \code{--annot} option
#' @param annot (character) annotation or gifti label data
#' @param opts (character) additional options to 
#' \code{\link{mris_convert}}
#' @param ... additional arguments to \code{\link{mris_convert}}
#' 
#' @return Result of \code{\link{mris_convert}}
#' @export
#' @examples 
#' if (have_fs()) {
#'  bert_dir = file.path(fs_subj_dir(), "bert")
#'  gii_file = mris_convert_annot(
#'  infile = file.path(bert_dir, "surf", "lh.white"),
#'  annot = file.path(bert_dir, "label", "lh.aparc.annot"),
#'  ext = ".gii"
#'  )  
#'  gii = mris_convert_annot(
#'  infile = file.path(bert_dir, "surf", "lh.white"),
#'  annot = gii_file,
#'  ext = ".gii"
#'  )  
#' }   
mris_convert_annot = function(
  annot,
  opts = "",
  ...
){
  
  ######################################################    
  # Making output file if not specified
  ######################################################      
  opts = paste(opts, collapse = " ")
  opts = paste0("--annot ", annot, " ", opts)
  outfile = mris_convert(..., opts = opts)
  return(outfile)
}

