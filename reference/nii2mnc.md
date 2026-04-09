# Convert NIfTI to MNC

This function calls `nii2mnc` to convert NIfTI to MNC files

## Usage

``` r
nii2mnc(file, outfile = tempfile(fileext = ".mnc"), ...)

nii2mnc.help()
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

- `nii2mnc.help()`: Display information about nii2mnc command

## Examples

``` r
if (FALSE) { # have_fs()
img = oro.nifti::nifti(array(rnorm(5*5*5), dim = c(5,5,5)))
mnc = nii2mnc(img)
img_file = mnc2nii(mnc)
}
```
