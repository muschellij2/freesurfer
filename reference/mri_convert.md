# Convert Medical Image Formats with FreeSurfer

Calls FreeSurfer's `mri_convert` to convert between different medical
imaging formats (NIfTI, MGZ, MINC, etc.) with enhanced format validation
and error handling.

## Usage

``` r
mri_convert(
  file,
  outfile,
  opts = "",
  format_check = TRUE,
  timeout_seconds = 300,
  ...
)

mri_convert.help(...)
```

## Arguments

- file:

  Character; input filename or nifti object.

- outfile:

  Character; output filename.

- opts:

  Character. Additional options to Freesurfer function.

- format_check:

  Logical; whether to validate input/output formats and warn about
  unexpected formats. Default is `TRUE`.

- timeout_seconds:

  Numeric; command timeout in seconds. Default is 300.

- ...:

  Additional arguments passed to
  [`fs_help()`](https://muschellij2.github.io/freesurfer/reference/fs_help.md)

## Value

Result of [`base::system()`](https://rdrr.io/r/base/system.html)
command, typically exit status.

## Details

Runtime FreeSurfer CLI help is available via the helper function
`mri_convert.help()`. When called, that helper will attempt to fetch and
display the underlying FreeSurfer command-line help if FreeSurfer is
installed on the system. The package does not embed the CLI help into
the installed Rd at package build time.

This function provides format validation and informative messages about
conversions between different image types.

## Functions

- `mri_convert.help()`: Display FreeSurfer help for mri_convert

## FreeSurfer Command Help

When FreeSurfer is installed and available, detailed command-line help
for the underlying `mri_convert` command can be accessed via
`mri_convert.help()`. This provides comprehensive information about
FreeSurfer's native command options, file format support, and usage
examples.

To see FreeSurfer CLI help: `mri_convert.help()`

## See also

[`fs_cmd()`](https://muschellij2.github.io/freesurfer/reference/fs_cmd.md)
for the underlying command wrapper

## Examples

``` r
if (FALSE) { # have_fs()
# Convert nifti object to MGZ format
img <- oro.nifti::nifti(array(rnorm(5*5*5), dim = c(5, 5, 5)))
res <- mri_convert(img, outfile = temp_file(fileext = ".mgz"))

if (FALSE) { # \dontrun{
# Convert MGZ to NIfTI
mri_convert("brain.mgz", "brain.nii.gz")

# With additional options
mri_convert("brain.mgz", "brain.nii.gz", opts = "--conform")
} # }
}
```
