#' @name checkmnc-methods
#' @docType methods 
#' @aliases checkmnc
#' @description Ensures the output to be a character filename (or vector) 
#' from an input image or \code{nifti} to have \code{.mnc} extension and
#' be converted to MNC when necessary
#' 
#' @title Force object to filename with .mnc extension
#' @param file character or \code{nifti} object
#' @param ... options passed to \code{\link[neurobase]{checkimg}}
#' @return Character filename of mnc image
#' 
#' @export
#' @import methods
#' @author John Muschelli \email{muschellij2@@gmail.com}
setGeneric("checkmnc", function(file, ...) standardGeneric("checkmnc"))

#' @rdname checkmnc-methods
#' @aliases checkmnc,nifti-method
#' @importFrom neurobase checkimg
#' @export
setMethod("checkmnc", "nifti", function(file, ...) { 
  file = neurobase::checkimg(file, gzipped = FALSE, ...)
  outfile = tempfile(fileext = ".mnc")
  outfile = nii2mnc(file, outfile)
  return(outfile)
})

#' @rdname checkmnc-methods
#' @aliases checkmnc,character-method
#' @importFrom R.utils gzip
#'  
#' @export
setMethod("checkmnc", "character", function(file, ...) { 
  ### add vector capability
  if (length(file) > 1) {
    file = sapply(file, checkmnc, ...)
    return(file)
  } else {
    file = checkimg(file, gzipped = FALSE, ...)
    ext = neurobase::parse_img_ext(file)
    if ( !(ext %in% c("nii", "mnc"))) {
      stop("File extension must be nii/nii.gz or mnc")
    }
    if (ext %in% c("nii")) {
      file = nii2mnc(file, outfile = NULL)
    }
  } 
  return(file)
})


#' @rdname checkmnc-methods
#' @aliases checkmnc,list-method
#' @export
setMethod("checkmnc", "list", function(file, ...) { 
  ### add vector capability
  file = sapply(file, checkmnc, ...)
  return(file)
})

#' @rdname checkmnc-methods
#' @aliases ensure_mnc
#' @export
ensure_mnc = function(file, ...) { 
  checkmnc(file = file, ...)
}