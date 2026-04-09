# FreeSurfer Situation Report

Get a situation report on your current FreeSurfer installation and
settings within R. This function helps diagnose problems by showing how
FreeSurfer paths and options are determined.

## Usage

``` r
fs_sitrep(clear_cache = FALSE, test_commands = TRUE)
```

## Arguments

- clear_cache:

  (logical) Whether to clear settings cache before reporting

- test_commands:

  (logical) Whether to test actual FreeSurfer commands

## Examples

``` r
if (FALSE) { # have_fs()
# Report all FreeSurfer settings
fs_sitrep()
}
```
