# Execute FreeSurfer Commands from R

`fs_cmd()` is the core wrapper function that executes FreeSurfer
command-line tools from within R. It handles file path validation,
command construction, execution, and optional return of neuroimaging
data as nifti objects.

## Usage

``` r
fs_cmd(
  func,
  file,
  outfile = NULL,
  retimg = TRUE,
  reorient = FALSE,
  verbose = get_fs_verbosity(),
  intern = verbose,
  opts = "",
  opts_after_outfile = FALSE,
  frontopts = "",
  bin_app = "bin",
  timeout_seconds = NULL,
  validate_inputs = TRUE,
  ...
)
```

## Arguments

- func:

  Character string specifying the FreeSurfer command to execute (e.g.,
  `"mri_convert"`, `"mri_watershed"`).

- file:

  Character path to the input image file, or a nifti object. If a nifti
  object is provided, it will be temporarily written to disk.

- outfile:

  Character path to the output image file. If `NULL` (default), and
  `retimg = TRUE`, a temporary file will be created. Set
  `outfile = file` to overwrite the input file (with warning).

- retimg:

  Logical; if `TRUE` (default), returns output as a nifti object. If
  `FALSE`, returns the system command result.

- reorient:

  Logical; if `TRUE` and `retimg = TRUE`, reorients the image when
  loading. Passed to
  [`neurobase::readnii()`](https://rdrr.io/pkg/neurobase/man/readNIfTI2.html).
  Default is `FALSE`.

- verbose:

  (logical) print diagnostic messages

- intern:

  Logical; if `TRUE`, captures command output. Passed to
  [`base::system()`](https://rdrr.io/r/base/system.html). Default is
  `FALSE`.

- opts:

  Character. Additional options to Freesurfer function.

- opts_after_outfile:

  Logical; if `TRUE`, places `opts` after `outfile` in the command
  string. Default is `FALSE`.

- frontopts:

  Character string of options to prepend before the input file in the
  command. Default is `""`.

- bin_app:

  Character string specifying the FreeSurfer bin directory appendix.
  Options are `"bin"` (default) or `"mni/bin"`.

- timeout_seconds:

  Numeric; command timeout in seconds. If specified, requires the
  R.utils package. Default is `NULL` (no timeout).

- validate_inputs:

  Logical; if `TRUE` (default), validates that input files exist before
  running the command.

- ...:

  Additional arguments passed to
  [`base::system()`](https://rdrr.io/r/base/system.html).

## Value

If `retimg = TRUE`: A nifti object containing the output image, or
`NULL` if output creation failed. If `retimg = FALSE`: The result from
[`base::system()`](https://rdrr.io/r/base/system.html), typically the
exit status or captured output.

## Details

This function provides a unified interface to FreeSurfer's command-line
tools, with several key features:

- Automatic validation of input/output files

- Support for nifti objects as inputs

- Optional timeout for long-running commands

- Flexible command option placement

- Automatic result verification

- Integration with FreeSurfer environment setup

### Overwriting Files

To overwrite the input file, set `outfile = file`. A warning will be
displayed for safety. The function checks file existence before and
after command execution to verify successful completion.

### Command Construction

The command is constructed in the following order:

1.  FreeSurfer environment setup (from
    [`get_fs()`](https://muschellij2.github.io/freesurfer/reference/get_fs.md))

2.  Command name (`func`)

3.  Front options (`frontopts`)

4.  Input file path (quoted)

5.  Output file path (quoted, if provided)

6.  Additional options (`opts`)

Use `opts_after_outfile = TRUE` to place `opts` after the output file.

## See also

[`get_fs()`](https://muschellij2.github.io/freesurfer/reference/get_fs.md)
for FreeSurfer environment setup,
[`mri_convert()`](https://muschellij2.github.io/freesurfer/reference/mri_convert.md)
for format conversion,
[`neurobase::readnii()`](https://rdrr.io/pkg/neurobase/man/readNIfTI2.html)
for reading nifti files

## Examples

``` r
if (FALSE) { # have_fs()
if (FALSE) { # \dontrun{
# Basic usage: convert MGZ to NIfTI
fs_cmd(
  func = "mri_convert",
  file = "input.mgz",
  outfile = "output.nii.gz",
  opts = "--conform"
)

# Return as nifti object
img <- fs_cmd(
  func = "mri_convert",
  file = "input.mgz",
  retimg = TRUE
)

# Use nifti object as input
library(oro.nifti)
img <- nifti(array(rnorm(10*10*10), dim = c(10, 10, 10)))
result <- fs_cmd(
  func = "mri_convert",
  file = img,
  outfile = "output.nii.gz"
)
} # }
}
```
