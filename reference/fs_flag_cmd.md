# Run a Flag-Based FreeSurfer Command

The flag-based counterpart to
[`fs_cmd()`](https://muschellij2.github.io/freesurfer/reference/fs_cmd.md),
for FreeSurfer tools that take `--flag value` arguments (such as
`mri_vol2vol`). The command is assembled from a named list of flags and
run with the FreeSurfer environment set up.

## Usage

``` r
fs_flag_cmd(
  func,
  args = list(),
  outfile = NULL,
  opts = "",
  verbose = get_fs_verbosity(),
  ...
)
```

## Arguments

- func:

  Character; the FreeSurfer command, e.g. `"mri_vol2vol"`.

- args:

  Named list of command flags: `name = value` becomes `--name <value>`,
  `TRUE` becomes a bare `--name`, and `NULL` or `FALSE` are dropped.
  Order is preserved and values are quoted with
  [`base::shQuote()`](https://rdrr.io/r/base/shQuote.html).

- outfile:

  Character; the file the command is expected to create, checked after
  it runs.

- opts:

  Character. Additional options to Freesurfer function.

- verbose:

  (logical) print diagnostic messages

- ...:

  Additional arguments controlling command execution, such as a timeout.

## Value

The `outfile`, invisibly.

## See also

[`fs_cmd()`](https://muschellij2.github.io/freesurfer/reference/fs_cmd.md)
for positional-argument commands.

## Examples

``` r
if (FALSE) { # have_fs()
if (FALSE) { # \dontrun{
out <- temp_file(fileext = ".nii.gz")
fs_flag_cmd(
  "mri_vol2vol",
  args = list(
    mov = "mov.nii.gz",
    targ = "targ.mgz",
    regheader = TRUE,
    o = out
  ),
  outfile = out
)
} # }
}
```
