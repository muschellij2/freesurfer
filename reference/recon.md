# FreeSurfer Reconstruction Pipeline Functions

Functions to run FreeSurfer's cortical reconstruction pipeline with
varying levels of control and customization.

## Usage

``` r
recon_all(
  subjid = NULL,
  infile = NULL,
  outdir = NULL,
  verbose = get_fs_verbosity(),
  opts = "-all",
  ...
)

recon(
  subjid = NULL,
  infile = NULL,
  outdir = NULL,
  opts = "",
  options = recon_steps(),
  verbose = get_fs_verbosity()
)

recon_steps()
```

## Arguments

- subjid:

  subject id, if NULL, the basename of the infile will be used

- infile:

  Character; path to input file in DICOM or NIfTI format.

- outdir:

  Character, Path to output directory.

- verbose:

  (logical) print diagnostic messages

- opts:

  Character. Additional options to Freesurfer function.

- ...:

  Additional arguments passed to
  [`reconner()`](https://muschellij2.github.io/freesurfer/reference/reconner.md).

- options:

  Named list of logical values for `recon()`, specifying which pipeline
  steps to include. See `recon_steps()` for available options.

## Value

Result from [`base::system()`](https://rdrr.io/r/base/system.html) call,
typically exit status (0 = success).

## Details

### Pipeline Overview

The reconstruction pipeline performs:

1.  Motion correction and intensity normalization

2.  Skull stripping and subcortical segmentation

3.  White matter segmentation

4.  Surface generation (white and pial)

5.  Cortical parcellation and thickness calculation

### Processing Time

A full reconstruction typically takes 6-24 hours. Use
`opts = "-parallel"` for parallel processing if available.

### Output Location

Results stored in `$SUBJECTS_DIR/<subjid>/` with subdirectories: `mri/`,
`surf/`, `label/`, `stats/`

## Functions

- `recon_all()`: Run complete reconstruction pipeline with default
  settings

- `recon()`: Run reconstruction with step-by-step control

- `recon_steps()`: Get named vector of available reconstruction steps

## References

Dale et al. (1999) Neuroimage 9:179-194. Fischl et al. (1999) Neuroimage
9:195-207.

## See also

[`read_aseg_stats()`](https://muschellij2.github.io/freesurfer/reference/read_aseg_stats.md)
to read segmentation statistics
[`reconner()`](https://muschellij2.github.io/freesurfer/reference/reconner.md)
for low-level control of `recon-all`

## Examples

``` r
if (FALSE) { # have_fs()
if (FALSE) { # \dontrun{
# Full reconstruction with recon_all
recon_all(
  infile = "T1_scan.nii",
  subjid = "subject01",
  outdir = "~/freesurfer_output"
)

# Step-by-step control with recon
steps <- recon_steps()
steps["normalization"] <- FALSE
recon(
  infile = "T1_scan.nii",
  subjid = "subject02",
  options = steps
)

# Low-level control with reconner
reconner(
  infile = "T1_scan.nii",
  subjid = "subject03",
  opts = "-autorecon1 -parallel"
)
} # }
}
```
