

#' @title Read Anatomical Segmentation Statistics
#' @description Reads an \code{aseg.stats} file from an individual subject
#' 
#' @param file aseg.stats file from Freesurfer
#'
#' @return List of 2 \code{data.frame}s, one with the global measures and one 
#' with the structure-specific measures.
#' @export
#'
#' @examples
#' if (have_fs()) {
#'  file = file.path(fs_subj_dir(), "bert", "stats", "aseg.stats")
#'  out = read_aseg_stats(file)
#' }
read_aseg_stats = function(file) {
  rl = readLines(file)
  start_subj =  grep("^# subjectname", rl)
  n_rl = length(rl)
  rl = rl[seq(start_subj, n_rl)]
  
  ###############################################
  # Parse the measures table
  ###############################################   
  meas = rl[grep("^# Measure", rl)]
  
  vals = strsplit(meas, ",")
  vals = lapply(vals, trimws)
  vals = sapply(vals, function(x){
    x = gsub("^# Measure", "", x)
    x = trimws(x)
    x = tolower(x)
    return(x)
  })
  vals = t(vals)
  vals = as.data.frame(vals, stringsAsFactors = FALSE)
  colnames(vals) = c("measure", "measure_long", "meaning", "value", "units")
  
  ###############################################
  # Read in the structure-level table
  ###############################################  
  start_subj =  grep("^# ColHeaders", rl)
  n_rl = length(rl)
  rl = rl[seq(start_subj, n_rl)]
  hdr = rl[1]
  hdr = gsub("^# ColHeaders", "", hdr)
  hdr = trimws(hdr)
  hdr = gsub("\\s+", " ", hdr)
  hdr = strsplit(hdr, " ")[[1]]
  
  tab = rl[-1]
  tab = trimws(tab)
  tab = gsub("\\s+", " ", tab)
  tab = strsplit(tab, " ")
  tab = do.call("rbind", tab)
  
  tab = data.frame(tab, 
                   stringsAsFactors = FALSE)
  colnames(tab) = hdr
  
  num_cols = setdiff(hdr, "StructName")
  for (icol in num_cols) {
    tab[, icol] = as.numeric(tab[, icol])
  }
  
  L = list(measures = vals,
           structures = tab)
  
  return(L)
  # out = surf_convert(file)
  # read_stats = function(file) {
  
  
}