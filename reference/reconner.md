# Reconstruction Helper for FreeSurfer's recon-all

Wrapper around FreeSurfer's `recon-all` command for brain surface
reconstruction from MRI data. Handles input processing, subject
directory creation, and command flag management.

## Usage

``` r
reconner(
  subjid = NULL,
  infile = NULL,
  outdir = NULL,
  opts = "-all",
  force = FALSE,
  verbose = get_fs_verbosity()
)
```

## Arguments

- subjid:

  subject id, if NULL, the basename of the infile will be used

- infile:

  Character; path to input file in DICOM or NIfTI format.

- outdir:

  Character, Path to output directory.

- opts:

  Character. Additional options to Freesurfer function.

- force:

  Logical; force execution even if subject directory exists. Default is
  `FALSE`.

- verbose:

  (logical) print diagnostic messages

## Value

Result of [`base::system()`](https://rdrr.io/r/base/system.html) call,
typically exit status (0 = success).

## Details

FreeSurfer's `recon-all` performs cortical reconstruction and volumetric
segmentation. This function simplifies usage by:

- Automatically deriving subject ID from input filename if not provided

- Managing subject directory paths

- Providing force option for re-running on existing subjects

## See also

[`tracker()`](https://muschellij2.github.io/freesurfer/reference/trac.md)
for diffusion tractography pipeline

## Examples

``` r
if (FALSE) { # have_fs()
if (FALSE) { # \dontrun{
reconner(infile = "input.nii", outdir = "/output_dir", subjid = "subj01")
reconner(infile = "input.nii", outdir = "/output_dir")
reconner(infile = "input.nii", opts = "-autorecon2", force = TRUE)
} # }
}
```
