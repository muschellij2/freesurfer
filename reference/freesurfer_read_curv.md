# Read Freesufer Curv file

Reads a Freesurfer curvature file according to the
FREESURFER_HOME/matlab/read_curv.m file.

## Usage

``` r
freesurfer_read_curv(file)
```

## Arguments

- file:

  file name of a curvature file

## Value

Numeric vector

## Examples

``` r
if (FALSE) { # have_fs()
DONTSHOW({
options(freesurfer.verbose = FALSE)
})
bert_dir = file.path(fs_subj_dir(), "bert", "surf")
file = file.path(bert_dir, "lh.thickness")
fid = file(file, open = "rb")
out = freesurfer_read_curv(file)
}
```
