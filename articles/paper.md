# freesurfer: R wrapper to neuroimaging software

### Introduction

Freesurfer is a commonly-used software for processing and analyzing
anatomical neuroimaging data (Fischl 2012), developed by the Laboratory
for Computational Neuroimaging at the Athinoula A. Martinos Center for
Biomedical Imaging. This software provides open-source, command-line
tools for image processing tasks such as brain
extraction/skull-stripping (Segonne, Dale, and Fischl 2004), bias-field
correction (Sled, Zijdenbos, and Evans 1998), segmentation of structures
within the brain (Fischl et al. 2002, fischl2004sequence), and image
registration Reuter, Rosas, and Fischl (2010). In addition to these
functions, Freesurfer has functions that perform fully-automated
pipelines for the user.

There exist a number of R packages for reading and manipulating image
data, including `AnalyzeFMRI` (Bordier, Poline, and Thirion 2011) and
`fmri` (Tabelow et al. 2011), which analyze functional magnetic
resonance images (MRI) and perform spatial smoothing, `RNiftyReg` (Modat
et al. 2013), which performs image registration, and `dpmixsim` (CRAN
2024) and `mritc` (CRAN 2023), which perform image clustering and
segmentation (see the [Medical Imaging CRAN task
view](http://cran.r-project.org/web/views/MedicalImaging.md) for more
information). These packages provide powerful tools for performing image
analysis, but the neuroimaging community has additional tools that may
perform better on a specific data set or provide more information than
these R packages. Freesurfer provides methods that are not currently
implemented in R, including surface-based registration and completely
automated image segmentation pipelines. The `ANTsR` package (Tustison et
al. 2021) is a currently unpublished R package where additional image
analysis functionality has been implemented, but does not include all
the functionality Freesurfer has. Moreover, having multiple options for
image processing through R enables users to compare methods and provides
the flexibility of using multiple packages to achieve a working data
processing pipeline.

We provide an interface to users to the state-of-the-art anatomical
processing implemented in Freesurfer, as well as a suite of tools that
simplify analyzing the output of Freesurfer. The `freesurfer` package
allows R users to perform a complete anatomical imaging analyses without
necessarily learning Freesurfer-specific syntax, while keeping both the
image processing and analysis within R.

### R function setup

To use `freesurfer`, a working installation of Freesurfer is required
(downloads available on the [freesurfer
website](http://freesurfer.net/fswiki/DownloadAndInstall)). The
following code was run using Freesurfer version
“freesurfer-macOS-darwin_x86_64-7.4.1-20230614-7eb8460”. The Freesurfer
version can be accessed using the `freesurfer` `fs_version` function.
The path of Freesurfer must also be set. When using R from a shell
environment, after the `FREESURFER_HOME` environment variable is set
(which is done when installing Freesurfer), `freesurfer` will use this
as the path to Freesurfer. If using R through a graphical user interface
(GUI) such as RStudio (RStudio, Boston, MA), environmental variables and
paths are not explicitly exported. Therefore, `FREESURFER_HOME` is not
set and `freesurfer` will try the default directories of Mac OSX and
Linux. Freesurfer is only available on Windows via a virtual machine. If
the user did not perform an standard installation of Freesurfer, the
path to Freesurfer can be specified using
`options(freesurfer.home="/path/to/freesurfer")`. The `have_fs` function
tests whether a user has a Freesurfer installation, returning a logical,
which is useful for `if` statements within examples. If `have_fs`
function returns `TRUE`, the `fs_dir` function will return the directory
of the Freesurfer installation.

#### Structure of Freesurfer analyses

During the installation of Freesurfer, environment variables in addition
to `FREESURFER_HOME` are set. One of these variables is `SUBJECTS_DIR`,
which refers to a directory of the output of analysis from all subjects.
The `fs_subj_dir` function will return the path to the Freesurfer
subjects directory if it is set. This default setup of a subjects
directory in Freesurfer allows users to simply specify a subject
identifier to analyze, rather than a specific path or multiple
intermediate files.

This setup may not be desirable if the user prefers to structure his or
her data differently. For example, if data from multiple studies are
present, these may be organized into different folders in different
locations. Some functions in Freesurfer rely on the `SUBJECTS_DIR`
variable to run. These functions take the subject name as the main
argument rather than a file, which is more common. To provide
flexibility to the user, `freesurfer` allows most functions to specify a
file or different directory rather than specifying the subject.

One example is the `asegstats2table` Freesurfer function. Freesurfer
performs segmentations of the anatomical image into different structures
and has associated statistics for each region such as volume and mean
intensity. The `asegstats2table` function transforms **a**natomical
**seg**mentation **stat**istics from images into to a table. The default
argument for `asegstats2table` is to pass in a subject name rather than
a file. The `freesurfer` `asegstats2table` function allows the R user to
specify the subject name, but also allows the user to alternatively
specify a file name instead. This function will temporarily set
`SUBJECTS_DIR` to a temporary directory, copy the file to that
directory, execute the command, then reset the `SUBJECTS_DIR` variable.
This provides a more flexible workflow, while not overriding the default
directory set in `SUBJECTS_DIR`. This functionality allows users to have
separate folders with subjects and read in the data by simply switching
the `subj_dir` argument in the R function.

### Reconstruction pipeline in Freesurfer

The Freesurfer pipeline and analysis workflow for neuroanatomical images
is designed to work with T1-weighted structural MRI of the brain. The
full pipeline is implemented in the Freesurfer `recon-all` function,
where the “recon” stands for
[reconstruction](https://surfer.nmr.mgh.harvard.edu/fswiki/recon-all).
The `recon-all` function is the main workhorse of Freesurfer and is the
most commonly used. Using the `-all` flag in the the `recon-all`
function performs over 30 different steps and takes [20-40
hours](https://surfer.nmr.mgh.harvard.edu/fswiki/recon-all) to fully
process a subject. This process is the recommended way of fully
processing an T1-weighted image in Freesurfer, and is implemented in the
`recon_all` `freesurfer` function.

In the `recon_all` function, users must specify the input file (a
T1-weighted image), the output directory (if different than
`SUBJECTS_DIR`), and the subject identifier. The results will be written
in the individual subject directory, a sub-directory of `SUBJECTS_DIR`.
The syntax is:

``` r
recon_all(infile, outdir, subjid)
```

If there are problems with the result of this processing, there are
multiple steps where users can edit certain parts of the processing,
such as brain extraction, where non-brain tissues are removed from the
image. The remainder of the pipeline can be run after these steps are
corrected. The full pipeline is broken down into 3 separate sets of
steps, referred to as `autorecon1`, `autorecon2`, and `autorecon3`,
which correspond to the same-named flags in `recon-all` used to initiate
these steps. We have written wrapper functions `autorecon1`,
`autorecon2`, and `autorecon3`, respectively, so users can run pieces of
the pipeline if desired or restart a failed process after correction to
the data.

### Imaging formats in `freesurfer` and R

The `freesurfer` package relies on the oro.nift (Whitcher, Muschelli,
and Johnson 2011) package implementation of images (referred to as
`nifti` objects) that are in the Neuroimaging Informatics Technology
Initiative (NIfTI) format. For Freesurfer functions that require an
image, the R `freesurfer` functions that call those Freesurfer functions
will take in a file name or a `nifti` object. The R code will convert
the `nifti` to the corresponding input required for Freesurfer. From the
user’s perspective, the input/output process is all within R, with one
object format (`nifti`). The advantage of this approach is that the user
can read in an image, do manipulations of the `nifti` object using
standard syntax for arrays, and pass this object into the `freesurfer` R
function. Thus, users can use R functionality to manipulate objects
while seamlessly passing these object to Freesurfer through
`freesurfer`.

Other Freesurfer functions require imaging formats other than NIfTI,
such as the [Medical Imaging NetCDF (MINC)
format](http://www.bic.mni.mcgill.ca/ServicesSoftware/MINC). The
Freesurfer installation provides functions to convert from MINC to NIfTI
formats and these are implemented in functions such as `nii2mnc` and
`mnc2nii` in R. Moreover, the `mri_convert` Freesurfer function has been
interfaced in `freesurfer` (same function name), which allows for a more
general conversion tool of imaging types for R users than currently
implemented in native R. Thus, many formats can be converted to NIfTI
and then read into R using the `readNIfTI` function from `oro.nifi`
(Whitcher, Schmid, and Thornton 2011).

## Example analyses and use of functions

### Reconstruction

For this paper, we will not run the analysis on a subject, but rather
explore the output results for a subject included in the Freesurfer
installation for reproducibility for the user. In particular, in the
default Freesurfer subjects directory, there is a subject named “bert”.
If we were to run all the analyses, we would use the `recon_all` code
(described below):

``` r
library(freesurfer)
```

``` r
recon_all(infile = "/path/to/T1.nii", subjid = "bert")
```

We see the result of this output in the “bert” directory, which includes
a series of sub-directories:

``` r
list.files(path = file.path(fs_subj_dir(), "bert"))
```

    [1] "label"   "mri"     "scripts" "stats"   "surf"    "tmp"     "touch"  
    [8] "trash"  

We will explore the results in “mri”, which contain imaging data,
“stats”, which containing statistics based on structures of the brain,
and “surf”, which contain the surface and curvature output from the
Freesurfer processing.

### MRI conversion: the `mri_convert` function

The typical output format of brain volumes from Freesurfer is MGH/MGZ
format, which is explained on the [freesurfer
wiki](https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/MghFormat).
As NIfTI formats are one of the most common formats and has been the
common format for analysis in the .nift and packages, it is useful to
convert these files to a NIfTI format to read into R. The `mri_convert`
Freesurfer function will be used for that conversion. Here we will use
the T1-weighted image from the “bert” subject and convert it to NIfTI,
and read it into R:

``` r
library(neurobase)

bert_dir = file.path(fs_subj_dir(), "bert") # subject directory
t1_mgz = file.path(bert_dir, "mri", "T1.mgz") # mgz file
t1_nii_fname = tempfile(fileext = ".nii.gz") # temporary NIfTI file
mri_convert(t1_mgz, t1_nii_fname) # conversion
img = readnii(t1_nii_fname) # read in outputs
```

As this is a commonly-used process, we have wrapped these two steps into
the `read_mgz` and `read_mgh` functions, which combine the `mri_convert`
and `readnii` functions. Here we show that these steps are equivalent to
the `read_mgz` function:

``` r
img_mgz = read_mgz(t1_mgz)
identical(img, img_mgz)
```

    [1] FALSE

Now that we have the image in R, we can plot it using the standard
plotting tools for `nifti` objects:

``` r
neurobase::ortho2(img, add.orient = FALSE, mask = img > 40)
```

![Plot of T1-weighted image from bert subject in
Freesurfer.](figure/mri_plot-1.png)

Plot of T1-weighted image from bert subject in Freesurfer.

The result is in figure @ref(fig:mri_plot), which contains 3 slices of
the head: axially, viewing the brain from the top of the head (top
left), sagittally, viewing the brain from the right side (top right) and
coronally, viewing the brain from the back of the head (bottom left).

Note, the image is not stored in the right/posterior/inferior (RPI)
orientation which is assumed when displaying using the `neurobase`
[`neurobase::ortho2`](https://rdrr.io/pkg/neurobase/man/ortho2.html)
function (Muschelli 2024). We can use the `rpi_orient` function in
(version $\geq$ 2.4.0) (Muschelli et al. 2015) or `fslswapdim` to
reorient the image to the assumed orientation.

``` r
reoriented_img <- orient_rpi(img)
reoriented_img
```

    $img
    NIfTI-1 format
      Type            : nifti
      Data Type       : 4 (INT16)
      Bits per Pixel  : 16
      Slice Code      : 0 (Unknown)
      Intent Code     : 0 (None)
      Qform Code      : 1 (Scanner_Anat)
      Sform Code      : 1 (Scanner_Anat)
      Dimension       : 256 x 256 x 256
      Pixel Dimension : 1 x 1 x 1
      Voxel Units     : mm
      Time Units      : sec

    $orientation
    [1] "LIA"

``` r
# Save only the image part of the result
reoriented_img <- reoriented_img$img
```

We see that this function puts this image in the RPI orientation, which
matches the assumed orientation for
[`neurobase::ortho2`](https://rdrr.io/pkg/neurobase/man/ortho2.html):

``` r
neurobase::ortho2(reoriented_img, mask = reoriented_img > 40)
```

![Plot of T1-weighted image from bert subject in Freesurfer after
re-orientation to RPI orientation. Note, the letters denote the
orientation of right/left (R/L), posterior/anterior (P/A),
inferior/superior (I/S).](figure/mri_plot2-1.png)

Plot of T1-weighted image from bert subject in Freesurfer after
re-orientation to RPI orientation. Note, the letters denote the
orientation of right/left (R/L), posterior/anterior (P/A),
inferior/superior (I/S).

The result is in figure @ref(fig:mri_plot2), which changes the views in
reference to which panel they are located and matches the orientation
markers assumed by
[`neurobase::ortho2`](https://rdrr.io/pkg/neurobase/man/ortho2.html).

### Bias-field correction: the `nu_correct` function

MRI images typically exhibit good contrast between soft tissue classes,
but intensity inhomogeneities in the radio frequency field can cause
differences in the ranges of tissue types at different spatial locations
(e.g. top versus bottom of the brain). These
inhomogeneities/non-uniformities can cause problems with algorithms
based on histograms, quantiles, or raw intensities (Zhang, Brady, and
Smith 2001).

Therefore, correction for image inhomogeneities is a crucial step in
many analyses.

The Freesurfer function `nu_correct` performs the non-uniformity
correction by Sled, Zijdenbos, and Evans (1998), and the `freesurfer`
function of the same name will run the correction and return an image.

The Freesurfer `nu_correct` function requires a [MINC
format](http://www.bic.mni.mcgill.ca/ServicesSoftware/MINC). For this to
work, you can convert the `nifti` object to a MINC file using `nii2mnc`:

``` r
mnc = nii2mnc(reoriented_img)
print(mnc)
```

    [1] "/var/folders/y5/zlbbcqn56gx1tcg6xfb425100000gp/T//RtmpSJmlJc/file663d16fe2753.mnc"

We can pass this MINC file into the `freesurfer` `nu_correct` function,
which will run the correction and then convert the output MNC to a NIfTI
object.

``` r
nu_from_mnc = nu_correct(file = mnc)
```

``` r
class(nu_from_mnc)
```

    [1] "nifti"
    attr(,"package")
    [1] "oro.nifti"

We see that the results are indeed `nifti` objects. We can plot the
estimated bias field (log-transformed for display purposes) side-by-side
with the image to view which areas had been differentially corrected
(Figure @ref(fig:nu_correct_plot)).

``` r
bias_field = finite_img(log(reoriented_img / nu_from_mnc))

double_ortho(
  nu_from_mnc,
  bias_field,
  col.y = hotmetal(),
  mask = nu_from_mnc > 40
)
```

![Inhomogeneity-corrected image output from Freesurfer ‘nu_correct’
command and the estimated log bias-field.](figure/nu_correct_plot-1.png)

Inhomogeneity-corrected image output from Freesurfer ‘nu_correct’
command and the estimated log bias-field.

In addition to the `read_mgz` and `read_mgh` functions above, we have a
`read_mnc` wrapper function for reading in MINC files, after conversion
to NIfTI files. If you pass in a `nifti` object in directly into
`nu_correct`, the function will automatically convert any NIfTI input
files, and then run the correction (shown below). We can also pass in a
mask of the brain (see next section) to run the correction only the
areas of the brain.

``` r
nu_masked = nu_correct(file = reoriented_img, mask = mask)
```

Overall, this correction is a way to make the intensities of the brain
more homogeneous spatially.

This method is different from that implemented in FSL (Jenkinson et al.
2012) (and therefore `fslr`), so it provides an alternative method to
the R user than currently available.

### Brain extraction: the `mri_watershed` function

The `mri_watershed` function will segment the brain from the remainder
of the image, such as extra-cranial tissues. Other imaging software in R
have implemented the watershed algorithm, such as `EBImage` (Pau et al.
2010). These methods have not been directly adapted for MRI nor
specifically for brain extraction. In `freesurfer`, we can pass in the
`nifti` object and the output is a brain-extracted `nifti` object.

``` r
ss = mri_watershed(img)
ss = orient_rpi(img)$img
neurobase::ortho2(img, mask = ss)
```

![Brain-extracted image after using Freesurfer ‘mri_watershed’
algorithm. We see that the areas outside of the brain have been removed
from the image.](figure/watershed_plot-1.png)

Brain-extracted image after using Freesurfer ‘mri_watershed’ algorithm.
We see that the areas outside of the brain have been removed from the
image.

The result is in figure @ref(fig:watershed_plot), where we see areas of
the skull, eyes, face, and other areas of the image are removed. We do
see some areas remain that may be part of some of the membranes between
the brain and the skull, but this looks like an adequate brain
extraction for most analyses.

As the result is a `nifti` object, we can create a mask by standard
logical operations for arrays. As MRI scans are typically
positive-valued, the positive areas of the image are the “brain”:

``` r
mask = ss > 0
```

We can then use this mask to perform operations on the image, such as
subsetting.

### Segmentations of brain structures

Freesurfer is commonly used to segment cortical and subcortical
structures of the brain. We can visualize images of these segmentations,
which are located in the “mri” folder.

We will choose the colors based on the Freesurfer look up table (LUT),
which values can be explored on the [Freesurfer
website](https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/AnatomicalROI/FreeSurferColorLUT).
This look up table provides a label for each structure and the color
associated with it:

``` r
head(fs_lut, 3)
```

      index                      label   R   G   B A
    1     0                    Unknown   0   0   0 0
    2     1     Left-Cerebral-Exterior  70 130 180 0
    3     2 Left-Cerebral-White-Matter 245 245 245 0

This object is included in `freesurfer` and denotes the indices, labels,
and color representation of the structure. We note that the alpha
channel is set to $0$ for all regions of interest, so we will not use it
in the calculation of the colors from RGB space. This LUT allows
visualizations produced in R to be consistent with those from
Freesurfer.

``` r
seg_file = file = file.path(
  fs_subj_dir(),
  "bert",
  "mri",
  "aseg.mgz"
)
seg = read_mgz(seg_file)
breaks = c(-1, fs_lut$index)
colors = rgb(
  fs_lut$R,
  fs_lut$G,
  fs_lut$B,
  alpha = 255 / 2,
  maxColorValue = 255
)
neurobase::ortho2(ss, seg, col.y = colors, ybreaks = breaks)
```

![Overlay of segmentation from Freesurfer ‘recon-all’
command.](figure/seg_file_show-1.png)

Overlay of segmentation from Freesurfer ‘recon-all’ command.

Note above that the number of breaks must be one larger than the number
of colors and the indices start at zero, so we add an additional element
to the indices. The result in figure @ref(fig:seg_file) shows the image
with colors overlaid.

### Reading in anatomical statistics for brain structures

We have explored the spatial results in the brain images, but not the
quantitative information about the brain and sub-structures that are
available from Freesurfer output. The “aseg.stats” in the “stats” folder
for subject bert corresponds to measures and statistics from the
anatomical segmentation. The `read_aseg_stats` function reads this
corresponding file and creates a list of 2 different `data.frame`s:

``` r
file = file.path(fs_subj_dir(), "bert", "stats", "aseg.stats")
out = read_aseg_stats(file)
names(out)
```

    [1] "measures"   "structures"

The `measures` element corresponds to global measurements of the brain
(e.g. volume of the brain) as well as measures of gross anatomical
structures (e.g. gray matter).

``` r
head(out$measures[, c("meaning", "value", "units")], n = 3)
```

                                           meaning          value units
    1                    brain segmentation volume 1218061.000000  mm^3
    2 brain segmentation volume without ventricles 1199378.000000  mm^3
    3      volume of ventricles and choroid plexus   15041.000000  mm^3

In some imaging analyses, comparing at these large measures of brain
volume over time or across groups are of interest. Alternatively, the
`structures` element corresponds to a set of measures and statistics for
a set of fixed anatomical structures.

``` r
head(out$structures, n = 3)
```

      Index SegId NVoxels Volume_mm3                   StructName normMean
    1     1     4    6943     7316.9       Left-Lateral-Ventricle  36.0349
    2     2     5     187      237.7            Left-Inf-Lat-Vent  51.8984
    3     3     7   15043    15559.6 Left-Cerebellum-White-Matter  86.5151
      normStdDev normMin normMax normRange
    1    12.2361      14      89        75
    2     9.4303      21      78        57
    3     5.0521      38      99        61

Similarly with global measures, these structure-specific measures are
used in analysis.

For example, measuring differences in hippocampus volumes across
patients with Alzheimer’s disease and those without. Moreover, a large
deviation in volume, globally or locally, for a specific subject may
indicate atrophy of a structure or an indication of a segmentation
error.

### Converting surfaces using `mris_convert`

Freesurfer includes segmentations of different surfaces of the brain
alongside the volumetric segmentations above. As the `mri_convert`
function provides a tool to convert image volumes to a series of output
formats, the `mris_convert` (note the “s”) allows users to convert
between image surface formats. These surfaces usually store sets of
vertices and faces to be plotted in 3 dimensions. `freesurfer` has
implemented `mris_convert` (with a function of the same name) as well as
functions to convert surfaces from Freesurfer to a set of triangles in
R, such as `surface_to_triangles`. We will read in the left and right
side of the pial surface of the brain and display the surface using
`rgl` (Murdoch and Adler 2025).

``` r
right_file = file.path(fs_subj_dir(), "bert", "surf", "rh.pial")
right_triangles = surface_to_triangles(infile = right_file)
left_file = file.path(fs_subj_dir(), "bert", "surf", "lh.pial")
left_triangles = surface_to_triangles(infile = left_file)
rgl::rgl.open()
rgl::rgl.triangles(right_triangles, color = rainbow(nrow(right_triangles)))
rgl::rgl.triangles(left_triangles, color = rainbow(nrow(left_triangles)))
```

Thus, we can read in the output images, surfaces, and the tables of
output metrics from Freesurfer.

### Additional features

For the initial release, we did not implement a method to read the
annotation files and other surface-based files that Freesurfer uses.
Reading in these files are planned for a future release and may work
with the functions described above. Freesurfer can also analyze
diffusion tensor imaging data and some of the functions have been
adapted for `freesurfer` but have not been thoroughly tested.

## Conclusion

The neuroimaging community has developed a large collection of tools for
image processing and analysis. These tools have additional functionality
that is not present in R, such as the surface-based registration and
processing Freesurfer provides. We have provided a similar incorporation
of tools from FSL to R in the package and have repeated the effort for
Freesurfer with the `freesurfer` package to bridge this gap and provide
R users functions from Freesurfer.

There has been an increasing popularity of similar interfacing of tools
within the Python community such as Nipype (Gorgolewski et al. 2011). As
many users of R may not have experience with Python or bash scripting,
we believe `freesurfer` provides a lower threshold for use in the R
community.

Lowering this threshold is important because it allows more R users to
control all aspects of image analysis from raw image processing to final
statistical analysis. Interfacing R with existing, powerful software
provides R users more functionality and a additional support community,
which would not be available if the functions were rewritten in R.
Although having an external software dependency may be disadvantage to R
users, the software used benefits from the years of previous testing.
Most importantly, as `freesurfer` is based on the R framework, all the
benefits of using R are available, such as dynamic documents, Shiny
applications, customized figures, and state-of-the-art statistical
methods. This added functionality affords the neuroimaging and R
communities the ability to have analysis in one framework while
borrowing the strengths of both.

## Supplemental material

### Label files

Although we have not thoroughly tested reading in a label file from
Freesurfer, we have provided the `read_fs_label` function. Here we will
read a label file for the left hemisphere cortex:

``` r
file = file.path(fs_subj_dir(), "bert", "label", "lh.cortex.label")
out = read_fs_label(file)
head(out)
```

      vertex_num r_coord  a_coord s_coord        value
    1          0 -11.127 -101.103  -1.062 0.0000000000
    2          1 -10.776 -100.985  -1.818 0.0000000000
    3          2 -10.967 -101.124  -1.850 0.0000000000
    4          3 -11.642 -101.242  -1.580 0.0000000000
    5          4 -12.188 -101.283  -2.012 0.0000000000
    6          5 -10.848 -101.056  -2.769 0.0000000000

The coordinates are mostly used in these files, not the value assigned
(in this case all zeroes). These files can be used for registration as
well. Overall, we have provided a reader for users, but have not used
them in our research and therefore have not tested them extensively to
discuss them further.

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

Fischl, Bruce, Martin I Sereno, and Anders M Dale. 1999.
“High-Resolution Intersubject Averaging and a Coordinate System for the
Human Brain.” *Human Brain Mapping* 8 (4): 272–84.

Gorgolewski, Krzysztof J, Christopher D Burns, Christopher Madison,
Daniel Clark, Yaroslav O Halchenko, Michael L Waskom, and Satrajit S
Ghosh. 2011. “Nipype: A Flexible, Distributed, and Open-Source
Implementation of a Dataflow for Neuroimaging Data Analysis.” *Frontiers
in Neuroinformatics* 5: 13.

Jenkinson, Mark, Christian F Beckmann, Timothy EJ Behrens, Mark W
Woolrich, and Stephen M Smith. 2012. “FSL: Functional MRI of the Brain,
Diffusion Tensor Imaging, and Structural Imaging.” *Neuroimage* 62 (2):
782–90.

Modat, Marc, David M Cash, Pradnya Daga, Kyana Dourado, and and others.
2013. “RNiftyReg: An r Package for Image Registration.” *Journal of
Statistical Software* 55 (10): 1–22.

Murdoch, Duncan, and Daniel Adler. 2025. *Rgl: 3D Visualization Using
OpenGL*. <https://CRAN.R-project.org/package=rgl>.

Muschelli, John. 2024. *Neurobase: ’Neuroconductor’ Base Package with
Helper Functions for ’Nifti’ Objects*.
<https://CRAN.R-project.org/package=neurobase>.

Muschelli, John, Elizabeth M Sweeney, James J Pekar, and Ciprian M
Crainiceanu. 2015. “fslr: An r Package for FSL.” *Journal of Statistical
Software* 68 (2): 1–28.

Pau, G, F Fuchs, O Sklyar, M Boutros, and W Huber. 2010. “EBImage: An r
Package for Image Processing with Applications to Biological
Microscopy.” *Bioinformatics* 26 (7): 979–81.

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

Tustison, Nicholas J., Brian B. Avants, Philip A. Cook, Sharmistha Das,
Gordon Duda, Daljeet S. Grewal, Andy Ha, et al. 2021. “The ANTsX
Ecosystem for Quantitative Biological and Medical Imaging.” *Scientific
Reports* 11: 87564–66. <https://doi.org/10.1038/s41598-021-87564-6>.

Whitcher, Brandon, John Muschelli, and Keith Johnson. 2011. “Working
with the NIfTI and ANALYZE Image Formats in r.” *Journal of Statistical
Software* 44 (6): 1–26.

Whitcher, Brandon, Volker J. Schmid, and Andrew Thornton. 2011. “Working
with the DICOM and NIfTI Data Standards in R.” *Journal of Statistical
Software* 44 (6): 1–28. <https://doi.org/10.18637/jss.v044.i06>.

Zhang, Yu, Michael Brady, and Stephen Smith. 2001. “Segmentation of
Brain MR Images Through a Hidden Markov Random Field Model and the
Expectation-Maximization Algorithm.” *IEEE Transactions on Medical
Imaging* 20 (1): 45–57.
