#' @title Parcellation Stats to Table 
#' @description This function calls \code{aparcstats2table} to 
#' convert parcellation statistics to a table
#' @param subjects (character) vector of subjects
#' @param outfile (character) output filename
#' 
#' @param opts (character) additional options to \code{aparcstats2table}
#' @return Result of \code{system} command
#' @export
aparcstats2table = function(
  subjects,
  outfile = NULL,
  hemi = c("lh", "rh"),
  measure =  c("area", "volume", "thickness",
               "thicknessstd", "meancurv", "gauscurv", 
               "foldind", "curvind"),
  sep = c("tab", "space", "comma", "semicolon"),
  parc = c("aparc", "aparc.a2009s"),
  subj_dir = NULL,
  skip = FALSE,
  opts = "",
  verbose = TRUE){
  
  ###########################
  # Making Hemisphere
  ###########################  
  hemi = match.arg(hemi)
  hemi = paste0("--hemi ", hemi)
  args = hemi
  ###########################
  # Making Subject Vector
  ###########################    
  subjects = paste(subjects, collapse = " ")
  subjects = paste0("--subjects ", subjects)
  args = paste(args, subjects)
  
  ###########################
  # Making Separator
  ###########################    
  sep = match.arg(sep)
  args = paste(args, paste0("--delimiter ", sep))
  
  ext = switch(sep,
               "tab" = ".txt",
               "space" = ".txt",
               "comma" = ".csv",
               "semicolon" = ".txt")  
  sep = switch(sep,
               "tab" = "\t",
               "space" = " ",
               "comma" = ",",
               "semicolon" = ";")
  
  ###########################
  # Making Parcellation arg
  ###########################  
  parc = match.arg(parc)
  parc = paste0("--parc ", parc)
  args = paste(args, parc)
  
  ###########################
  # Adding verbose option
  ###########################    
  if (verbose) {
    args = paste(args, "--debug")
  }
  
  ###########################
  # Making measure
  ###########################  
  measure = match.arg(measure)
  measure = match.arg(parc)
  measure = paste0("--measure ", measure)
  args = paste(args, measure)  
  
  ###########################
  # Making output file if not specified
  ###########################    
  if (is.null(outfile)) {
    outfile = tempfile(fileext = ext)
  }
  outfile = c("--tablefile ", outfile)
  
  ###########################
  # Need ability to have 
  # non-standard subjects directory
  ###########################  
  cmd_pre = ""
  if (!is.null(subj_dir)) {
    orig_subj_dir = Sys.getenv("SUBJECTS_DIR")
    old_reset = sprintf("export SUBJECTS_DIR=%s; ", orig_subj_dir)
    on.exit({
      system(old_reset)
    })    
    cmd_pre = sprintf("export SUBJECTS_DIR=%s; ", subj_dir)
  }
  
  ###########################
  # Add the Subjects DIR Stuff to the command first
  ###########################  
  cmd = get_fs()
  cmd = paste0(cmd_pre, cmd)
  
  cmd = paste(cmd, args)
  cmd = paste(cmd, opts)
  
  fe_before = file.exists(outfile)
  res = system(cmd)
  fe_after = file.exists(outfile)
  
  if (res != 0 & !fe_after) {
    stop("Command Failed, no output produced")
  }
  if (res != 0 & fe_after & fe_before) {
    warning(paste0(
      " Command aparcstats2table ", 
      "had non-zero exit status (probably failed),",
      " outfile exists but existed before command was run. ",
      " Please check output.")
    )
  }  
  
  if (res != 0 & fe_after & !fe_before) {
    warning(paste0(
      " Command aparcstats2table ", 
      "had non-zero exit status (probably failed),",
      " outfile exists and did NOT before command was run. ",
      " Please check output.")
    )
  }  
  attr(outfile, "separator") = sep
  return(outfile)
}


#' @title Parcellation Stats to Table Help
#' @description This calls Freesurfer's \code{aparcstats2table} help 
#'
#' @return Result of \code{fs_help}
#' @export
aparcstats2table.help = function(){
  fs_help(func_name = "aparcstats2table", help.arg = "-help")
}