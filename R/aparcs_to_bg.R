#' @title Convert Freesurfer aparcs Table to brainGraph
#' @description Converts Freesurfer aparcs table to brainGraph naming
#' convention, relying on \code{\link{aparcstats2table}}
#'
#' @param subjects subjects to analyze, 
#' passed to \code{\link{aparcstats2table}}
#' @param measure measure to be analyzed, 
#' passed to \code{\link{aparcstats2table}}
#' @param ... additional arguments passed to \code{\link{aparcstats2table}}
#'
#' @return Long \code{data.frame}
#' @export
#' @importFrom reshape2 melt
#' @examples
#' if (have_fs()) {
#'    fs_subj_dir() 
#'    df = aparcs_to_bg(subjects = "bert", measure = "thickness")
#'    print(head(df))
#' }
aparcs_to_bg = function(subjects, 
                        measure,
                        ...) {
  file = aparcstats2table(subjects = subjects , 
                          measure = measure, ...)
  # nstart = substr(hemi, 1, 1)
  tab = read_fs_table(file)
  
  x = colnames(tab)
  x = gsub("[.]", "_", x)
  x = gsub(paste0("_", measure), "", x)
  x = gsub("lh_", "l", x)
  x = gsub("rh_", "r", x)
  x = gsub("bankssts", "BSTS", x)
  x = gsub("caudalanteriorcingulate", "cACC", x)
  x = gsub("caudalmiddlefrontal", "cMFG", x)
  x = gsub("precuneus", "PCUN", x)
  x = gsub("cuneus", "CUN", x)
  x = gsub("entorhinal", "ENT", x)
  x = gsub("fusiform", "FUS", x)
  x = gsub("inferiorparietal", "IPL", x)
  x = gsub("inferiortemporal", "ITG", x)
  x = gsub("isthmuscingulate", "iCC", x)
  x = gsub("lateraloccipital", "LOG", x)
  x = gsub("lateralorbitofrontal", "LOF", x)
  x = gsub("lingual", "LING", x)
  x = gsub("medialorbitofrontal", "MOF", x)
  x = gsub("middletemporal", "MTG", x)
  x = gsub("parahippocampal", "PARH", x)
  x = gsub("paracentral", "paraC", x)
  x = gsub("parsopercularis", "pOPER", x)
  x = gsub("parsorbitalis", "pORB", x)
  x = gsub("parstriangularis", "pTRI", x)
  x = gsub("pericalcarine", "periCAL", x)
  x = gsub("postcentral", "postC", x)
  x = gsub("posteriorcingulate", "PCC", x)
  x = gsub("precentral", "preC", x)
  x = gsub("rostralanteriorcingulate", "rACC", x)
  x = gsub("rostralmiddlefrontal", "rMFG", x)
  x = gsub("superiorfrontal", "SFG", x)
  x = gsub("superiorparietal", "SPL", x)
  x = gsub("superiortemporal", "STG", x)
  x = gsub("supramarginal", "SMAR", x)
  x = gsub("frontalpole", "FP", x)
  x = gsub("temporalpole", "TP", x)
  x = gsub("transversetemporal", "TT", x)
  x = gsub("insula", "INS", x)
  x = gsub("_div", "", x)
  x = gsub("L[.]", "l", x)
  x = gsub("R[.]", "r", x)
  x = gsub("Thalamus.Proper", "THAL", x)
  x = gsub("Putamen", "PUT", x)
  x = gsub("Pallidum", "PALL", x)
  x = gsub("Caudate", "CAUD", x)
  x = gsub("Hippocampus", "HIPP", x)
  x = gsub("Amygdala", "AMYG", x)
  x = gsub("Accumbens.area", "ACCU", x)
  
  colnames(tab) = x 
  x = x[ !grepl("Mean", x)]
  tab = tab[, x]
  id.vars = x[1]
  ltab = reshape2::melt(tab, id.vars= id.vars)  
  colnames(ltab) = c("id", "name", measure)
  return(ltab)
}