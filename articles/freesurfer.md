# Getting Started and Setting Up \`freesurfer\` in R

Freesurfer is a widely-used software package for processing and
analyzing anatomical neuroimaging data (Fischl 2012). Developed by the
Laboratory for Computational Neuroimaging at the Athinoula A. Martinos
Center for Biomedical Imaging, it offers a suite of open-source,
command-line tools. These tools handle essential image processing tasks
such as:

- Brain extraction or skull-stripping, which removes non-brain tissues
  from images (Segonne, Dale, and Fischl 2004).
- Bias-field correction, which corrects for intensity non-uniformities
  in MRI scans (Sled, Zijdenbos, and Evans 1998).
- Segmentation of brain structures, allowing for the identification and
  measurement of different regions (Fischl et al. 2002, 2004).
- Image registration, which aligns different brain images to a common
  space (Fischl, Sereno, and Dale 1999; Reuter, Rosas, and Fischl 2010).

Beyond these individual functions, Freesurfer also provides
fully-automated pipelines that streamline complex processing workflows.

While R offers several powerful packages for image data, such as
`AnalyzeFMRI` (Bordier, Poline, and Thirion 2011) and `fmri` (Tabelow et
al. 2011) for functional MRI analysis and spatial smoothing, `RNiftyReg`
(Modat et al. 2013) for image registration, and `dpmixsim` (CRAN 2024)
and `mritc` (CRAN 2023) for image clustering and segmentation (see the
[Medical Imaging CRAN task
view](http://cran.r-project.org/web/views/MedicalImaging.md) for more),
the neuroimaging community has developed even more specialized tools
that might perform better on specific datasets or offer more
comprehensive information. Freesurfer, for instance, includes methods
not currently implemented in R, such as surface-based registration and
completely automated image segmentation pipelines.

The `ANTsR` package (available on
[GitHub](https://github.com/stnava/ANTsR)), an unpublished R package,
has implemented additional image analysis functionality, but it doesn’t
encompass everything Freesurfer offers. Having multiple options for
image processing directly within R empowers users to compare different
methods and provides the flexibility to combine various packages to
create a robust data processing pipeline.

This `freesurfer` package serves as an interface, allowing R users to
leverage Freesurfer’s state-of-the-art anatomical processing
capabilities, along with a suite of tools that simplify analyzing
Freesurfer’s output. Our goal is to enable R users to perform complete
anatomical imaging analyses without needing to learn Freesurfer’s
specific command-line syntax, keeping both the image processing and
analysis seamlessly integrated within R.

## Setting Up Your R Environment for `freesurfer`

To use the `freesurfer` R package, you’ll first need a working
installation of Freesurfer itself. You can download and install
Freesurfer from its [official
website](http://freesurfer.net/fswiki/DownloadAndInstall).

The `freesurfer` R package relies on successfully detecting your
Freesurfer installation. The core of this detection process is handled
by a series of functions
[`get_fs_home()`](https://muschellij2.github.io/freesurfer/reference/get_fs_setting.md),
which attempts to locate your `FREESURFER_HOME` directory.

The detection process for `FREESURFER_HOME` follows a specific order:

1.  It looks for the R option `getOption("freesurfer.home")`.  
2.  If that is not found, `freesurfer` checks your system’s environment
    variables for `FREESURFER_HOME`.  
3.  As a last resort, it tries common default installation paths, such
    as:
    - `/usr/local/freesurfer`  
    - `/Applications/freesurfer`  
    - `/usr/freesurfer`
    - `/usr/bin/freesurfer`

As a first step, use the
[`fs_sitrep()`](https://muschellij2.github.io/freesurfer/reference/fs_sitrep.md)
function to get detailed information about the setup between R and
Freesurfer on your system.

``` r
library(freesurfer)

fs_sitrep()
```

This function provides useful information about which issues may be
present regarding the integration of R and Freesurfer on your system.
Ideally all checks should pass with a green tick. Any red ticks or
warnings should be addressed to ensure smooth use of this package. As
you can see, there are several things to make sure are in order. As a
minimun, you should have the `freesurfer.home` option or
`FREESURFER_HOME` variable set. If you see a red tick for
`freesurfer.home` or `FREESURFER_HOME`, it means that the package cannot
find your Freesurfer installation. However, as long as this is set and
has a green tick, the remaining options are likely set to sensible
defaults.

### Setting Up Freesurfer Options

When you’re running R from a shell environment, `freesurfer` will
automatically use the `FREESURFER_HOME` environment variable (which is
typically set during Freesurfer installation) as the path to your
Freesurfer directory. However, if you’re using R through a graphical
user interface (GUI) like RStudio, environment variables and paths might
not be explicitly exported, meaning `FREESURFER_HOME` might not be set.
In such cases, `freesurfer` will try the default directories for macOS
and Linux. If your Freesurfer installation isn’t in a standard location,
you can manually specify its path using
`options(freesurfer.home="/path/to/freesurfer")`. Please note that
Freesurfer is only available on Windows via a virtual machine.

While R may detect your system variables, as mentioned above, any
`options` set in either your project or user `.Rprofile`, or in the
script you are running, will take precedence over the system settings.
This makes is possible for you to set script or project specific options
and get more control over how Freesurfer is used in your analyses.

To set these options in your `.Rprofile` file, you can open these with
functions like `usethis::edit_r_profile("user")` and
`usethis::edit_r_profile("project)`. We highly recommend using the
project `.Rprofile` if you are in a shared environment, have a project
several people access, and have a common installation of Freesurfer to
access. On your personal computer, its likely you’d rather set the
variables in your user `.Rprofile`. Possible options to set are:

``` r
options(
    freesurfer.home = "/path/to/freesurfer",
    freesurfer.subj_dir = "/path/to/freesurfer/subjects",
    freesurfer.license = "/path/to/freesurfer/.license",
    freesurfer.output_type = "hdr",
    freesurfer.sh = "/path/to/freesurfer/FreeSurferEnv.sh",
    freesurfer.mni_dir = "/Applications/freesurfer/mni/Library/Perl/Updates/5.12.3",
    freesurfer.verbose = TRUE
)

# or using environment variables
Sys.setenv(
    FREESURFER_HOME = "/path/to/freesurfer",
    FREESURFER_SUBJ_DIR = "/path/to/freesurfer/subjects",
    FS_LICENSE = "/path/to/freesurfer/.license",
    FSF_OUTPUT_FORMAT = "hdr",
    FREESURFER_SH = "/path/to/freesurfer/FreeSurferEnv.sh",
    MNI_DIR = "/Applications/freesurfer/mni/Library/Perl/Updates/5.12.3",
    FREESURFER_VERBOSE = TRUE
)
```

But if you are more comfortable using environment variables, you can
also both have user and project specific `.Renviron`, just like
`.Rprofile`. You can open these with functions like
`usethis::edit_r_environ("user")` and
`usethis::edit_r_environ("project)`

Once the options are set, restart your R session, and try another
[`fs_sitrep()`](https://muschellij2.github.io/freesurfer/reference/fs_sitrep.md)
which should now use the options you have provided. The
`freesurfer.verbose` option is particularly useful for debugging, as it
will print out additional information about the Freesurfer commands
being executed.

### Check if Freesurfer is installed

The `have_fs` function is a handy tool that checks if you have a
Freesurfer installation. It returns a logical value (TRUE or FALSE),
which is very useful for conditional statements in your code. You can
also ask it to check for the presence of a license file by specifying
`check_license = TRUE`.

``` r
have_fs()

if (have_fs()) {
  print("Freesurfer is installed! Huzzah!")
}
```

Be aware that the
[`have_fs()`](https://muschellij2.github.io/freesurfer/reference/have_fs.md)
function is simple in that it check if the
[`fs_dir()`](https://muschellij2.github.io/freesurfer/reference/fs_dir.md)
actually exists or not. It does not make any validation of whether this
Freesurfer installation and R are set up correctly to work together. So
make sure your
[`fs_sitrep()`](https://muschellij2.github.io/freesurfer/reference/fs_sitrep.md)
looks good, first and foremost, then
[`have_fs()`](https://muschellij2.github.io/freesurfer/reference/have_fs.md)
is a convenient tool for scripting logic.

## Understanding Freesurfer Output Formats

Freesurfer commands often default to a specific output format for image
files, which is controlled by the option `freesurfer.output_type` or
`FSF_OUTPUT_FORMAT` environment variable. You can check this setting
using
[`get_fs_output()`](https://muschellij2.github.io/freesurfer/reference/get_fs_setting.md).
If it’s not explicitly set, it typically defaults to `nii.gz`. You can
also retrieve the corresponding file extension with
[`fs_imgext()`](https://muschellij2.github.io/freesurfer/reference/fs_imgext.md).

``` r
get_fs_output()
fs_imgext()
```

### Understanding how `get_fs()` fascilitates Freesurfer calls

The
[`get_fs()`](https://muschellij2.github.io/freesurfer/reference/get_fs.md)
function is a crucial utility in this R package for interacting with
FreeSurfer. Its primary purpose is to generate a shell command string
that correctly configures your environment to run FreeSurfer commands,
ensuring that the FreeSurfer executables, license, and other necessary
settings are properly recognized by your system.

#### Why is `get_fs()` important?

As described above, FreeSurfer relies on specific environment variables
and setup scripts to function correctly. Without these, your R session
wouldn’t know where to find the FreeSurfer programs (like `recon-all` or
`mri_convert`), or how to handle their output. While the
[`fs_sitrep()`](https://muschellij2.github.io/freesurfer/reference/fs_sitrep.md)
will help you get setup up correctly, its the
[`get_fs()`](https://muschellij2.github.io/freesurfer/reference/get_fs.md)
that powers the Freesurfer-R integration after this. Based on the
settings you have provided (or default ones if you have not),
[`get_fs()`](https://muschellij2.github.io/freesurfer/reference/get_fs.md)
will create a string that will prefix any Freesurfer command that is
called from R. Depending on your system setup, and the complexity of the
Freesurfer function called, this string is a vital component to running
the Freesurfer commands from R and capturing their results.

#### How it works

[`get_fs()`](https://muschellij2.github.io/freesurfer/reference/get_fs.md)
follows a logical hierarchy to determine and set up your FreeSurfer
environment:

1.  **Finding `FREESURFER_HOME`** as described above

2.  **License Check**:

    - Once `FREESURFER_HOME` is identified,
      [`get_fs()`](https://muschellij2.github.io/freesurfer/reference/get_fs.md)
      checks for the presence of a FreeSurfer license file (either
      `license.txt` or `.license`) within that directory.
    - If the license file is not found, a warning will be issued, as
      FreeSurfer may not run correctly without a valid license.

3.  **Handling Binary Application Directory (`bin_app`)**:

    - The `bin_app` argument allows you to specify a subdirectory within
      `FREESURFER_HOME` where the main executables are located. Common
      values are:
      - `"bin"`: This is the most typical location for FreeSurfer’s core
        binaries.
      - `"mni/bin"`: If you need to use FreeSurfer’s MNI (Montreal
        Neurological Institute) related tools, this option will ensure
        that the necessary MNI Perl startup scripts are initialized,
        which is crucial for those functions to work.
      - `""`: This option is for cases where the executables are
        directly in the `FREESURFER_HOME` directory, without a
        subdirectory.

4.  **Sourcing `FreeSurferEnv.sh`**:

    - FreeSurfer often includes a shell script called `FreeSurferEnv.sh`
      in its installation directory. This script performs additional,
      more detailed environment configurations.

5.  **Setting Output Format**:

    - The function also sets the `FSF_OUTPUT_FORMAT` environment
      variable, which dictates the default image format for FreeSurfer’s
      output (e.g., `.nii.gz` for compressed NIfTI files).

6.  **Generating the Command String**:

    - Finally,
      [`get_fs()`](https://muschellij2.github.io/freesurfer/reference/get_fs.md)
      consolidates all these steps into a single bash command string.
      This string includes `export` commands for environment variables
      and commands to source necessary setup scripts, followed by the
      path to the FreeSurfer binary directory. This complete command
      string is what
      [`fs_cmd()`](https://muschellij2.github.io/freesurfer/reference/fs_cmd.md)
      (and potentially other functions in your package) will execute in
      the background to run FreeSurfer tools.

### Example Usage

In most cases, you will never directly need to run this command. But it
is good to know of it, how it works and what it’s output is.

``` r
# Generate a shell command to set up FreeSurfer with the default `bin` directory
get_fs(bin_app = "bin")

# Generate a shell command to include MNI environment setup
# This is important if you plan to use FreeSurfer's MNI tools.
get_fs(bin_app = "mni/bin")
```

By using
[`get_fs()`](https://muschellij2.github.io/freesurfer/reference/get_fs.md),
you ensure that your R interactions with FreeSurfer are robust and
correctly configured, abstracting away the complexities of shell
environment management.

## Organizing Your Freesurfer Analyses

During Freesurfer installation, several environment variables are set in
addition to `FREESURFER_HOME`. One of these is `SUBJECTS_DIR`, which
points to a directory containing the analysis output for all your
subjects.

The `fs_subj_dir` function will return the path to this Freesurfer
subjects directory if it’s already set. If not, it defaults to
`file.path(fs_dir(), "subjects")`.

``` r
fs_subj_dir()
```

You also have the flexibility to explicitly set the
`freesurfer.subj_dir` option or `SUBJECTS_DIR` environment variable.

This default `SUBJECTS_DIR` setup in Freesurfer allows you to simply
specify a subject identifier when running analyses, rather than needing
to provide a specific file path or multiple intermediate files.

However, this default setup might not be ideal if you prefer to
structure your data differently. For example, if you have data from
multiple studies, you might want to organize them into different folders
located in various places.

Some Freesurfer functions rely on the `SUBJECTS_DIR` variable to run.
These functions typically take the subject name as their primary
argument, rather than a file path, which is a more common approach in
other tools. To offer maximum flexibility, `freesurfer` allows most
functions to specify a file or a different directory, rather than solely
relying on the `SUBJECTS_DIR` and subject name. Let’s look at an
example: the `asegstats2table` Freesurfer function.

Freesurfer performs segmentations of anatomical images into distinct
structures, and it provides associated statistics for each region, such
as volume and mean intensity. The `asegstats2table` function transforms
these anatomical segmentation statistics from images into a structured
table. By default, `asegstats2table` expects you to pass in a subject
name rather than a direct file path. However, the `freesurfer`
`asegstats2table` function in R allows you to specify either the subject
name *or* an alternative file name.

When you specify a file name, the function temporarily sets
`SUBJECTS_DIR` to a temporary directory, copies your file there,
executes the Freesurfer command, and then resets the `SUBJECTS_DIR`
variable to its original state. This provides a much more flexible
workflow, allowing you to manage your data structure without overriding
the default `SUBJECTS_DIR`. This means you can have separate folders for
subjects and easily read in data by simply switching the `subj_dir`
argument in the R function. The lookup order for using a subject
directory is:

1.  function argument  
2.  `options(freesurfer.subj_dir = "/path/to/freesurfer/subjects")`  
3.  System variable (`Sys.getenv("FREESURFER_SUBJ_DIR")`)
4.  `file.path(fs_dir(), "subjects")`
    - Which *may* utilise educated guesses based on common Freesurfer
      installation paths.

Bordier, Cynthia, Jean-Baptiste Poline, and Bertrand Thirion. 2011.
“Temporal and Spatial Smoothing for fMRI Data Based on a Bayesian
Hierarchical Model.” *Statistical Methods in Medical Research* 20 (3):
201–23.

CRAN. 2023. “mritc: Image Clustering and Segmentation.”
<https://CRAN.R-project.org/package=mritc>.

———. 2024. “dpmixsim: An r Package for Bayesian Nonparametric Mixture
Models.” <https://CRAN.R-project.org/package=dpmixsim>.

Fischl, Bruce. 2012. “FreeSurfer.” *Neuroimage* 62 (2): 774–81.

Fischl, Bruce, David H Salat, Evelina Busa, Matthew Albert, Mark
Schaberg, Douglas N Greve, Anders M Dale, et al. 2002. “Whole-Brain
Segmentation: Automated Labeling of Neuroanatomical Structures in the
Human Brain.” *Neuron* 33 (3): 341–55.

Fischl, Bruce, David H Salat, Andre JW van der Kouwe, Nikos Makris,
Florent Segonne, Anders M Dale, Anders M Dale, et al. 2004.
“Sequence-Independent Segmentation of Subcortical Brain Structures Using
a Probabilistic Atlas.” *Neuroimage* 23 (1): S69–84.

Fischl, Bruce, Martin I Sereno, and Anders M Dale. 1999.
“High-Resolution Intersubject Averaging and a Coordinate System for the
Human Brain.” *Human Brain Mapping* 8 (4): 272–84.

Modat, Marc, David M Cash, Pradnya Daga, Kyana Dourado, and and others.
2013. “RNiftyReg: An r Package for Image Registration.” *Journal of
Statistical Software* 55 (10): 1–22.

Reuter, Martin, H Augusto Rosas, and Bruce Fischl. 2010. “Highly
Accurate Inverse Consistent Registration: A Robust Approach to
Longitudinal Registered Brain Image Analysis.” *Neuroimage* 53 (4):
1181–95.

Segonne, Florent, Anders M Dale, and Bruce Fischl. 2004. “A Hybrid
Approach to the Skull-Stripping Problem in MRI.” *Neuroimage* 22 (3):
1060–75.

Sled, John G, Alex P Zijdenbos, and Alan C Evans. 1998. “A Nonparametric
Method for the Correction of Intensity Nonuniformity in MRI Data.” *IEEE
Transactions on Medical Imaging* 17 (1): 87–97.

Tabelow, Karsten, Jörg Polzehl, Helga U Voss, et al. 2011. “Statistical
Analysis of fMRI Data in r.” *Neuroimage* 58 (4): 1117–26.
