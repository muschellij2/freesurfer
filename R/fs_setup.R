#' Generate FreeSurfer Command Line Environment Setup
#'
#' This function generates a bash command string to set up the environment for using FreeSurfer.
#' It ensures the required FreeSurfer installation, license, and environment setup files are
#' validated and included in the command string. The function handles different FreeSurfer
#' binaries like `bin`, `mni/bin`, and others, while ensuring proper initialization of
#' the MNI environment if required.
#'
#' @param bin_app [character] A vector of options for the binary application directory.
#'   Possible options include:
#'   - `"bin"`: Default FreeSurfer binary directory.
#'   - `"mni/bin"`: Includes MNI initialization.
#'   - `""`: Base directory with no specific subdirectories.
#'
#' @return [character] A bash command string that includes environment setup for FreeSurfer.
#'   If the FreeSurfer environment or required configurations cannot be initialized, the function
#'   throws an error or issues a warning. On success, the returned string can be used directly
#'   in shell operations to load the FreeSurfer environment.
#'
#' @examplesIf have_fs()
#' # Generate a shell command to set up FreeSurfer with the default `bin`
#' get_fs(bin_app = "bin")
#'
#' # Generate a shell command to include MNI environment setup
#' get_fs(bin_app = "mni/bin")
#'
#' @seealso [get_fs_home()], [get_fs_license()], [get_fs_output()]
#' @export
get_fs = function(bin_app = c("bin", "mni/bin")) {
  fs_home_info <- get_fs_home(simplify = FALSE)
  freesurferdir <- fs_home_info$value
  cmd <- ""

  if (is.null(freesurferdir) || !fs_home_info$exists) {
    cli::cli_abort(
      "Can't find Freesurfer installation. Please set {.code FREESURFER_HOME} environment variable or {.code freesurfer.home} R option."
    )
  }

  # Check license
  if (!get_fs_license(simplify = FALSE)$exists && get_fs_verbosity()) {
    fs_warn(
      "Freesurfer is found, but no license file ({.path license.txt} or {.path .license}) found!"
    )
  }

  bin_app <- match.arg(bin_app)
  start_up_path <- file.path("${FREESURFER_HOME}", bin_app)
  add_home <- ifelse(
    grepl("Default", fs_home_info$source),
    TRUE,
    FALSE
  )

  # Handle MNI Perl startup if 'mni' is in bin_app
  if (grepl("mni", bin_app)) {
    start_up_path <- get_mni_bin(simplify = FALSE)
    start_up_path <- return_single(start_up_path)$value
    if (!is.na(start_up_path)) {
      cmd <- c(
        cmd,
        "export PERL5LIB=$PERL5LIB",
        sprintf("export MNI_DIR=%s", shQuote(start_up_path))
      )
    }
  }

  # Source FreeSurferEnv.sh
  sourcer <- get_fs_source(simplify = FALSE)

  sh_file_cmd <- ifelse(
    sourcer$exists,
    paste0(
      "source ",
      shQuote(sourcer$value),
      " || true ; "
    ), # Use || true to prevent shell from exiting on error
    ""
  )

  # Construct the main command string
  if (!add_home) {
    return(
      paste(c(cmd, sh_file_cmd), sep = "; ")
    )
  }

  paste(
    c(
      cmd,
      sprintf(
        "export FREESURFER_HOME=%s",
        shQuote(freesurferdir)
      ),
      sh_file_cmd,
      sprintf("export FSF_OUTPUT_FORMAT=%s", get_fs_output()),
      paste0(start_up_path, "/")
    ),
    collapse = "; ",
    sep = "; "
  )
}


#' @title Get Freesurfer's Directory
#' @description Finds the `FREESURFER_HOME` from system environment or
#' `getOption("freesurfer.home")` for location of Freesurfer functions and returns its value.
#' @return Character path to the Freesurfer home directory.
#' @aliases freesurfer_dir
#' @export
#' @examplesIf have_fs()
#'  freesurferdir()
#'  freesurfer_dir()
#'  fs_dir()
freesurferdir = function() {
  get_fs_home()
}

#' @rdname freesurferdir
#' @export
freesurfer_dir = freesurferdir


#' @rdname freesurferdir
#' @export
fs_dir = freesurferdir

#' @title Determine Freesurfer Subjects Directory
#' @description Finds the `SUBJECTS_DIR` from system environment or
#' `getOption("freesurfer.subj_dir")` and returns its value.
#' @return Character path to the Freesurfer subjects directory.
#' @export
#' @examplesIf have_fs()
#'    fs_subj_dir()
fs_subj_dir = function() {
  get_fs_subdir()
}

#' @title Logical check if Freesurfer is accessible
#' @description Checks if FreesurferDIR is accessible and optionally if a license file exists.
#' @param check_license [logical] Should a license file be checked for existence?
#' @return Logical `TRUE` if Freesurfer is accessible and license (if checked) is found, `FALSE` otherwise.
#' @export
#' @examples
#' have_fs()
have_fs = function(check_license = TRUE) {
  fs_home <- get_fs_home(simplify = FALSE)
  if (check_license) {
    lic <- get_fs_license(simplify = FALSE)
    return(fs_home$exists && lic$exists)
  }
  return(fs_home$exists)
}


#' @title Determine extension of image based on Freesurfer output type
#' @description Runs `get_fs_output()` to extract the Freesurfer output type
#' and then gets the corresponding file extension (such as `.nii.gz`).
#' @return Character string representing the file extension for the output type.
#' @export
#' @examples
#' fs_imgext()
fs_imgext = function() {
  switch(
    get_fs_output(),
    "hdr" = ".hdr",
    "nii.gz" = ".nii.gz",
    "nii" = ".nii"
  )
}
