# Generate FreeSurfer Command Line Environment Setup

This function generates a bash command string to set up the environment
for using FreeSurfer. It ensures the required FreeSurfer installation,
license, and environment setup files are validated and included in the
command string. The function handles different FreeSurfer binaries like
`bin`, `mni/bin`, and others, while ensuring proper initialization of
the MNI environment if required.

## Usage

``` r
get_fs(bin_app = c("bin", "mni/bin"), fs_home = get_fs_home(simplify = FALSE))
```

## Arguments

- bin_app:

  [character](https://rdrr.io/r/base/character.html) A vector of options
  for the binary application directory. Possible options include:

  - `"bin"`: Default FreeSurfer binary directory.

  - `"mni/bin"`: Includes MNI initialization.

  - `""`: Base directory with no specific subdirectories.

- fs_home:

  Character string specifying FreeSurfer installation directory. Usually
  this is determined automatically via
  [`get_fs_home`](https://muschellij2.github.io/freesurfer/reference/get_fs_setting.md).

## Value

[character](https://rdrr.io/r/base/character.html) A bash command string
that includes environment setup for FreeSurfer. If the FreeSurfer
environment or required configurations cannot be initialized, the
function throws an error or issues a warning. On success, the returned
string can be used directly in shell operations to load the FreeSurfer
environment.

## See also

[`get_fs_home()`](https://muschellij2.github.io/freesurfer/reference/get_fs_setting.md),
[`get_fs_license()`](https://muschellij2.github.io/freesurfer/reference/get_fs_setting.md),
[`get_fs_output()`](https://muschellij2.github.io/freesurfer/reference/get_fs_setting.md)

## Examples

``` r
if (FALSE) { # have_fs()
# Generate a shell command to set up FreeSurfer with the default `bin`
get_fs(bin_app = "bin")

# Generate a shell command to include MNI environment setup
get_fs(bin_app = "mni/bin")
}
```
