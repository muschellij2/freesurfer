# freesurfer 1.8.1.900

- Simplify management of common parameter information
- Creates containing folder of tempfiles if necessary
- Improved handling of running examples with @examplesIf
- Split single vignette into several smaller vignettes with more tutorial like sctructure and language.
  - Original vignette is saved as "paper.Rmd" and is ignored by R build.
- Add function `fs_sitrep()` whose intent is to check, verify and output information on Freesurfer-R communication for the user.
- Refactor of `get_fs()` as a result of `fs_sitrep()` and the need to consolidate how to check for Freesurfer system setup.
  - New `get_fs_*` functions underlie both the approaches and provide more fine grained control for each setting.
- Substitute `warning`, `stop`, `message` and `cat` with corresponding `cli` functions for more modern stdout and stderr output.

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
