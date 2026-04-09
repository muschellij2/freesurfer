# MRI information

This calls Freesurfer's `mri_info`

## Usage

``` r
mri_info(file, ...)
```

## Arguments

- file:

  File to pass to `mri_info`

- ...:

  Additional arguments to pass to
  [`fs_cmd`](https://muschellij2.github.io/freesurfer/reference/fs_cmd.md)

## Value

Result of `fs_cmd`, which type depends on arguments to `...`

## Examples

``` r
if (FALSE) { # have_fs()
if (FALSE) { # \dontrun{
img = oro.nifti::nifti(array(rnorm(5*5*5), dim = c(5,5,5)))
mri_info(img)
} # }
}
```
