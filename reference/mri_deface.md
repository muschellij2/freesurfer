# MRI Deface

This calls Freesurfer's `mri_deface`

## Usage

``` r
mri_deface(file, brain_template = NULL, face_template = NULL, ...)
```

## Arguments

- file:

  File to pass to `mri_deface`

- brain_template:

  `gca` brain template file to pass to `mri_deface`

- face_template:

  `gca` face template file to pass to `mri_deface`

- ...:

  Additional arguments to pass to
  [`fs_cmd`](https://muschellij2.github.io/freesurfer/reference/fs_cmd.md)

## Value

Result of `fs_cmd`, which type depends on arguments to `...`

## Note

If `brain_template` or`face_template` is `NULL`, they will be
downloaded.

## Examples

``` r
if (FALSE) { # have_fs()
if (FALSE) { # \dontrun{
base_url = "https://surfer.nmr.mgh.harvard.edu/pub/dist/mri_deface"
url = file.path(base_url, "sample_T1_input.mgz")
x = temp_file(fileext = ".mgz")
out = try({
  utils::download.file(url, destfile = x)
})
if (!inherits(out, "try-error")) {
  noface = mri_deface(x)
} else {
  url = paste0(
    "https://raw.githubusercontent.com/muschellij2/kirby21.t1/master/",
    "inst/visit_1/113/113-01-T1.nii.gz")
   x = temp_file(fileext = ".nii.gz")
   out = try({
     utils::download.file(url, destfile = x)
   })
   noface = mri_deface(x)
 }
} # }
}
```
