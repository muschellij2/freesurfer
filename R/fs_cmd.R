#' Execute FreeSurfer Commands from R
#'
#' @description
#' `fs_cmd()` is the core wrapper function that executes FreeSurfer command-line
#' tools from within R. It handles file path validation, command construction,
#' execution, and optional return of neuroimaging data as nifti objects.
#'
#' @details
#' This function provides a unified interface to FreeSurfer's command-line tools,
#' with several key features:
#'
#' * Automatic validation of input/output files
#' * Support for nifti objects as inputs
#' * Optional timeout for long-running commands
#' * Flexible command option placement
#' * Automatic result verification
#' * Integration with FreeSurfer environment setup
#'
#' ## Overwriting Files
#' To overwrite the input file, set `outfile = file`. A warning will be
#' displayed for safety. The function checks file existence before and after
#' command execution to verify successful completion.
#'
#' ## Command Construction
#' The command is constructed in the following order:
#' 1. FreeSurfer environment setup (from `get_fs()`)
#' 2. Command name (`func`)
#' 3. Front options (`frontopts`)
#' 4. Input file path (quoted)
#' 5. Output file path (quoted, if provided)
#' 6. Additional options (`opts`)
#'
#' Use `opts_after_outfile = TRUE` to place `opts` after the output file.
#'
#' @param func Character string specifying the FreeSurfer command to execute
#'   (e.g., `"mri_convert"`, `"mri_watershed"`).
#' @param file Character path to the input image file, or a nifti object.
#'   If a nifti object is provided, it will be temporarily written to disk.
#' @param outfile Character path to the output image file. If `NULL` (default),
#'   and `retimg = TRUE`, a temporary file will be created. Set `outfile = file`
#'   to overwrite the input file (with warning).
#' @param retimg Logical; if `TRUE` (default), returns output as a nifti object.
#'   If `FALSE`, returns the system command result.
#' @param reorient Logical; if `TRUE` and `retimg = TRUE`, reorients the image
#'   when loading. Passed to [neurobase::readnii()]. Default is `FALSE`.
#' @param intern Logical; if `TRUE`, captures command output. Passed to
#'   [base::system()]. Default is `FALSE`.
#' @template opts
#' @template verbose
#' @param opts_after_outfile Logical; if `TRUE`, places `opts` after `outfile`
#'   in the command string. Default is `FALSE`.
#' @param frontopts Character string of options to prepend before the input
#'   file in the command. Default is `""`.
#' @param bin_app Character string specifying the FreeSurfer bin directory
#'   appendix. Options are `"bin"` (default) or `"mni/bin"`.
#' @param timeout_seconds Numeric; command timeout in seconds. If specified,
#'   requires the \pkg{R.utils} package. Default is `NULL` (no timeout).
#' @param validate_inputs Logical; if `TRUE` (default), validates that input
#'   files exist before running the command.
#' @param ... Additional arguments passed to [base::system()].
#'
#' @return
#' If `retimg = TRUE`: A nifti object containing the output image, or `NULL`
#' if output creation failed. If `retimg = FALSE`: The result from
#' [base::system()], typically the exit status or captured output.
#'
#' @seealso
#' [get_fs()] for FreeSurfer environment setup,
#' [mri_convert()] for format conversion,
#' [neurobase::readnii()] for reading nifti files
#'
#' @export
#'
#' @examplesIf have_fs()
#' \dontrun{
#' # Basic usage: convert MGZ to NIfTI
#' fs_cmd(
#'   func = "mri_convert",
#'   file = "input.mgz",
#'   outfile = "output.nii.gz",
#'   opts = "--conform"
#' )
#'
#' # Return as nifti object
#' img <- fs_cmd(
#'   func = "mri_convert",
#'   file = "input.mgz",
#'   retimg = TRUE
#' )
#'
#' # Use nifti object as input
#' library(oro.nifti)
#' img <- nifti(array(rnorm(10*10*10), dim = c(10, 10, 10)))
#' result <- fs_cmd(
#'   func = "mri_convert",
#'   file = img,
#'   outfile = "output.nii.gz"
#' )
#' }
#'
#' @importFrom neurobase checkimg readnii writenii
#' @importFrom cli cli_code
fs_cmd <- function(
  func,
  file,
  outfile = NULL,
  retimg = TRUE,
  reorient = FALSE,
  verbose = get_fs_verbosity(),
  intern = verbose,
  opts = "",
  opts_after_outfile = FALSE,
  frontopts = "",
  bin_app = "bin",
  timeout_seconds = NULL,
  validate_inputs = TRUE,
  ...
) {
  # Simple validation
  validate_fs_env(check_license = FALSE)

  # Handle nifti objects
  if (inherits(file, "nifti")) {
    temp_input <- temp_file(fileext = ".nii.gz")
    neurobase::writenii(file, filename = temp_input)
    file <- temp_input
    on.exit(unlink(temp_input), add = TRUE)
  } else if (validate_inputs) {
    file <- validate_fs_inputs(file, must_exist = TRUE)
  } else {
    file <- neurobase::checkimg(file)
  }

  # Validate and prepare output file
  outfile <- validate_outfile(outfile, retimg = retimg)

  # Warn if input and output are the same
  if (
    !is.null(outfile) &&
      length(file) == 1 &&
      file == outfile
  ) {
    fs_warn(
      "Input and output files are identical - file will be overwritten",
      details = paste("File:", outfile)
    )
  }

  file <- normalizePath(file, mustWork = FALSE)
  outfile <- normalizePath(
    outfile,
    mustWork = FALSE
  )

  # Check output file existence before command
  fe_before <- if (!is.null(outfile)) file.exists(outfile) else FALSE

  # Build command string
  fs_prefix <- get_fs(bin_app = bin_app)
  cmd_parts <- paste0(fs_prefix, func)

  if (nzchar(frontopts)) {
    cmd_parts <- c(cmd_parts, frontopts)
  }

  # Add input file (quoted to handle spaces)
  cmd_parts <- c(cmd_parts, shQuote(file))

  # Add outfile and opts based on placement preference
  if (!is.null(outfile)) {
    if (!opts_after_outfile) {
      cmd_parts <- c(cmd_parts, shQuote(outfile))
      if (nzchar(opts)) cmd_parts <- c(cmd_parts, opts)
    } else {
      if (nzchar(opts)) {
        cmd_parts <- c(cmd_parts, opts)
      }
      cmd_parts <- c(cmd_parts, shQuote(outfile))
    }
  } else if (nzchar(opts)) {
    cmd_parts <- c(cmd_parts, opts)
  }

  cmd <- paste(cmd_parts, collapse = " ")

  # Print command if verbose
  if (verbose) {
    cli::cli_code(cmd)
  }

  # Execute command
  res <- try_fs_cmd(
    cmd,
    context = paste("FreeSurfer", func, "command"),
    timeout_seconds = timeout_seconds,
    intern = intern,
    ...
  )

  # Check output file existence after command
  fe_after <- if (!is.null(outfile)) file.exists(outfile) else FALSE

  # Use unified result checking
  if (!is.null(outfile)) {
    check_fs_result(
      res = res,
      fe_before = fe_before,
      fe_after = fe_after,
      outfile = outfile,
      func_name = func
    )
  }

  # Return appropriate result
  if (retimg && !is.null(outfile)) {
    if (fe_after) {
      return(neurobase::readnii(
        outfile,
        reorient = reorient
      ))
    } else {
      fs_warn("Cannot return image - output file was not created")
      return(NULL)
    }
  }

  return(res)
}

#' Execute system command with minimal wrapper
#' @param cmd Command to execute
#' @param context Description of command
#' @param timeout_seconds Timeout in seconds (optional)
#' @param ... Additional arguments passed to system()
#' @return Result of system command
#' @noRd
try_fs_cmd <- function(
  cmd,
  context = NULL,
  timeout_seconds = NULL,
  verbose = get_fs_verbosity(),
  intern = verbose,
  ...
) {
  ignore_out <- !isTRUE(intern) && !isTRUE(verbose)

  # Helper to call system with appropriate ignore flags
  call_system <- function() {
    system(
      cmd,
      intern = intern,
      ignore.stdout = ignore_out,
      ignore.stderr = ignore_out,
      ...
    )
  }

  # Use timeout if requested and available
  if (
    !is.null(timeout_seconds) && requireNamespace("R.utils", quietly = TRUE)
  ) {
    return(R.utils::withTimeout(
      call_system(),
      timeout = timeout_seconds,
      onTimeout = "error"
    ))
  }

  if (!is.null(timeout_seconds)) {
    fs_warn("Timeout requested but R.utils not available")
  }

  call_system()
}
