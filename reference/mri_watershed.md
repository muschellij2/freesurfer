# Use Freesurfers MRI Watershed Algorithm

This function calls `mri_watershed` to extract a brain from an image,
usually for skull stripping.

This calls Freesurfer's `mri_watershed` help

## Usage

``` r
mri_watershed(file, outfile = NULL, retimg = TRUE, opts = "", ...)

mri_watershed.help(...)
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

  Additional arguments passed to
  [`fs_help()`](https://muschellij2.github.io/freesurfer/reference/fs_help.md)

## Value

Character or nifti depending on `retimg`

Result of `fs_help`

## Functions

- `mri_watershed.help()`: Display FreeSurfer help for mri_watershed

## Examples

``` r
if (FALSE) { # \dontrun{
mri_watershed("/path/to/T1.nii.gz")
} # }
```
