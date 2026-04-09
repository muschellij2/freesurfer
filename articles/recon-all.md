# Running \`recon-all\`

This vignette demonstrates how to use the `freesurfer` functions
(`recon_all`, `recon`, and `reconner`) to interact with Freesurfer’s
`recon-all` pipeline, perform full-brain reconstruction, and customize
the pipeline based on your specific requirements.

The Freesurfer reconstruction tools are widely used in neuroimaging for
creating cortical surface models and volumetric segmentation. Using
these wrapper functions in R allows seamless integration of Freesurfer
pipelines into your analysis workflows, enabling reproducible research.

### Running the Freesurfer `recon-all` Pipeline

The `recon_all` function provides a streamlined way to run Freesurfer’s
`recon-all` pipeline with default settings. You need to provide the
`infile` (the input MRI file, which can be in DICOM or NIfTI format)
and/or the `subjid` (a unique ID for the subject). If a subject id is
omitted, the function will create one based on the input file name.
Alternatively, you can specify the subject ID explicitly using the
`subjid` parameter, and even omit the input file if you have the data
necessary already in the Freesurfer subject direcoty. Optionally, you
can specify an output directory using `outdir`.

Here’s a simple example:

``` r
library(freesurfer)
```

``` r
# Run the full Freesurfer pipeline on an input NIfTI file
recon_all(
  infile = "subject01.nii",
  subjid = "subject01",
  outdir = "output_dir"
)
```

This will execute all necessary steps for cortical reconstruction and
save the results in the directory `output_dir/subject01`.

#### Restarting the Reconstruction Pipeline

If the pipeline is interrupted or you need to restart the pipeline, you
can specify additional options using the `opts` parameter. For example:

``` r
# Restart the entire pipeline from the beginning
recon_all(
  infile = "subject01.nii",
  subjid = "subject01",
  outdir = "output_dir",
  opts = "-make all",
  verbose = TRUE
)
```

### Customizing the Pipeline with `recon`

The `recon` function provides more granular control over the Freesurfer
pipeline. You can specify which steps to include or exclude using the
`options` argument.

#### Running All Steps (Default)

By default, all processing steps are included:

``` r
# Run the pipeline with all steps enabled
recon(
  infile = "subject01.nii",
  subjid = "subject01",
  outdir = "output_dir"
)
```

#### Customizing Steps

