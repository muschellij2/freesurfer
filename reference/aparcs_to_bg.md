# Convert Freesurfer aparcs Table to brainGraph

Converts Freesurfer aparcs table to brainGraph naming convention,
relying on
[`aparcstats2table`](https://muschellij2.github.io/freesurfer/reference/stats2table.md)

## Usage

``` r
aparcs_to_bg(subjects, measure, clean_col_names = TRUE, ...)
```

## Arguments

- subjects:

  subjects to analyze, passed to
  [`aparcstats2table`](https://muschellij2.github.io/freesurfer/reference/stats2table.md)

- measure:

  measure to be analyzed, passed to
  [`aparcstats2table`](https://muschellij2.github.io/freesurfer/reference/stats2table.md)

- clean_col_names:

  logical indicating whether to clean column names

- ...:

  additional arguments passed to
  [`aparcstats2table`](https://muschellij2.github.io/freesurfer/reference/stats2table.md)

## Value

Long `data.frame`

## Examples

``` r
if (FALSE) { # have_fs()
if (FALSE) { # \dontrun{
fs_subj_dir()
df = aparcs_to_bg(subjects = "bert", measure = "thickness")
print(head(df))
} # }
}
```
