# Convert Freesurfer Surface

Reads in a surface file from Freesurfer and separates into vertices and
faces

## Usage

``` r
convert_surface(infile, ...)
```

## Arguments

- infile:

  Input surface file

- ...:

  additional arguments to pass to
  [`mris_convert`](https://muschellij2.github.io/freesurfer/reference/mris_convert.md)

## Value

List of 3 elements: a header indicating the number of vertices and
faces, the vertices, and the faces

## Note

This was adapted from the gist:
<https://gist.github.com/mm--/4a4fc7badacfad874102>

## Examples

``` r
if (FALSE) { # have_fs()
if (FALSE) { # \dontrun{
infile = file.path(fs_subj_dir(),
                   "bert", "surf", "rh.pial")
res = convert_surface(infile = infile)
} # }
}
```
