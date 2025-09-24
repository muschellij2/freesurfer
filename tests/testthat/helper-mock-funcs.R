# Mock functions used in several test files
# to simulate file operations and avoid actual file system dependencies
# Mock functions used in single files are defined within those files

mock_get_fs <- function() "mock_fs/"

mock_try_fs_cmd <- function(cmd) {
  # Simulate system commands, errors, or results
  if (grepl("error", cmd)) {
    fs_abort("Command error")
  }
  return(TRUE)
}

mock_checknii <- function(infile) {
  if (!file.exists(infile)) {
    fs_abort("File does not exist")
  }
  return(infile)
}

mock_check_path <- function(file) {
  if (!file.exists(file)) {
    fs_abort("File does not exist")
  }
}

mock_readnii <- function(file) {
  if (!file.exists(file)) {
    fs_abort("File does not exist for readnii")
  }
  return("Mock NIfTI Object")
}

mock_mri_convert <- function(input, output, ...) {
  if (!file.exists(input)) {
    fs_abort("Input file does not exist for mri_convert")
  }
  writeLines("Mock NIfTI data", output)
}
