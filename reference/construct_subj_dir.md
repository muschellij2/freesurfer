# Construct Subject Directory

This function copies files specified by the types of data, determined by
the folder Freesurfer put them in, into a temporary directory for easier
separation of data and different structuring of data.

## Usage

``` r
construct_subj_dir(
  label = NULL,
  mri = NULL,
  stats = NULL,
  surf = NULL,
  touch = NULL,
  subj = NULL,
  subj_root_dir = tempdir(check = TRUE)
)
```

## Arguments

- label:

  Files to copy to `subj_root_dir/subj/label` folder

- mri:

  Files to copy to `subj_root_dir/subj/mri` folder

- stats:

  Files to copy to `subj_root_dir/subj/stats` folder

- surf:

  Files to copy to `subj_root_dir/subj/surf` folder

- touch:

  Files to copy to `subj_root_dir/subj/touch` folder

- subj:

  Name of subject to make folder for to use for Freesurfer functions. If
  `NULL`, a temporary id will be generated

- subj_root_dir:

  Directory to put folder with contents of `subj`

## Value

List with the subject name, the SUBJECTS_DIR to use (the directory that
contains the subject name), and the types of objects copied

## Examples

``` r
if (FALSE) { # \dontrun{
library(freesurfer)
label = "/Applications/freesurfer/subjects/bert/label/aparc.annot.a2009s.ctab"
mri = c(
  "/Applications/freesurfer/subjects/bert/mri/aparc.a2009s+aseg.mgz",
  "/Applications/freesurfer/subjects/bert/mri/aseg.auto.mgz")
stats = c("/Applications/freesurfer/subjects/bert/stats/lh.aparc.stats",
          "/Applications/freesurfer/subjects/bert/stats/aseg.stats")
surf = "/Applications/freesurfer/subjects/bert/surf/lh.thickness"
construct_subj_dir(
  label = label,
  mri = mri,
  stats = stats,
  surf = surf)
} # }
```
