# Manual Freesurfer Reconstruction Workflow

A set of helper functions for running different stages of Freesurfer's
`recon-all` pipeline: `autorecon1`, `autorecon2`, and `autorecon3`.
These functions are wrappers around the
[reconner](https://muschellij2.github.io/freesurfer/reference/reconner.md)
function, simplifying the reconstruction process by specifying
pre-defined options for each stage.

## Usage

``` r
recon_con1(infile, subjid, outdir = NULL, verbose = get_fs_verbosity())

autorecon1(infile, subjid, outdir = NULL, verbose = get_fs_verbosity())

recon_con2(infile, subjid, outdir = NULL, verbose = get_fs_verbosity())

autorecon2(infile, subjid, outdir = NULL, verbose = get_fs_verbosity())

recon_con3(infile, subjid, outdir = NULL, verbose = get_fs_verbosity())

autorecon3(infile, subjid, outdir = NULL, verbose = get_fs_verbosity())
```

## Arguments

- infile:

  Input filename in DICOM (`.dcm`) or NIfTI (`.nii`) format. This is the
  brain image file to be processed. If `NULL`, some `recon-all`
  functionality may not work.

- subjid:

  subject id, if NULL, the basename of the infile will be used

- outdir:

  Output directory for storing reconstruction results. If `NULL`, the
  default Freesurfer subject directory is used.

- verbose:

  (logical) print diagnostic messages

## Value

The result of the `system` call to `recon-all`, either the command's
output or a diagnostic message if an issue occurs.

## Details

Freesurfer is a widely used software suite for processing and analyzing
brain MRI images. The `recon-all` tool provides a stepwise
reconstruction process:

- `-autorecon1`: Motion correction to skull stripping (steps 1-5)

- `-autorecon2`: Further processing, including intensity normalization

- `-autorecon3`: Final surface generation and QC measures

These helpers call specific stages of the `recon-all` pipeline to
provide finer control over processing.

## Functions

- `recon_con1()`: Performs `-autorecon1`, which includes steps 1-5 of
  Freesurfer's reconstruction process.

- `autorecon1()`: Helper function for `recon_con1` with the same
  functionality.

- `recon_con2()`: Performs `-autorecon2`, which includes steps 6+ of
  Freesurfer's reconstruction process.

- `autorecon2()`: Helper function for `recon_con2` with the same
  functionality.

- `recon_con3()`: Performs the final stage of Freesurfer's
  reconstruction process, which includes generating cortical surfaces,

- `autorecon3()`: Helper function for `recon_con3` with the same
  functionality.

## Note

See the official Freesurfer documentation for additional details on each
autorecon stage: <https://surfer.nmr.mgh.harvard.edu/fswiki/recon-all>.

If `infile` is set to `NULL`, the `-i` flag (input file flag) in
`recon-all` will be omitted, which may or may not be appropriate
depending on your use case.

## See also

[reconner](https://muschellij2.github.io/freesurfer/reference/reconner.md),
[recon](https://muschellij2.github.io/freesurfer/reference/recon.md),
[recon_all](https://muschellij2.github.io/freesurfer/reference/recon.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Example: Perform Step 1-5 reconstruction (Motion Correction to Skull Strip)
recon_con1(
  infile = "subject_001.nii",
  outdir = "/output_dir",
  subjid = "subj01",
  verbose = TRUE
)

# Example: Run autorecon1 with equivalent helper function
autorecon1(
  infile = "subject_001.nii",
  outdir = "/output_dir",
  subjid = "subj01",
  verbose = TRUE
)

# Example: Perform further processing for Step 6+ using autorecon2
autorecon2(
  infile = "subject_002.nii",
  outdir = "/output_dir",
  subjid = "subj02",
  verbose = TRUE
)

# Example: Complete reconstruction with autorecon3
autorecon3(
  infile = "subject_003.nii",
  outdir = "/output_dir",
  subjid = "subj03",
  verbose = FALSE
)
} # }
```
