# MRIs Euler Number

This function calls `mris_euler_number` to calculate the Euler Number
with improved error handling and output management.

## Usage

``` r
mris_euler_number(
  file,
  outfile = NULL,
  opts = "",
  cleanup_temp = TRUE,
  timeout_seconds = 120,
  validate_format = TRUE,
  ...
)
```

## Arguments

- file:

  (character) input filename - surface file

- outfile:

  (character) output filename for results (optional)

- opts:

  Character. Additional options to FreeSurfer function.

- cleanup_temp:

  (logical) Whether to clean up temporary files

- timeout_seconds:

  (numeric) Command timeout in seconds (default 120)

- validate_format:

  (logical) Whether to validate input format

- ...:

  Additional arguments to pass to
  [`fs_cmd`](https://muschellij2.github.io/freesurfer/reference/fs_cmd.md)

## Value

Character vector containing the Euler number results

## Examples

``` r
if (FALSE) { # have_fs()
if (FALSE) { # \dontrun{
img = oro.nifti::nifti(array(rnorm(5*5*5), dim = c(5,5,5)))
res = mris_euler_number(img, outfile = temp_file(fileext = ".mgz"))
} # }
}
```
