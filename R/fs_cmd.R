#' @title FS Command Wrapper
#' @description This function calls Freesurfer command passed to \code{func}
#' @param func (character) Freesurfer function
#' @param file (character) image to be manipulated
#' @param outfile (character) resultant image name (optional)
#' @param retimg (logical) return image of class nifti
#' @param reorient (logical) If retimg, should file be reoriented when read in?
#' Passed to \code{\link[neurobase]{readnii}}.
#' @param intern (logical) to be passed to \code{\link{system}}
#' @param opts (character) operations to be passed to \code{func}
#' @param verbose (logical) print out command before running
#' @param samefile (logical) is the output the same file?
#' @param opts_after_outfile (logical) should \code{opts} come after
#' the \code{outfile} in the Freesurfer command?
#' @param frontopts (character) options/character to put in before filename
#' @param add_ext (logical) should the extension be added to
#' the \code{outfile}
#' @param bin_app (character) appendix to add to \code{\link{get_fs}}
#' @param ... additional arguments passed to \code{\link{system}}.
#' @return If \code{retimg} then object of class nifti.  Otherwise,
#' Result from system command, depends if intern is TRUE or FALSE.
#' @importFrom neurobase checkimg check_outfile readnii nii.stub
#' @export
fs_cmd = function(
  func,
  file,
  outfile = NULL,
  retimg = TRUE,
  reorient = FALSE,
  intern = FALSE,
  opts = "",
  verbose = TRUE,
  samefile = FALSE,
  opts_after_outfile = FALSE,
  frontopts = "",
  add_ext = TRUE,
  bin_app = "bin",
  ...
) {
  cmd = get_fs(bin_app = bin_app)
  file = checkimg(file, ...)
  # file = path.expand(file)

  ##########################
  # Add frontopts
  ##########################
  s = sprintf('%s %s ', func, frontopts)
  s = gsub("\\s\\s+", " ", s)
  s = sub("[ \t\r\n]+$", "", s, perl = TRUE)
  s = paste(s, sprintf('"%s"', file))
  cmd <- paste0(cmd, s)
  # cmd <- paste0(cmd, sprintf('%s "%s"', func, file))

  no.outfile = is.null(outfile)
  if (no.outfile & samefile) {
    outfile = ""
  }
  ext = fs_imgext()
  outfile = check_outfile(outfile = outfile, retimg = retimg, fileext = ext)
  if (add_ext) {
    outfile = nii.stub(outfile)
    outfile = paste0(outfile, ext)
  }

  if (!(no.outfile & samefile)) {
    if (!opts_after_outfile) {
      cmd <- paste(cmd, sprintf(' %s "%s";', opts, outfile))
    } else {
      cmd <- paste(cmd, sprintf(' "%s" %s;', outfile, opts))
    }
  } else {
    cmd <- paste(cmd, sprintf(' %s;', opts))
  }
  if (verbose) {
    message(cmd, "\n")
  }
  res = system(cmd, intern = intern, ...)
  if (retimg) {
    if (samefile) outfile = file
    img = readnii(outfile, reorient = reorient)
    return(img)
  }

  return(res)
}
