# Read MGH or MGZ File

This function calls `mri_convert` to convert MGH/MGZ files to NIfTI,
then reads it in using
[`readnii`](https://rdrr.io/pkg/neurobase/man/readNIfTI2.html) with
enhanced validation.

## Usage

``` r
read_mgz(file, validate_format = TRUE, cleanup_temp = TRUE, ...)

read_mgh(file, validate_format = TRUE, cleanup_temp = TRUE, ...)
```

## Arguments

- file:

  (character) input filename - MGH or MGZ file

- validate_format:

  (logical) Whether to validate file format

- cleanup_temp:

  (logical) Whether to clean up temporary files

- ...:

  Additional arguments to pass to
  [`fs_cmd`](https://muschellij2.github.io/freesurfer/reference/fs_cmd.md)

## Value

Object of class `nifti`
