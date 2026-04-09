# Retrieve FreeSurfer Configuration Settings

These functions retrieve FreeSurfer configuration settings using a
hierarchical lookup system: R options → environment variables →
defaults.

## Usage

``` r
get_fs_setting(env_var, opt_var, defaults = NULL, is_path = TRUE)

get_fs_home(simplify = TRUE)

get_fs_license(fs_home = get_fs_home(), simplify = TRUE)

get_fs_subdir(fs_home = get_fs_home(), simplify = TRUE)

get_fs_source(fs_home = get_fs_home(), simplify = TRUE)

get_fs_verbosity(simplify = TRUE)

get_fs_output(simplify = TRUE)

get_mni_bin(fs_home = get_fs_home(), simplify = TRUE)
```

## Arguments

- env_var:

  Character; name of the environment variable to check.

- opt_var:

  Character; name of the R option to check.

- defaults:

  Character vector of default paths to try.

- is_path:

  Logical; whether this setting represents a file/directory path.

- simplify:

  Logical; if `TRUE`, returns only the value. If `FALSE`, returns a list
  with detailed information (value, source, exists).

- fs_home:

  Character; FreeSurfer home directory.

## Value

When `simplify = TRUE`: Character string with the setting value, or
`NA`. When `simplify = FALSE`: List with `value`, `source`, and `exists`
components.

## Details

### Lookup Hierarchy

Settings are resolved in the following order (first match wins):

1.  **R options** (set with
    [`options()`](https://rdrr.io/r/base/options.html))

2.  **Environment variables** (set with
    [`Sys.setenv()`](https://rdrr.io/r/base/Sys.setenv.html))

3.  **Default paths** (platform-specific)

### Setting Options

You can set R options in your `.Rprofile`:

    options(
      freesurfer.home = "/usr/local/freesurfer",
      freesurfer.subj_dir = "~/freesurfer_subjects",
      freesurfer.verbose = TRUE
    )

## Functions

- `get_fs_setting()`: Core function for retrieving settings

- `get_fs_home()`: Retrieve FreeSurfer installation directory

- `get_fs_license()`: Retrieve FreeSurfer license file path

- `get_fs_subdir()`: Retrieve FreeSurfer subjects directory

- `get_fs_source()`: Retrieve FreeSurfer source script path

- `get_fs_verbosity()`: Retrieve FreeSurfer verbosity setting

- `get_fs_output()`: Retrieve FreeSurfer output format

- `get_mni_bin()`: Retrieve MNI tools directory

## See also

[`have_fs()`](https://muschellij2.github.io/freesurfer/reference/have_fs.md)
to check if FreeSurfer is accessible,
[`fs_sitrep()`](https://muschellij2.github.io/freesurfer/reference/fs_sitrep.md)
for comprehensive diagnostics,
[`get_fs()`](https://muschellij2.github.io/freesurfer/reference/get_fs.md)
to generate environment setup commands

## Examples

``` r
# Get FreeSurfer home directory
fs_home <- get_fs_home()

# Get detailed information
fs_home_info <- get_fs_home(simplify = FALSE)

# Check license file
license <- get_fs_license()

# Get subjects directory
subj_dir <- get_fs_subdir()

# Check output format
format <- get_fs_output()  # Returns "nii.gz", "nii", "mgz", etc.

# Check verbosity
verbose <- get_fs_verbosity()  # Returns TRUE/FALSE

if (FALSE) { # \dontrun{
# Set custom options
options(freesurfer.home = "/custom/path/freesurfer")
get_fs_home()  # Returns: "/custom/path/freesurfer"
} # }
```