To customize the pipeline, create a logical vector of steps using
[`recon_steps()`](https://muschellij2.github.io/freesurfer/reference/recon.md),
modify it, and pass it to the `options` argument.

``` r
# Customize the pipeline to skip Talairach alignment and normalization
custom_steps <- recon_steps()
custom_steps
#>      motioncor nuintensitycor      talairach  normalization     skullstrip 
#>           TRUE           TRUE           TRUE           TRUE           TRUE 
#>         gcareg         canorm          careg         rmneck      skull-lta 
#>           TRUE           TRUE           TRUE           TRUE           TRUE 
#>        calabel normalization2   segmentation           fill     tessellate 
#>           TRUE           TRUE           TRUE           TRUE           TRUE 
#>        smooth1       inflate1        qsphere            fix     finalsurfs 
#>           TRUE           TRUE           TRUE           TRUE           TRUE 
#>        smooth2       inflate2     cortribbon         sphere        surfreg 
#>           TRUE           TRUE           TRUE           TRUE           TRUE 
#>  contrasurfreg        avgcurv       cortparc      parcstats      cortparc2 
#>           TRUE           TRUE           TRUE           TRUE           TRUE 
#>     parcstats2     aparc2aseg 
#>           TRUE           TRUE

custom_steps["talairach"] <- FALSE # Skip Talairach alignment
custom_steps["normalization"] <- FALSE # Skip image normalization
custom_steps
#>      motioncor nuintensitycor      talairach  normalization     skullstrip 
#>           TRUE           TRUE          FALSE          FALSE           TRUE 
#>         gcareg         canorm          careg         rmneck      skull-lta 
#>           TRUE           TRUE           TRUE           TRUE           TRUE 
#>        calabel normalization2   segmentation           fill     tessellate 
#>           TRUE           TRUE           TRUE           TRUE           TRUE 
#>        smooth1       inflate1        qsphere            fix     finalsurfs 
#>           TRUE           TRUE           TRUE           TRUE           TRUE 
#>        smooth2       inflate2     cortribbon         sphere        surfreg 
#>           TRUE           TRUE           TRUE           TRUE           TRUE 
#>  contrasurfreg        avgcurv       cortparc      parcstats      cortparc2 
#>           TRUE           TRUE           TRUE           TRUE           TRUE 
#>     parcstats2     aparc2aseg 
#>           TRUE           TRUE
```

``` r
# Run the pipeline with customized steps
recon(
  infile = "subject01.nii",
  subjid = "subject01",
  outdir = "output_dir",
  options = custom_steps
)
```

#### Adding Verbose Output

For detailed logging, set `verbose = TRUE`:

``` r
# Example with verbose output
recon(
  infile = "subject01.nii",
  subjid = "subject01",
  outdir = "output_dir",
  verbose = TRUE
)
```

### Running Specific Stages of Reconstruction

If you want to run specific stages of the `recon-all` pipeline, you can
use the helper functions: -
[`autorecon1()`](https://muschellij2.github.io/freesurfer/reference/recon_manual.md):
Motion correction to skull stripping (steps 1-5). -
[`autorecon2()`](https://muschellij2.github.io/freesurfer/reference/recon_manual.md):
Further processing (e.g., intensity normalization and registration). -
[`autorecon3()`](https://muschellij2.github.io/freesurfer/reference/recon_manual.md):
Final stages, including surface reconstruction and quality checks.

``` r
# Run stages individually
autorecon1(
  infile = "subject_001.nii",
  subjid = "subject01",
  outdir = "/output_dir",
  verbose = TRUE
)

autorecon2(
  infile = "subject_001.nii",
  subjid = "subject01",
  outdir = "/output_dir",
  verbose = TRUE
)

autorecon3(
  infile = "subject_001.nii",
  subjid = "subject01",
  outdir = "/output_dir",
  verbose = FALSE  # Disable verbose logging
)
```

### Advamced use with the Low-Level `reconner` Function

`reconner` is a lower-level function that interfaces directly with
Freesurfer’s `recon-all` command. It allows you to specify command-line
options directly, giving you maximum flexibility for advanced use cases.
The recon functions mentioned above are built on top of this function,
providing higher-level abstractions for common use cases. It is useful
for advanced users who need complete control over the command-line
options.

#### Basic Usage

``` r
# Basic example with default options
reconner(
  infile = "subject01.nii",
  outdir = "output_dir",
  subjid = "subject01",
  opts = "-all"
)
```

#### Force Execution

If the subject directory already exists and you want to force
re-execution, set `force = TRUE`:

``` r
# Force reconstruction
reconner(
  infile = "subject01.nii",
  outdir = "output_dir",
  subjid = "subject01",
  opts = "-all",
  force = TRUE
)
```

## Summary of Functions

- `recon_all`: High-level wrapper for a fully automated `recon-all`
  pipeline.
- Autorecon Functions:
  - `autorecon1`: Executes the initial stages of the Freesurfer pipeline
    (motion correction to skull stripping).
  - `autorecon2`: Handles intermediate stages like intensity
    normalization and registration.
  - `autorecon3`: Processes final stages, including surface
    reconstruction and quality checks.
- `recon`: Intermediate-level function for customizing individual
  pipeline steps.
- `reconner`: Advanced Low-level wrapper for maximum flexibility with
  `recon-all`.

## Conclusion

This vignette has demonstrated how to utilize `{your_package_name}` for
Freesurfer-based brain image reconstruction workflows. Whether you need
fully automated processing or advanced customization, these functions
allow you to integrate sophisticated neuroimaging pipelines into your R
workflows.

For further details, please refer to the individual function
documentation.
