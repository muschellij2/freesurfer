# Get FreeSurfer Directory Paths

Functions to retrieve FreeSurfer's installation and subjects
directories. Multiple aliases are provided for convenience and backward
compatibility.

## Usage

``` r
freesurferdir()

freesurfer_dir()

fs_dir()

fs_subj_dir()
```

## Value

Character; path to the FreeSurfer home or subjects directory.

## Functions

- `freesurferdir()`: Get FreeSurfer installation directory

- `freesurfer_dir()`: Alias for freesurferdir

- `fs_dir()`: Short alias for freesurferdir

- `fs_subj_dir()`: Get FreeSurfer subjects directory

## See also

[`get_fs_home()`](https://muschellij2.github.io/freesurfer/reference/get_fs_setting.md)
for more detailed information,
[`have_fs()`](https://muschellij2.github.io/freesurfer/reference/have_fs.md)
to check if FreeSurfer is accessible

## Examples

``` r
if (FALSE) { # have_fs()
# All return the same value
freesurferdir()
freesurfer_dir()
fs_dir()

# Get subjects directory
fs_subj_dir()
}
```
