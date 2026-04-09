# Read Label File

Reads an `label` file from an individual subject

## Usage

``` r
read_fs_label(file)
```

## Arguments

- file:

  label file from Freesurfer

## Value

`data.frame` with 5 columns:

- `vertex_num`::

  Vertex Number

- `r_coord`::

  Coordinate in RL direction

- `a_coord`::

  Coordinate in AP direction

- `s_coord`::

  Coordinate in SI direction

- `value`::

  Value of label (depends on file)

## Examples

``` r
if (FALSE) { # have_fs()
 file = file.path(fs_subj_dir(), "bert", "label", "lh.BA1.label")
 if (!file.exists(file)) {
 file = file.path(fs_subj_dir(), "bert", "label", "lh.BA1_exvivo.label")
 }
 out = read_fs_label(file)
}
```
