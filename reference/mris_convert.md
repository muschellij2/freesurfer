# Convert Cortical Surface File Formats with FreeSurfer

These functions call FreeSurfer's `mris_convert` to convert between
cortical surface file formats. The base function `mris_convert()`
provides general conversion, while specialized variants handle specific
data types.

## Usage

``` r
mris_convert(
  infile,
  outfile = NULL,
  ext = ".asc",
  opts = "",
  verbose = get_fs_verbosity(),
  ...
)

mris_convert_annot(annot, opts = "", ...)

mris_convert_curv(curv, opts = "", ...)

mris_convert_normals(opts = "", ...)

mris_convert_vertex(opts = "", ...)

mris_convert.help(...)
```

## Arguments

- infile:

  Character; path to input surface file.

- outfile:

  Character; path to output file. If NULL, a temporary file with the
  specified extension is created.

- ext:

  Character; output file extension when `outfile` is NULL. Default is
  ".asc".

- opts:

  Character. Additional options to Freesurfer function.

- verbose:

  (logical) print diagnostic messages

- ...:

  Additional arguments passed to `mris_convert`.

- annot:

  Character; path to annotation or gifti label file.

- curv:

  Character; path to scalar curvature overlay file.

## Value

Character; path to the output file. For `mris_convert()`, the output has
a "separator" attribute indicating the file's field separator.

## Details

FreeSurfer's `mris_convert` is a general conversion program for cortical
surface file formats. It can convert between binary and ASCII formats,
extract specific data types, and transform between coordinate systems.

## Functions

- `mris_convert_annot()`: Convert with annotation or gifti label data

- `mris_convert_curv()`: Convert with scalar curvature overlay

- `mris_convert_normals()`: Extract surface normals

- `mris_convert_vertex()`: Extract vertex coordinates

- `mris_convert.help()`: Display FreeSurfer help for mris_convert

## Note

For curvature conversions, the output filename may be modified by
FreeSurfer. You may need to prepend the hemisphere prefix to get the
correct path.

## Examples

``` r
if (FALSE) { # have_fs()
if (FALSE) { # \dontrun{
bert_dir <- file.path(fs_subj_dir(), "bert")
bert_surf <- file.path(bert_dir, "surf", "lh.white")

# Basic conversion to ASCII
asc_file <- mris_convert(infile = bert_surf)

# Convert with annotation data
gii_file <- mris_convert_annot(
  infile = bert_surf,
  annot = file.path(bert_dir, "label", "lh.aparc.annot"),
  ext = ".gii"
)

# Convert with curvature overlay
curv_file <- mris_convert_curv(
  infile = bert_surf,
  curv = file.path(bert_dir, "surf", "lh.thickness")
)

# Extract surface normals
normals_file <- mris_convert_normals(infile = bert_surf)

# Extract vertex coordinates
vertex_file <- mris_convert_vertex(infile = bert_surf)
} # }
}
```
