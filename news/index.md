# Changelog

## freesurfer 1.8.1.900

### Deprecations

- [`readmgz()`](https://muschellij2.github.io/freesurfer/reference/read_mgz.md)
  is deprecated, use
  [`read_mgz()`](https://muschellij2.github.io/freesurfer/reference/read_mgz.md)
  instead
- [`readmgh()`](https://muschellij2.github.io/freesurfer/reference/read_mgz.md)
  is deprecated, use
  [`read_mgh()`](https://muschellij2.github.io/freesurfer/reference/read_mgz.md)
  instead
- [`set_fs_subj_dir()`](https://muschellij2.github.io/freesurfer/reference/set_fs_subj_dir.md)
  is deprecated, use `Sys.setenv(SUBJECTS_DIR = path)` or
  `options(freesurfer.subj_dir = path)` instead

### Bug Fixes

- Fix
  [`get_fs()`](https://muschellij2.github.io/freesurfer/reference/get_fs.md)
  returning a vector instead of a string when `add_home = FALSE`, which
  caused malformed commands
- Fix
  [`mri_mask()`](https://muschellij2.github.io/freesurfer/reference/mri_mask.md)
  argument order: now correctly passes `<input> <mask> <output>` to
  FreeSurfer

### Major Changes

- Consolidate MNC conversion functions:
  [`nii2mnc()`](https://muschellij2.github.io/freesurfer/reference/nii2mnc.md)
  and
  [`mnc2nii()`](https://muschellij2.github.io/freesurfer/reference/mnc2nii.md)
  now in single file with shared validation
- Consolidate trac functions:
  [`trac_all()`](https://muschellij2.github.io/freesurfer/reference/trac.md)
  and `trac_manual()` merged into `tracker.R`
- Refactor
  [`fs_cmd()`](https://muschellij2.github.io/freesurfer/reference/fs_cmd.md)
  with improved same-file handling and error checking
- New `check_fs_result()` for consistent FreeSurfer command result
  validation

### CLI Messaging

- New internal functions `fs_abort()`, `fs_warn()`, `fs_inform()`
  wrapping cli package
- Substitute `warning`, `stop`, `message` and `cat` with corresponding
  `cli` functions for more modern stdout and stderr output

### FreeSurfer Environment

- Add function
  [`fs_sitrep()`](https://muschellij2.github.io/freesurfer/reference/fs_sitrep.md)
  to check, verify and output information on FreeSurfer-R communication
- Refactor
  [`get_fs()`](https://muschellij2.github.io/freesurfer/reference/get_fs.md)
  with new `get_fs_*` functions for fine-grained control of each setting
- New roxygen2 template for consistent `fs_home` parameter documentation

### Wrapper Function Improvements

- Improve
  [`mri_convert()`](https://muschellij2.github.io/freesurfer/reference/mri_convert.md)
  with better format validation and error handling
- Improve
  [`mri_info()`](https://muschellij2.github.io/freesurfer/reference/mri_info.md),
  [`mri_mask()`](https://muschellij2.github.io/freesurfer/reference/mri_mask.md),
  [`mri_segment()`](https://muschellij2.github.io/freesurfer/reference/mri_segment.md),
  [`mri_watershed()`](https://muschellij2.github.io/freesurfer/reference/mri_watershed.md)
  with consistent patterns
- Improve
  [`mri_synthstrip()`](https://muschellij2.github.io/freesurfer/reference/mri_synthstrip.md)
  with better parameter handling
- Improve
  [`mris_convert()`](https://muschellij2.github.io/freesurfer/reference/mris_convert.md)
  family and
  [`mris_euler_number()`](https://muschellij2.github.io/freesurfer/reference/mris_euler_number.md)
  with better output handling
- Improve
  [`nu_correct()`](https://muschellij2.github.io/freesurfer/reference/nu_correct.md)
  with better MNC file handling
- Improve
  [`stats2table()`](https://muschellij2.github.io/freesurfer/reference/stats2table.md)
  with better error messages
- Improve
  [`surf_convert()`](https://muschellij2.github.io/freesurfer/reference/surf_convert.md)
  with better output parsing

### Read Functions

- Improve
  [`read_annotation()`](https://muschellij2.github.io/freesurfer/reference/read_annotation.md),
  [`read_aseg_stats()`](https://muschellij2.github.io/freesurfer/reference/read_aseg_stats.md),
  [`read_fs_table()`](https://muschellij2.github.io/freesurfer/reference/read_fs_table.md)
  with better error handling
- Improve
  [`read_fs_table()`](https://muschellij2.github.io/freesurfer/reference/read_fs_table.md)
  with separator auto-detection
- Improve `freesurfer_read3()` with better error messages

### Other Improvements

- Simplify management of common parameter information
- Creates containing folder of tempfiles if necessary
- Improved handling of running examples with
  [@examplesIf](https://github.com/examplesIf)
- Split single vignette into several smaller vignettes with more
  tutorial-like structure and language
  - Original vignette is saved as “paper.Rmd” and is ignored by R build
- Major test suite expansion: 801 tests with ~96% code coverage
- Remove duplicate code in utils.R

## freesurfer 1.8.0

- Adds `...` to all functions that call `fs_cmd`, to allow user control
  of [`system()`](https://rdrr.io/r/base/system.html).

## freesurfer 1.8.0

- Added `mri_synthstrip`.

## freesurfer 1.6.10

CRAN release: 2024-05-14

- Fixes for new `neurobase` - need new push to CRAN.

## freesurfer 1.6.8

CRAN release: 2020-12-08

- Fixing vignette for `fslr` checking.
- Fixing examples for Suggests.
- Added argument for requirement for license for `have_fs`,

## freesurfer 1.6.7

CRAN release: 2020-03-30

- Trying to fix `source` vs `.` when using Linux machines.
- Added checks for FSL in vignette.

## freesurfer 1.6.6

- Added `read_annotation` for reading annotation files.

## freesurfer 1.6.5

CRAN release: 2019-07-18

- Added some workarounds from the examples for different freesurfer
  versions.
- Fixed import with download.file

## freesurfer 1.6.3

- Added `mri_deface` to the NAMESPACE and capabilities.

## freesurfer 1.6.0

- Released to CRAN after major changes to the package.

- Added a `NEWS.md` file to track changes to the package.
