# Use FreeSurfer's Non-Uniformity Correction

This function calls `nu_correct` to correct for intensity non-uniformity
in MRI images using N3 (nonparametric nonuniform normalization).

## Usage

``` r
nu_correct(file, mask = NULL, opts = "", verbose = get_fs_verbosity(), ...)

nu_correct.help(...)
```

## Arguments

- file:

  Character; input filename.

- mask:

  Character or nifti; mask to use for correction.

- opts:

  Character. Additional options to Freesurfer function.

- verbose:

  (logical) print diagnostic messages

- ...:

  Additional arguments passed to
  [`fs_help()`](https://muschellij2.github.io/freesurfer/reference/fs_help.md)

## Value

Object of class nifti.

## Details

The `nu_correct` command performs N3 (nonparametric nonuniform intensity
normalization) to correct for intensity inhomogeneity in MRI images.
This is particularly useful for T1-weighted images where intensity
varies across the image due to magnetic field inhomogeneities.

Common options:

- `-mask <file>`: Use a binary mask

- `-distance <value>`: N3 spline distance (default 200mm)

- `-iterations <value>`: Maximum iterations (default 4)

- `-stop <value>`: Stopping criterion (default 0.01)

Note: This is an MNI tool and uses different help syntax (`-help`
instead of `--help`).

## Functions

- `nu_correct.help()`: Display information about nu_correct

## See also

[`mri_normalize()`](https://muschellij2.github.io/freesurfer/reference/mri_normalize.md)
for FreeSurfer's normalization, `nu_correct.help()` for command
information

## Examples

``` r
if (FALSE) { # have_fs()
if (FALSE) { # \dontrun{
# Basic usage
nu_correct("/path/to/T1.nii.gz")

# With mask
nu_correct("/path/to/T1.nii.gz", mask = "/path/to/mask.nii.gz")
} # }
}
```
