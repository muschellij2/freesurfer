#' @title Use Freesurfers \code{mri_surf2surf} function to 
#' resamples one cortical surface onto another 
#' @description This function calls Freesurfer \code{mri_surf2surf} to 
#' resample one cortical surface onto another 
#' @param subject (character) vector of subject name 
#' @param outfile (character) output filename
#' @param hemi (character) hemisphere to run statistics
#' @param target_subject (character) vector of target subject name 
#' @param src_type (character) source file type, can be curv or paint (w)
#' @param trg_type (character) target file type, can be curv, paint (w), mgh, or nii
#' @param sval (character) source file 
#' @param subj_dir (character path) if a different subjects directory
#' is to be used other than \code{SUBJECTS_DIR} from shell, it can be
#' specified here.  Use with care as if the command fail, it may not reset
#' the \code{SUBJECTS_DIR} back correctly after the error
#' @param opts (character) additional options to \code{mri_surf2surf}
#' @param verbose (logical) print diagnostic messages
#' @return Name of output file
#' @export
#' @examples 
#' if (have_fs()) {
#'    out = mri_surf2surf( 
#'    subject = 'bert',
#'    target_subject = 'fsaverage', 
#'    trg_type  = 'curv', 
#'    src_type  = 'curv', 
#'    hemi = "rh",
#'    sval = "thickness")
#' } 
mri_surf2surf = function(
  subject = NULL ,
  target_subject = NULL, 
  trg_type  = c('curv', 'w', 'mgh', 'nii'), 
  src_type  = c('curv', 'w'), 
  outfile = NULL,
  hemi = c("lh", "rh"),
  sval = c("thickness"),
  subj_dir = NULL,
  opts = "",
  verbose = TRUE){
  
  ###########################
  # Making Hemisphere
  ###########################  
  hemi = match.arg(hemi)
  xhemi = hemi
  hemi = paste0("--hemi ", hemi)
  args = hemi
  ###########################
  # Making Subject Vector
  ###########################    
  subject = paste0("--s ", subject)
  args = c(args, subject)
  ###########################
  # Making Target Subject 
  ###########################  
  target_subject = paste0("--trgsubject ", target_subject)
  args = c(args, target_subject)
  ###########################
  # Making Target Type 
  ###########################  
  trg_type = match.arg(trg_type)
  trg_type = paste0("--trg_type ", trg_type)
  args = c(args, trg_type)
  ###########################
  # Making Source File
  ###########################  
  sval = match.arg(sval)
  # ext = paste0(".", sval)
  sval = paste0("--sval ", sval)
  args = c(args, sval)
  ###########################
  # Making Source Type 
  ###########################  
  src_type = match.arg(src_type)
  src_type = paste0("--src_type ", src_type)
  args = c(args, src_type)
  ###########################
  # Making output file if not specified
  ###########################    
  if (is.null(outfile)) {
    outfile = tempfile()
  }
  args = c(args, paste0("--tval ", outfile))  
  outfile = file.path(dirname(outfile), 
                      paste0(xhemi, ".", basename(outfile)))  
  
  ###########################
  # Adding verbose option
  ###########################    
  if (verbose) {
    args = c(args, "--debug")
  }
  


  ###########################
  # Making output file if not specified

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
  cmd = paste0(get_fs(), "mri_surf2surf")
  cmd = paste0(cmd_pre, cmd)
  
  args = paste(args, collapse = " ")
  cmd = paste(cmd, args)
  cmd = paste(cmd, opts)
  
  run_check_fs_cmd(cmd = cmd, outfile = outfile, verbose = verbose)
  
  return(outfile)
}


#' @title Freesurfers mri_surf2surf Help
#' @description This calls Freesurfer's \code{mri_surf2surf} help 
#'
#' @return Result of \code{fs_help}
#' @export
mri_surf2surf.help = function(){
  fs_help(func_name = "mri_surf2surf", help.arg = "--help")
}