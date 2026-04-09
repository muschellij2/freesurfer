# Logical check if Freesurfer is accessible

Checks if FreesurferDIR is accessible and optionally if a license file
exists.

## Usage

``` r
have_fs(check_license = TRUE)
```

## Arguments

- check_license:

  [logical](https://rdrr.io/r/base/logical.html) Should a license file
  be checked for existence?

## Value

Logical `TRUE` if Freesurfer is accessible and license (if checked) is
found, `FALSE` otherwise.

## Examples

``` r
have_fs()
#> [1] FALSE
```
