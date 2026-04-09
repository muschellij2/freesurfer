# Read Freesurfer Surface file

Reads a Freesurfer Surface file from the `surf/` directory from
`recon-all`

## Usage

``` r
freesurfer_read_surf(file, verbose = get_fs_verbosity())
```

## Arguments

- file:

  surface file (e.g. `lh.inflated`)

- verbose:

  (logical) print diagnostic messages

## Value

List of length 2: vertices and faces are the elements

## Examples

``` r
if (FALSE) { # have_fs()
DONTSHOW({
options(freesurfer.verbose = FALSE)
})
fname = file.path(fs_subj_dir(), "bert", "surf", "lh.inflated")
out = freesurfer_read_surf(fname)
}
```
