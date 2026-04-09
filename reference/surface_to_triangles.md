# Convert Freesurfer Surface to Triangles

Reads in a surface file from Freesurfer and converts it into triangles

## Usage

``` r
surface_to_triangles(infile, ...)
```

## Arguments

- infile:

  Input surface file

- ...:

  additional arguments to pass to
  [`convert_surface`](https://muschellij2.github.io/freesurfer/reference/convert_surface.md)

## Value

Matrix of triangles with the number of rows equal to the number of faces
(not the triplets - total faces)

## Examples

``` r
if (FALSE) { # have_fs() && requireNamespace("rgl", quietly = TRUE)
if (FALSE) { # \dontrun{
infile = file.path(fs_subj_dir(),
                   "bert", "surf", "rh.pial")
right_triangles = surface_to_triangles(infile = infile)
infile = file.path(fs_subj_dir(),
                   "bert", "surf", "lh.pial")
left_triangles = surface_to_triangles(infile = infile)
rgl::open3d()
rgl::triangles3d(right_triangles,
color = rainbow(nrow(right_triangles)))
rgl::triangles3d(left_triangles,
color = rainbow(nrow(left_triangles)))

infile = file.path(fs_subj_dir(),
                   "bert", "surf", "rh.inflated")
right_triangles = surface_to_triangles(infile = infile)
infile = file.path(fs_subj_dir(),
                   "bert", "surf", "lh.inflated")
left_triangles = surface_to_triangles(infile = infile)
rgl::open3d()
rgl::triangles3d(left_triangles,
color = rainbow(nrow(left_triangles)))
rgl::triangles3d(right_triangles,
color = rainbow(nrow(right_triangles)))
} # }
}
```
