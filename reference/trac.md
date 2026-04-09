# FreeSurfer Diffusion Tractography Pipeline

These functions provide wrappers for FreeSurfer's `trac-all` command,
which performs automated reconstruction of diffusion pathways.

## Usage

``` r
tracker(
  infile = NULL,
  outdir = NULL,
  subjid = NULL,
  verbose = get_fs_verbosity(),
  opts = ""
)

trac_all(
  infile = NULL,
  outdir = NULL,
  subjid = NULL,
  verbose = get_fs_verbosity(),
  opts = ""
)

trac_prep(infile, outdir = NULL, subjid, verbose = get_fs_verbosity())

trac_bedpost(infile, outdir = NULL, subjid, verbose = get_fs_verbosity())

trac_path(infile, outdir = NULL, subjid, verbose = get_fs_verbosity())

tracker.help(...)
```

## Arguments

- infile:

  Character; input DWI (diffusion-weighted imaging) filename in DICOM or
  NIfTI format. Required for initial processing.

- outdir:

  Character, Path to output directory.

- subjid:

  subject id, if NULL, the basename of the infile will be used

- verbose:

  (logical) print diagnostic messages

- opts:

  Character. Additional options to Freesurfer function.

- ...:

  Additional arguments passed to
  [`fs_help()`](https://muschellij2.github.io/freesurfer/reference/fs_help.md)

## Value

Result of [`base::system()`](https://rdrr.io/r/base/system.html) call,
typically exit status (0 = success).

## Details

All functions call the same underlying FreeSurfer `trac-all` command
with different option flags.

## Functions

- `tracker()`: Low-level wrapper for trac-all command with custom
  options

- `trac_all()`: High-level wrapper running complete tractography
  pipeline

- `trac_prep()`: Run pre-processing step (step 1: image corrections,
  registration)

- `trac_bedpost()`: Run bedpost step (step 2: ball-and-stick model
  fitting)

- `trac_path()`: Run pathway reconstruction step (step 3: probabilistic
  tractography)

- `tracker.help()`: Display FreeSurfer help for trac-all

## See also

[`recon_all()`](https://muschellij2.github.io/freesurfer/reference/recon.md)
for structural reconstruction pipeline

## Examples

``` r
if (FALSE) { # have_fs()
if (FALSE) { # \dontrun{
# Run full tractography pipeline
trac_all(
  infile = "dwi.nii",
  subjid = "subject01",
  outdir = "~/tractography_output"
)

# Run step-by-step
trac_prep(infile = "dwi.nii", subjid = "subject02")
trac_bedpost(infile = "dwi.nii", subjid = "subject02")
trac_path(infile = "dwi.nii", subjid = "subject02")

# Run with custom options
tracker(
  infile = "dwi.nii",
  subjid = "subject03",
  opts = "-prep -bedp"
)
} # }
}
```
