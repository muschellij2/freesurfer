#' @title Parcellation Stats to Table 
#' @description This function calls \code{asegstats2table} to 
#' convert parcellation statistics to a table
#' @param subjects (character) vector of subjects
#' @param inputs (character paths) vector of input filenames,
#' e.g. \code{aseg.stats}.
#' @param outfile (character) output filename
#' @param measure (character) measure to be calculated
#' @param sep (character) separator for the output file.  This will be
#' an attribute of \code{outfile}
#' @param skip (logical) if subject does not have parcellation, 
#' should the command skip that subject (\code{TRUE}) or error 
#' (\code{FALSE})
#' @param subj_dir (character path) if a different subjects directory
#' is to be used other than \code{SUBJECTS_DIR} from shell, it can be
#' specified here.  Use with care as if the command fail, it may not reset
#' the \code{SUBJECTS_DIR} back correctly after the error
#' @param opts (character) additional options to \code{asegstats2table}
#' @param verbose (logical) print diagnostic messages
#' 
#' @return Character filename of output file, with the 
#' attribute of the separator
#' @export
#' @examples 
#' if (have_fs()) {
#'    outfile = asegstats2table(subjects = "bert",
#'                     meas = "mean")
#' }
asegstats2table = function(
  subjects = NULL,
  inputs = NULL,
  outfile = NULL,
  measure =  c("volume", "mean",
               "std"),
  sep = c("tab", "space", "comma", "semicolon"),
  skip = FALSE,
  subj_dir = NULL,
  opts = "",
  verbose = TRUE){
  
  if (is.null(subjects) & is.null(inputs)) {
    stop("Subjects or inputs must be specified!")
  }
  if (!is.null(subjects) & !is.null(inputs)) {
    stop("Both subjects and inputs should not be specified!")
  }  

  args = NULL
  ###########################
  # Making Subject Vector
  ###########################   
  if (is.null(subjects) & !is.null(inputs)) {
    inputs = paste(inputs, collapse = " ")
    inputs = paste0("--inputs ", inputs)
    args = c(args, inputs)
  }
  ###########################
  # Making Subject Vector
  ###########################   
  if (!is.null(subjects) & is.null(inputs)) {
    subjects = paste(subjects, collapse = " ")
    subjects = paste0("--subjects ", subjects)
    args = c(args, subjects)
  }  
  
  ###########################
  # Making Separator
  ###########################    
  sep = match.arg(sep)
  args = c(args, paste0("--delimiter ", sep))
  
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
  # Adding verbose option
  ###########################    
  if (verbose) {
    args = c(args, "--debug")
  }
  
  ###########################
  # Making measure
  ###########################  
  measure = match.arg(measure)
  measure = paste0("--meas ", measure)
  args = c(args, measure)  
  
  ###########################
  # Making skip
  ###########################  
  if (skip) {
    args = c(args, "--skip")
  }
  
  ###########################
  # Making output file if not specified
  ###########################    
  if (is.null(outfile)) {
    outfile = tempfile(fileext = ext)
  }
  args = c(args, paste0("--tablefile ", outfile))  
  
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
    subj_dir = path.expand(subj_dir)
    cmd_pre = sprintf("export SUBJECTS_DIR=%s; ", subj_dir)
  }
  
  ###########################
  # Add the Subjects DIR Stuff to the command first
  ###########################  
  cmd = paste0(get_fs(), "asegstats2table")
  cmd = paste0(cmd_pre, cmd)
  
  args = paste(args, collapse = " ")
  cmd = paste(cmd, args)
  cmd = paste(cmd, opts)
  
  fe_before = file.exists(outfile)
  if (verbose) {
    message(cmd, "\n")
  }  
  res = system(cmd)
  fe_after = file.exists(outfile)
  
  if (res != 0 & !fe_after) {
    stop("Command Failed, no output produced")
  }
  if (res == 0 & !fe_after) {
    warning("Command assumed passed, but no output produced")
  }    
  if (res != 0 & fe_after & fe_before) {
    warning(paste0(
      " Command asegstats2table ", 
      "had non-zero exit status (probably failed),",
      " outfile exists but existed before command was run. ",
      " Please check output.")
    )
  }  
  
  if (res != 0 & fe_after & !fe_before) {
    warning(paste0(
      " Command asegstats2table ", 
      "had non-zero exit status (probably failed),",
      " outfile exists and did NOT before command was run. ",
      " Please check output.")
    )
  }  
  attr(outfile, "separator") = sep
  return(outfile)
}


#' @title Parcellation Stats to Table Help
#' @description This calls Freesurfer's \code{asegstats2table} help 
#'
#' @return Result of \code{fs_help}
#' @export
asegstats2table.help = function(){
  fs_help(func_name = "asegstats2table", help.arg = "--help")
}