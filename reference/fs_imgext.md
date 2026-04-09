# Determine extension of image based on Freesurfer output type

Runs
[`get_fs_output()`](https://muschellij2.github.io/freesurfer/reference/get_fs_setting.md)
to extract the Freesurfer output type and then gets the corresponding
file extension (such as `.nii.gz`).

## Usage

``` r
fs_imgext()
```

## Value

Character string representing the file extension for the output type.

## Examples

``` r
fs_imgext()
#> [1] ".nii.gz"
```
