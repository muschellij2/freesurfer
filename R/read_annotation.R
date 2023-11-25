#' Read Freesurfer annotation file
#'
#' Reads Freesurfer binary annotation files
#' that contain information on vertex labels
#' and colours for use in analyses and
#' brain area lookups. 
#' 
#' This function is heavily
#' based on Freesurfer's read_annotation.m
#' Original Author: Bruce Fischl
#' CVS Revision Info:
#'     $Author: greve $
#'     $Date: 2014/02/25 19:54:10 $
#'     $Revision: 1.10 $
#' 
#' @param path path to annotation file, usually with extension \code{annot}
#' @param verbose logical. 
#'
#' @return list of 3 with vertices, labels, and colortable
#' @export
#' @examples 
#' if (have_fs()) {
#'     bert_dir = file.path(fs_subj_dir(), "bert")
#'     annot_file = file.path(bert_dir, "label", "lh.aparc.annot")
#'     res = read_annotation(annot_file)
#' } 
read_annotation <- function(path, verbose = TRUE){
  
  # indicate this is binary
  ff <- file(path, "rb")
  on.exit(close(ff))
  
  annot <- readBin(ff, integer(), endian = "big")
  
  tmp <- readBin(ff, integer(), n=2*annot, endian = "big")
  
  vertices <- tmp[seq(1, by=2, length.out = length(tmp)/2)]
  label <- tmp[seq(2, by=2, length.out = length(tmp)/2)]
  
  bool <- readBin(ff, integer(), endian = "big")
  if(length(bool) == 0 || is.null(bool)){
    colortable <- data.frame(matrix(NA, ncol=6, nrow = 0))
    names(colortable) <- c("label", "R", "G", "B", "A", "code")
    if(verbose) cat('No colortable in file.\n')
    
  }else if(bool == 1){
    
    # Read colortable
    numEntries <- readBin(ff, integer(), endian = "big")
    
    if(numEntries > 0){
      
      if(verbose) cat('Reading from Original Version\n')
      
    } else { # if (! numEntries > 0)
      
      version <- -numEntries
      
      if(verbose){
        if(version != 2){    
          cat('Error! Does not handle version', version, '\n')
          return()
        }else{
          cat('Reading from version', version, '\n')
        }
      }
    }
    
    numEntries <- readBin(ff, integer(), endian = "big")
    colortable.numEntries <- numEntries;
    len <- readBin(ff, integer(), endian = "big")
    
    colortable.orig_tab <- readBin(ff, character(), n = 1, endian = "big")
    colortable.orig_tab <- t(colortable.orig_tab)
    
    numEntriesToRead <- readBin(ff, integer(), endian = "big")
    
    colortable <- data.frame(matrix(NA, ncol=6, nrow = numEntriesToRead))
    names(colortable) <- c("label", "R", "G", "B", "A", "code")
    
    for(i in 1:numEntriesToRead){
      
      structure <- readBin(ff, integer(), endian = "big") + 1
      
      if (structure < 0 & verbose) cat(paste('Error! Read entry, index', structure, '\n'))
      
      if( (structure %in% colortable$label) & verbose) 
        cat('Error! Duplicate Structure', structure, '\n')
      
      len <- readBin(ff, integer(), endian = "big")
      colortable$label[structure] = t( readBin(ff, character(), n = 1, endian = "big"))
      
      colortable$R[structure] <- readBin(ff, integer(), endian = "big")
      colortable$G[structure] <- readBin(ff, integer(), endian = "big")
      colortable$B[structure] <- readBin(ff, integer(), endian = "big")
      colortable$A[structure] <- readBin(ff, integer(), endian = "big")
      
      colortable$code[structure] <- colortable$R[structure] + 
        colortable$G[structure]*2^8 + 
        colortable$B[structure]*2^16;
    } # for i
    
    if(verbose){ 
      cat('colortable with', colortable.numEntries, 
          'entries read (originally', colortable.orig_tab, ')\n')
    }
  }else{
    if(verbose) cat('Error! Should not be expecting bool == 0\n')   
    stop(call. = FALSE)
  }
  
  # This makes it so that each empty entry at least has a string, even
  # if it is an empty string. This can happen with average subjects.
  if( any(is.na(colortable$label))){
    colortable$label[is.na(colortable$label)] = ""
  }
  
  return(
    list(vertices = vertices,
         label = label,
         colortable = colortable)
  )
}
