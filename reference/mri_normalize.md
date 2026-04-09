# Use Freesurfers MRI Normalize Algorithm

This function calls `mri_normalize` to normalize the values of the
image, with white matter voxels around 110.

## Usage

``` r
mri_normalize(file, outfile = NULL, retimg = TRUE, opts = "", ...)
```

## Arguments

- file:

  (character) input filename

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
if (FALSE) { # \dontrun{
mri_normalize("/path/to/T1.nii.gz")
} # }
```
