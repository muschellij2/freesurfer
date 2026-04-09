# Read MNC File

This function calls
[`mnc2nii`](https://muschellij2.github.io/freesurfer/reference/mnc2nii.md)
to convert MNC files to NIfTI, then reads it in using
[`readnii`](https://rdrr.io/pkg/neurobase/man/readNIfTI2.html)

## Usage

``` r
read_mnc(file)
```

## Arguments

- file:

  (character) input filename

## Value

Object of class `nifti`
