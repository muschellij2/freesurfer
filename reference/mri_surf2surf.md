# Resample Cortical Surface Data with FreeSurfer

Calls FreeSurfer's `mri_surf2surf` to resample one cortical surface onto
another, enabling comparison of surface data across subjects or atlases.

## Usage

``` r
mri_surf2surf(
  subject = NULL,
  target_subject = NULL,
  trg_type = c("curv", "w", "mgh", "nii"),
  src_type = c("curv", "w"),
  outfile = NULL,
  hemi = c("lh", "rh"),
  sval = c("thickness"),
  subj_dir = NULL,
  opts = "",
  verbose = get_fs_verbosity(),
  ...
)

mri_surf2surf.help(...)
```

## Arguments

- subject:

  Character; source subject name.

- target_subject:

  Character; target subject name (e.g., "fsaverage").

- trg_type:

  Character; target file type. One of "curv", "w" (paint), "mgh", or
  "nii".

- src_type:

  Character; source file type. One of "curv" or "w" (paint).

- outfile:

  Character; output filename. If NULL, a temporary file is created.

- hemi:

  Character; hemisphere. One of "lh" or "rh".

- sval:

  Character; source value/measure (e.g., "thickness").

- subj_dir:

  (character path) if a different subjects directory is to be used other
  than `SUBJECTS_DIR` from shell, it can be specified here. Use with
  care as if the command fail, it may not reset the `SUBJECTS_DIR` back
  correctly after the error

- opts:

  Character. Additional options to Freesurfer function.

- verbose:

  (logical) print diagnostic messages

- ...:

  Additional arguments passed to
  [`fs_help()`](https://muschellij2.github.io/freesurfer/reference/fs_help.md)

## Value

Character; path to the output file (prefixed with hemisphere).

## Details

This function is commonly used to:

- Project individual subject data onto a template (e.g., fsaverage)

- Resample between different surface resolutions

- Convert between surface file formats

The output filename is automatically prefixed with the hemisphere (e.g.,
"lh.output.mgz").

## Functions

- `mri_surf2surf.help()`: Display FreeSurfer help for mri_surf2surf

## See also

[`fs_help()`](https://muschellij2.github.io/freesurfer/reference/fs_help.md)
for FreeSurfer command documentation

## Examples

``` r
if (FALSE) { # have_fs()
if (FALSE) { # \dontrun{
out <- mri_surf2surf(
  subject = "bert",
  target_subject = "fsaverage",
  trg_type = "curv",
  src_type = "curv",
  hemi = "rh",
  sval = "thickness"
)
} # }
}
```
