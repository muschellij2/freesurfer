# Generalized Stats to Table

This function serves as a flexible abstraction to execute the FreeSurfer
commands `asegstats2table` or `aparcstats2table`, which are primarily
used to convert parcellation and segmentation statistics to tabular
formats. The function dynamically handles shared logic, constructs
command-line arguments, and runs the appropriate FreeSurfer command.
Users can specify the type of input (subjects or input file paths) and
various configuration options. With the appropriate parameters, it
constructs and executes the matching system command.

## Usage

``` r
stats2table(
  type = c("aseg", "aparc"),
  input,
  measure,
  input_type = c("subjects", "inputs"),
  outfile = NULL,
  delim = c("tab", "space", "comma", "semicolon"),
  skip = TRUE,
  subj_dir = NULL,
  opts = "",
  verbose = get_fs_verbosity(),
  ...
)

asegstats2table(
  subjects = NULL,
  inputs = NULL,
  measure = c("volume", "mean", "std"),
  ...
)

aparcstats2table(
  subjects,
  hemi = c("lh", "rh"),
  measure = c("area", "volume", "thickness", "thicknessstd", "meancurv", "gauscurv",
    "foldind", "curvind"),
  parc = c("aparc", "aparc.a2009s"),
  opts = "",
  ...
)

aparcstats2table.help(...)

asegstats2table.help(...)
```

## Arguments

- type:

  (character) Either "aparc" for cortical parcellation or "aseg" for
  subcortical segmentation.

- input:

  (character) A vector representing either subject IDs (for
  `input_type = "subjects"`) or file paths (for `input_type = "inputs"`,
  applicable only to `aseg`).

- measure:

  (character) The measurement to calculate. For example, "thickness" for
  cortical measures or "volume" for subcortical.

- input_type:

  (character) Specifies the type of `input`. Must be one of "subjects"
  or "inputs".

- outfile:

  (character) Name of the output file. If not specified, a temporary
  file will be created based on the specified delimiter.

- delim:

  (character) Delimiter for the output file. This can be one of: "tab",
  "space", "comma", or "semicolon". The output file's delimiter is
  stored as an attribute for programmatic access.

- skip:

  (logical) If `TRUE`, skips invalid inputs (e.g., missing files or
  data) without throwing errors.

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

- subjects:

  (character) A vector of subject identifiers. This is the primary way
  to specify inputs when using this function.

- inputs:

  (character paths) A vector of input filenames, e.g. `aseg.stats`.
  Alternatively, use `subjects` to specify subject IDs.

- hemi:

  (character) The hemisphere for which statistics are computed. Options
  are "lh" (left hemisphere) or "rh" (right hemisphere).

- parc:

  (character) Specifies the parcellation scheme to be used. Options
  include "aparc" or "aparc.a2009s".

## Value

A character string: the path to the output file with its delimiter
stored as an attribute.

## Functions

- `asegstats2table()`: Converts subcortical segmentation statistics into
  tabular format by calling the FreeSurfer `asegstats2table` command.
  `...` is passed to stats2table for additional options.

- `aparcstats2table()`: Converts cortical parcellation statistics into
  tabular format by calling the FreeSurfer `aparcstats2table` command.
  `...` is passed to stats2table for additional options.\`

- `aparcstats2table.help()`: Display FreeSurfer help for
  aparcstats2table

- `asegstats2table.help()`: Display FreeSurfer help for asegstats2table

## Examples

``` r
if (FALSE) { # have_fs()
if (FALSE) { # \dontrun{
# Example for asegstats2table
outfile_aseg <- asegstats2table(
    subjects = "bert",
    measure = "mean",
    delim = "tab"
)
print(outfile_aseg)

# Example for aparcstats2table
outfile_aparc <- aparcstats2table(
  subjects = "bert",
  hemi = "lh",
  measure = "thickness",
  delim = "tab",
  opts = "--etiv --scale=1.0"
)
print(outfile_aparc)
} # }
}
```
