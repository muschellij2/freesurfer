# Set FreeSurfer Subjects Directory

**\[deprecated\]**

This function is deprecated. Set the subjects directory using
`Sys.setenv(SUBJECTS_DIR = path)` or the R option
`options(freesurfer.subj_dir = path)` instead.

## Usage

``` r
set_fs_subj_dir(path)
```

## Arguments

- path:

  Character path to the subjects directory

## Value

Invisibly returns the previous value of SUBJECTS_DIR
