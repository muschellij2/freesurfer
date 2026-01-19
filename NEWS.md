# freesurfer 1.8.1.900

## General Changes

- Consolidate MNC conversion functions: `nii2mnc()` and `mnc2nii()` now in single file with shared validation
- Consolidate trac functions: `trac_all()` and `trac_manual()` merged into `tracker.R`
- Refactor `fs_cmd()` with improved same-file handling and error checking
- New `check_fs_result()` for consistent FreeSurfer command result validation

## CLI Messaging

- New internal functions `fs_abort()`, `fs_warn()`, `fs_inform()` wrapping cli package
- Substitute `warning`, `stop`, `message` and `cat` with corresponding `cli` functions for more modern stdout and stderr output

## FreeSurfer Environment

- Add function `fs_sitrep()` to check, verify and output information on FreeSurfer-R communication
- Refactor `get_fs()` with new `get_fs_*` functions for fine-grained control of each setting
- New roxygen2 templates for consistent parameter documentation

## Other Improvements

- Simplify management of common parameter information
- Creates containing folder of tempfiles if necessary
- Improved handling of running examples with @examplesIf
- Split single vignette into several smaller vignettes with more tutorial-like structure and language
  - Original vignette is saved as "paper.Rmd" and is ignored by R build
- Major test suite expansion: 803 tests with ~96% code coverage
- Remove duplicate code in utils.R

# freesurfer 1.8.0

- Adds `...` to all functions that call `fs_cmd`, to allow user control of `system()`.

# freesurfer 1.8.0

- Added `mri_synthstrip`.

# freesurfer 1.6.10

- Fixes for new `neurobase` - need new push to CRAN.

# freesurfer 1.6.8

- Fixing vignette for `fslr` checking.
- Fixing examples for Suggests.
- Added argument for requirement for license for `have_fs`,

# freesurfer 1.6.7

- Trying to fix `source` vs `.` when using Linux machines.
- Added checks for FSL in vignette.

# freesurfer 1.6.6

- Added `read_annotation` for reading annotation files.

# freesurfer 1.6.5

- Added some workarounds from the examples for different freesurfer versions.
- Fixed import with download.file

# freesurfer 1.6.3

- Added `mri_deface` to the NAMESPACE and capabilities.

# freesurfer 1.6.0

- Released to CRAN after major changes to the package.

- Added a `NEWS.md` file to track changes to the package.
