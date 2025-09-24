#' Create a Temporary File with a Newly Created Directory
#'
#' The `temp_file` function generates a temporary file path and ensures
#' that the directory containing the file exists by creating it if necessary.
#'
#' @param ... Arguments passed to the \code{\link{tempfile}} function, typically
#'        used to customize the prefix, suffix, or pattern of the
#'        temporary file name.
#'
#' @return A character string representing the full file path to the
#'         temporary file. The directory containing the file will be
#'         created if it does not already exist.
#'
#' @details This function leverages \code{\link{tempfile}} to create a unique
#'          file path within the system's temporary directory. Before
#'          returning the file path, it ensures any required
#'          directories are created using the \code{\link{dir.create}} function.
#'
#' @examples
#' # Create a temporary file and its directory
#' file_path <- temp_file(pattern = "example_")
#'
#' # Print the file path
#' print(file_path)
#'
#' # Check if the directory exists
#' dir.exists(dirname(file_path))
#'
#' @export
temp_file <- function(...) {
  x <- tempfile(...)
  mkdir(dirname(x))
  x
}

#' utility to silently create directories
#' @noRd
mkdir <- function(path) {
  dir.create(
    path,
    showWarnings = FALSE,
    recursive = TRUE
  )
}

#' Check if a file path exists
#' @noRd
check_path <- function(path, error = TRUE) {
  x <- file.exists(path)
  if (error && !x) {
    cli::cli_abort("File {.path {path}} does not exist")
  }
  x
}

check_outfile <- function(outfile, retimg, fileext = ".nii.gz") {
  if (retimg && is.null(outfile)) {
    return(tempfile(fileext = fileext))
  }

  if (is.null(outfile)) {
    cli::cli_abort(
      "Outfile is {.code NULL}, and {.code retimg = FALSE}, one of these must be changed"
    )
  }

  path.expand(outfile)
}

#' Execute a System Command with Error Handling
#'
#' This function executes a system command using `system()` and handles potential
#' errors gracefully by capturing and reporting them in a user-friendly way.
#'
#' @param ... Additional arguments passed to the `system()` function for
#'   customization of command execution (e.g., `input`, `show.output.on.console`,
#'   `wait`, etc.).
#' @param intern Logical. If `TRUE` (default), the output of the command will be
#'   captured and returned as a character vector. If `FALSE`, the output is
#'   printed directly to the console.
#' @param env Environment. The environment where the error message is evaluated.
#'   Defaults to `parent.frame()`.
#'
#' @return The function returns the result of the `system()` call if successful.
#'   If `intern = TRUE`, this is a character vector containing the command output.
#'   If `intern = FALSE`, the return value is invisible, and the output is
#'   directly displayed in the console.
#'
#' @examples
#' \dontrun{
#' # Run a simple system command and capture its output
#' result <- try_cmd("ls", intern = TRUE)
#' print(result)
#'
#' # Run a system command that intentionally fails
#' try_cmd("nonexistent_command", intern = TRUE)
#' # This will gracefully handle the error and output an informative message.
#' }
#' @noRd
try_cmd <- function(..., intern = TRUE, env = parent.frame()) {
  tryCatch(
    system(..., intern = intern),
    error = function(e) {
      cli::cli_abort(
        "Error while running system command:",
        .envir = env
      )
    }
  )
}
