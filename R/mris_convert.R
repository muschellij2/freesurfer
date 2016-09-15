#' @title Use Freesurfers MRIs Converter 
#' @description This function call  \code{mris_convert}, a general conversion program for converting between cortical surface file formats 
#' @param curvinfilepath (character) input filename for curve
#' @param origfilepath (character) file path for origin file
#' @param outfile (character) output file path 
#' @param ext (character) output file extension, default is set to .asc
#' @return Result of \code{system} command
#' @export
#' @examples 
#' if (have_fs()) {
#'  mris_convert(curvinfilepath = 'lh.thickness', origfilepath = 'lh.white', outfile = 'lh.thickness.asc')  
#' } 

mris_convert = function(
  curvinfilepath, 
  origfilepath,
  outfile = NULL,
  ext = '.asc'){
  
  ######################################################    
  # Making output file if not specified
  ######################################################      
  if (is.null(outfile)) {
    outfile = tempfile(fileext = ext)
  }
   
  cmd <- paste('mris_convert -c', curvinfilepath, origfilepath, outfile, sep = ' ')
  cmd <- paste0(get_fs(), cmd)
  res = system(cmd)
}


#' @title Help file for Freesurfers MRIs Converter 
#' @description This calls Freesurfer's \code{mris_convert} help 
#'
#' @return Result of \code{fs_help}
#' @export
mri_convert.help = function(){
  fs_help(func_name = "mris_convert")
}