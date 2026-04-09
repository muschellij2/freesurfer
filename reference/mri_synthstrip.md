# Use Freesurfers MRI SynthStrip

This function calls `mri_mask` to mask an image

## Usage

``` r
mri_synthstrip(
  file,
  outfile = NULL,
  retimg = TRUE,
  maskfile = NULL,
  opts = "",
  ...
)

synthstrip(
  file,
  outfile = NULL,
  retimg = TRUE,
  maskfile = NULL,
  opts = "",
  ...
)
```

## Arguments

- file:

  (character) input filename

- outfile:

  (character) output filename

- retimg:

  (logical) return image of class nifti

- maskfile:

  (character) path for mask output

- opts:

  Character. Additional options to Freesurfer function.

- ...:

  additional arguments passed to
  [`fs_cmd`](https://muschellij2.github.io/freesurfer/reference/fs_cmd.md).

## Value

Character or nifti depending on `retimg`

## Examples

``` r
if (FALSE) { # have_fs()
if (FALSE) { # \dontrun{
mock_nifti = array(rnorm(5*5*5), dim = c(5,5,5))
img = oro.nifti::nifti(mock_nifti)
res = mri_synthstrip(img)
} # }
}
```
