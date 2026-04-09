# Use Freesurfers MRI Mask

This function calls `mri_mask` to mask an image

## Usage

``` r
mri_mask(file, mask, outfile = NULL, retimg = TRUE, opts = "", ...)
```

## Arguments

- file:

  (character) input filename

- mask:

  (character) mask filename

- outfile:

  (character) output filename

- retimg:

  (logical) return image of class nifti

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
img = oro.nifti::nifti(array(rnorm(5*5*5), dim = c(5,5,5)))
mask = img > 1
res = mri_mask(img, mask)
} # }
}
```
