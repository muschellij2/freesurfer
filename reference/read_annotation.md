# Read Freesurfer annotation file

Reads Freesurfer binary annotation files that contain information on
vertex labels and colours for use in analyses and brain area lookups.

## Usage

``` r
read_annotation(path, verbose = get_fs_verbosity())
```

## Arguments

- path:

  path to annotation file, usually with extension `annot`

- verbose:

  logical.

## Value

list of 3 with vertices, labels, and colortable

## Details

This function is heavily based on Freesurfer's read_annotation.m
Original Author: Bruce Fischl CVS Revision Info: \$Author: greve \$
\$Date: 2014/02/25 19:54:10 \$ \$Revision: 1.10 \$

## Examples

``` r
if (FALSE) { # have_fs()
bert_dir = file.path(fs_subj_dir(), "bert")
annot_file = file.path(bert_dir, "label", "lh.aparc.annot")
res = read_annotation(annot_file)
}
```
