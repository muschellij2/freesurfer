# Read FreeSurfer Anatomical Segmentation Statistics

Reads and parses an `aseg.stats` file produced by FreeSurfer's
anatomical segmentation pipeline. Returns both global brain measures and
structure- specific statistics.

## Usage

``` r
read_aseg_stats(file, lowercase = TRUE)
```

## Arguments

- file:

  Character; path to an `aseg.stats` file from FreeSurfer.

- lowercase:

  Logical; if `TRUE` (default), converts measure names and column names
  to lowercase for easier access. If `FALSE`, preserves FreeSurfer's
  original capitalization.

## Value

A list with two components:

- `measures`: A data frame with global brain measures, with columns:

  - `measure`: Short name of the measure

  - `measure_long`: Long descriptive name

  - `meaning`: Description of what the measure represents

  - `value`: Numeric value of the measure

  - `units`: Units of measurement

- `structures`: A data frame with structure-specific statistics, with
  columns:

  - `Index`: Structure index

  - `SegId`: Segmentation ID

  - `NVoxels`: Number of voxels

  - `Volume_mm3`: Volume in cubic millimeters

  - `StructName`: Name of the anatomical structure

  - `normMean`: Normalized mean intensity

  - `normStdDev`: Normalized standard deviation

  - `normMin`: Normalized minimum

  - `normMax`: Normalized maximum

  - `normRange`: Normalized range

## Details

The `aseg.stats` file contains volumetric and morphometric statistics
for subcortical structures and global brain measures computed by
FreeSurfer's `recon-all` pipeline.

### Output Structure

The function returns a list with two data frames:

**measures**: Global brain measures including:

- Brain segmentation volume

- Estimated total intracranial volume (eTIV)

- Normalization factors

**structures**: Structure-specific measures including:

- Structure index and name

- Number of voxels

- Volume (mm³)

- Mean intensity and standard deviation

- Minimum, maximum, and range of intensities

### File Location

For a subject processed with `recon-all`, the file is typically located
at: `$SUBJECTS_DIR/<subject_id>/stats/aseg.stats`

## See also

- [`read_fs_table()`](https://muschellij2.github.io/freesurfer/reference/read_fs_table.md)
  for reading other FreeSurfer tables

- [`recon_all()`](https://muschellij2.github.io/freesurfer/reference/recon.md)
  for running the FreeSurfer pipeline

- [`stats2table()`](https://muschellij2.github.io/freesurfer/reference/stats2table.md)
  for combining stats from multiple subjects

## Examples

``` r
if (FALSE) { # have_fs()
# Read stats for the "bert" example subject
file <- file.path(fs_subj_dir(), "bert", "stats", "aseg.stats")

if (file.exists(file)) {
  out <- read_aseg_stats(file)

  # Examine global measures
  print(head(out$measures))

  # Get estimated total intracranial volume
  etiv <- out$measures$value[out$measures$measure == "estimatedtotalintracranialvol"]
  cat("eTIV:", etiv, "mm³\n")

  # Examine structure-specific stats
  print(head(out$structures))

  # Get hippocampal volumes
  hippo <- out$structures[grepl("Hippocampus", out$structures$StructName), ]
  print(hippo[, c("StructName", "Volume_mm3")])
}
}
```
