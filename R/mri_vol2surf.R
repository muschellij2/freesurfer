#' @title Use Freesurfers \code{mri_vol2surf} function to 
#' project a 3D volume to a surface
#' @description This function calls Freesurfer \code{mri_vol2surf} to 
#' project a 3D volume to a surface
#' @param mov (character) input volume filename
#' @param outfile (character) output filename
#' @param hemi (character) hemisphere to run statistics
#' @param target_subject (character) vector of target subject name 
#' @param subj_dir (character path) if a different subjects directory
#' is to be used other than \code{SUBJECTS_DIR} from shell, it can be
#' specified here.  Use with care as if the command fail, it may not reset
#' the \code{SUBJECTS_DIR} back correctly after the error
#' @param opts (character) additional options to \code{mri_vol2surf}
#' @param verbose (logical) print diagnostic messages
#' @return Name of output file
#' @export
#' @examples 
#' if (have_fs()) {
#'    out = mri_vol2surf(
#'    mov = '/src/Template/MNI152_T1_1mm_brain.nii.gz'
#'    target_subject = 'fsaverage5',
#'    opts = "--interp trilinear"
#'    outfile = '/data/out.surf.nii.gz'
#'    hemi = "lh")
#' } 
mri_vol2surf = function(
  mov = NULL,
  target_subject = NULL, 
  outfile = NULL,
  hemi = c("lh", "rh"),
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
  # Making Target Subject 
  ###########################  
  target_subject = paste0("--regheader ", target_subject)
  args = c(args, target_subject)

  ###########################
  # Input volume
  ###########################  
  mov = paste0("--mov ", mov)
  args = c(args, mov)

  args = c(args, "--mni152reg ")
  
  ###########################
  # Making output file if not specified
  ###########################    
  if (is.null(outfile)) {
    outfile = tempfile()
  }
  outfile = file.path(dirname(outfile), 
                      paste0(xhemi, ".", basename(outfile)))
  args = c(args, paste0("--o ", outfile))
  
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
  cmd = paste0(get_fs(), "mri_vol2surf")
  cmd = paste0(cmd_pre, cmd)
  
  args = paste(args, collapse = " ")
  cmd = paste(cmd, args)
  cmd = paste(cmd, opts)
  
  run_check_fs_cmd(cmd = cmd, outfile = outfile, verbose = verbose)
  
  return(outfile)
}


#' @title Freesurfers mri_vol2surf Help
#' @description This calls Freesurfer's \code{mri_vol2surf} help 
#'
#' @return Result of \code{fs_help}
#' @export
mri_vol2surf.help = function(){
  fs_help(func_name = "mri_vol2surf", help.arg = "--help")
}