# Convert MNC to NIfTI

This function calls `mnc2nii` to convert MNC files to NIfTI

## Usage

``` r
mnc2nii(file, outfile = NULL, ...)

mnc2nii.help()
```

## Arguments

- file:

  (character) input filename

- outfile:

  (character) output filename

- ...:

  Additional arguments to pass to
  [`fs_cmd`](https://muschellij2.github.io/freesurfer/reference/fs_cmd.md)

## Value

Character filename of output

## Functions

- `mnc2nii.help()`: Display information about mnc2nii command

## Examples

``` r
if (FALSE) { # have_fs()
img = oro.nifti::nifti(array(rnorm(5*5*5), dim = c(5,5,5)))
mnc = nii2mnc(img)
img_file = mnc2nii(mnc, outfile = temp_file(fileext = ".nii"))
neurobase::readnii(img_file, verbose = get_fs_verbosity())
}
```
