# Wrapper for getting FreeSurfer help

This function takes in the function and returns the help from FreeSurfer
for that function with simple validation.

## Usage

``` r
fs_help(
  func_name,
  help_arg = "--help",
  extra_args = "",
  timeout_seconds = 30,
  display = TRUE,
  warn = TRUE,
  bin_app = "bin",
  ...
)
```

## Arguments

- func_name:

  FreeSurfer function name

- help_arg:

  Argument to print help, usually "–help"

- extra_args:

  Extra arguments to be passed other than `--help`

- timeout_seconds:

  Timeout for help command (default 30 seconds)

- display:

  Logical; whether to display help output

- warn:

  Logical; whether to warn if help is not available

- bin_app:

  Character string specifying the FreeSurfer bin directory appendix.
  Options are `"bin"` (default) or `"mni/bin"` for MNI tools.

- ...:

  additional arguments to
  [`get_fs`](https://muschellij2.github.io/freesurfer/reference/get_fs.md)

## Value

Prints help output and returns output as character vector

## Examples

``` r
if (FALSE) { # have_fs()
fs_help("mri_watershed")

# For MNI tools
fs_help("nu_correct", help_arg = "-help", bin_app = "mni/bin")
}
```
