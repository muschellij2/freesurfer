# Resample a Volume into Another Volume's Space with FreeSurfer

Calls FreeSurfer's `mri_vol2vol` to resample the moving volume `mov`
onto the voxel grid of the target volume `targ`.

## Usage

``` r
mri_vol2vol(
  mov,
  targ,
  reg,
  outfile = NULL,
  interp = c("trilin", "nearest", "cubic"),
  opts = "",
  verbose = get_fs_verbosity(),
  ...
)

mri_vol2vol.help(...)
```

## Arguments

- mov:

  Character; the moving volume to resample (`--mov`).

- targ:

  Character; the target volume whose grid to resample onto (`--targ`).

- reg:

  Character; a registration file (`.lta`/`.dat`) mapping `mov` to `targ`
  (`--reg`), or the string `"header"` to derive the registration from
  the volumes' headers (`--regheader`).

- outfile:

  Character; output volume (`--o`). Defaults to a temporary `.nii.gz`
  file.

- interp:

  Character; interpolation method (`--interp`): one of `"trilin"`,
  `"nearest"` or `"cubic"`.

- opts:

  Character. Additional options to Freesurfer function.

- verbose:

  (logical) print diagnostic messages

- ...:

  Additional arguments passed to
  [`fs_help()`](https://muschellij2.github.io/freesurfer/reference/fs_help.md)

## Value

The output filename, invisibly.

## Functions

- `mri_vol2vol.help()`: Display FreeSurfer help for mri_vol2vol

## See also

[`fs_flag_cmd()`](https://muschellij2.github.io/freesurfer/reference/fs_flag_cmd.md)
for the underlying flag-based command wrapper;
[`mri_convert()`](https://muschellij2.github.io/freesurfer/reference/mri_convert.md)
for format conversion.

## Examples

``` r
if (FALSE) { # have_fs()
if (FALSE) { # \dontrun{
# Resample a parcellation into an aseg's space using the headers
mri_vol2vol(
  "parcellation.nii.gz", "aseg.mgz",
  reg = "header", interp = "nearest"
)
} # }
}
```
