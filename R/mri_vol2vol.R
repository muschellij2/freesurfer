#' Resample a Volume into Another Volume's Space with FreeSurfer
#'
#' Calls FreeSurfer's `mri_vol2vol` to resample the moving volume `mov` onto the
#' voxel grid of the target volume `targ`.
#'
#' @param mov Character; the moving volume to resample (`--mov`).
#' @param targ Character; the target volume whose grid to resample onto
#'   (`--targ`).
#' @param outfile Character; output volume (`--o`). Defaults to a temporary
#'   `.nii.gz` file.
#' @param reg Character; a registration file (`.lta`/`.dat`) mapping `mov` to
#'   `targ` (`--reg`), or the string `"header"` to derive the registration from
#'   the volumes' headers (`--regheader`).
#' @param interp Character; interpolation method (`--interp`): one of
#'   `"trilin"`, `"nearest"` or `"cubic"`.
#' @template opts
#' @template verbose
#' @param ... Additional arguments passed to [fs_flag_cmd()].
#'
#' @return The output filename, invisibly.
#' @seealso [fs_flag_cmd()] for the underlying flag-based command wrapper;
#'   [mri_convert()] for format conversion.
#' @name mri_vol2vol
#' @export
#'
#' @examplesIf have_fs()
#' \dontrun{
#' # Resample a parcellation into an aseg's space using the headers
#' mri_vol2vol(
#'   "parcellation.nii.gz", "aseg.mgz",
#'   reg = "header", interp = "nearest"
#' )
#' }
mri_vol2vol <- function(
  mov,
  targ,
  reg,
  outfile = NULL,
  interp = c("trilin", "nearest", "cubic"),
  opts = "",
  verbose = get_fs_verbosity(),
  ...
) {
  interp <- match.arg(interp)
  if (is.null(outfile)) {
    outfile <- temp_file(fileext = ".nii.gz")
  }
  if (missing(reg) || is.null(reg)) {
    cli::cli_abort(
      "Supply {.arg reg}: a registration file, or {.val header} (--regheader)."
    )
  }
  header <- identical(reg, "header")

  fs_flag_cmd(
    func = "mri_vol2vol",
    args = list(
      mov = mov,
      targ = targ,
      reg = if (header) NULL else reg,
      regheader = header,
      interp = interp,
      o = outfile
    ),
    outfile = outfile,
    opts = opts,
    verbose = verbose,
    ...
  )
}

#' @describeIn mri_vol2vol Display FreeSurfer help for mri_vol2vol
#' @param ... Additional arguments passed to [fs_help()]
#' @export
mri_vol2vol.help <- function(...) {
  fs_help("mri_vol2vol", ...)
}
