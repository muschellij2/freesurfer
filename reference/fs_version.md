# Find Freesurfer Version

Finds the Freesurfer version from `FREESURFER_HOME/build-stamp.txt`

## Usage

``` r
fs_version()
```

## Value

If the version file does not exist, it will throw a warning, but it will
return an empty string. Otherwise it will be a string of the version.

## Note

This will use
[`fs_dir()`](https://muschellij2.github.io/freesurfer/reference/fs_dir.md)
to get the directory of FREESURFER

## Examples

``` r
if (FALSE) { # have_fs()
 fs_version()
}
```
