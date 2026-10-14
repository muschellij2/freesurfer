# freesurfer

The goal of freesurfer is a port/wrapper of
[Freesurfer](https://surfer.nmr.mgh.harvard.edu) to R.

Much of the operations of Freesurfer are incorporated.  
This package is very useful for structural imaging, such as MRI. Some of
the fMRI functionality has not been ported or has limited capability.

## Installation

You can install the released version of freesurfer from
[CRAN](https://CRAN.R-project.org) with:

``` r

install.packages("freesurfer")
```

And the development version from [GitHub](https://github.com/) with:

``` r

# install.packages("devtools")
devtools::install_github("muschellij2/freesurfer")
```

``` R
R_VERSION=4.5.0
FS_VERSION=8.0.0

docker buildx build \
  --platform linux/amd64 \
  --build-arg FS_VERSION=${FS_VERSION} \
  --build-arg R_VERSION=${R_VERSION} \
  -t docker-freesurfer-r:r${R_VERSION}-fs_${FS_VERSION} .
```
