# Convert Surface Data to ASCII

This function calls `mri_convert` to convert a measure from surfaces to
an ASCII file and reads it in.

## Usage

``` r
surf_convert(file, outfile = NULL, ...)
```

## Arguments

- file:

  (character) input filename of curvature measure

- outfile:

  (character) output filename (if wanted to be saved)

- ...:

  Additional arguments to pass to
  [`fs_cmd`](https://muschellij2.github.io/freesurfer/reference/fs_cmd.md)

## Value

`data.frame`

## Examples

``` r
if (FALSE) { # have_fs()
if (FALSE) { # \dontrun{
   fname = file.path(fs_subj_dir(), "bert", "surf", "lh.thickness")
   out = surf_convert(fname)
} # }
}
```
