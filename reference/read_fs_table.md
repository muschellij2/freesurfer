# Read FreeSurfer Table Output

This function reads output from a FreeSurfer table command, e.g.
`aparcstats2table`, `asegstats2table`

## Usage

``` r
read_fs_table(
  file,
  sep = NULL,
  header = TRUE,
  validate_format = TRUE,
  stringsAsFactors = FALSE,
  ...
)

read_stats_table(
  file,
  sep = NULL,
  header = TRUE,
  validate_format = TRUE,
  stringsAsFactors = FALSE,
  ...
)
```

## Arguments

- file:

  (character path) filename of text file

- sep:

  separator to override attribute of file, to pass to
  [`read.table`](https://rdrr.io/r/utils/read.table.html).

- header:

  Is there a header in the data

- validate_format:

  (logical) Whether to warn about unexpected formats

- stringsAsFactors:

  (logical) passed to
  [`read.table`](https://rdrr.io/r/utils/read.table.html)

- ...:

  additional arguments to
  [`read.table`](https://rdrr.io/r/utils/read.table.html)

## Value

`data.frame` from the file

## Examples

``` r
if (FALSE) { # have_fs()
outfile = aparcstats2table(
   subjects = "bert",
   hemi = "lh",
   meas = "thickness"
)
df = read_fs_table(outfile)
seg_outfile = asegstats2table(subjects = "bert", meas = "mean")
df_seg = read_fs_table(seg_outfile)
}
```
