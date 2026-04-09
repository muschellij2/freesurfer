# Use Freesurfers MRI Segmentation Algorithm

This function calls `mri_segment`

This calls Freesurfer's `mri_segment` help

## Usage

``` r
mri_segment(file, outfile = NULL, retimg = TRUE, opts = "", ...)

mri_segment.help(...)
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

- `mri_segment.help()`: Display FreeSurfer help for mri_segment

## Note

NOT COMPLETE
