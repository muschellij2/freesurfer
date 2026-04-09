# Convert Freesurfer Surface to Wavefront OBJ

Reads in a surface file from Freesurfer and converts it to a Wavefront
OBJ file

## Usage

``` r
surface_to_obj(infile, outfile = NULL, ...)
```

## Arguments

- infile:

  Input surface file

- outfile:

  output Wavefront OBJ file. If `NULL`, a temporary file will be created

- ...:

  additional arguments to pass to
  [`convert_surface`](https://muschellij2.github.io/freesurfer/reference/convert_surface.md)

## Value

Character filename of output file

## Examples

``` r
if (FALSE) { # have_fs()
if (FALSE) { # \dontrun{
infile = file.path(fs_subj_dir(),
                   "bert", "surf", "rh.pial")
res = surface_to_obj(infile = infile)
} # }
}
```
