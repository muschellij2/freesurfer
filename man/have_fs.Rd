% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fs_setup.R
\name{have_fs}
\alias{have_fs}
\title{Logical check if Freesurfer is accessible}
\usage{
have_fs(..., check_license = FALSE)
}
\arguments{
\item{...}{options to pass to \code{\link{get_fs}}}

\item{check_license}{Should a license file be checked to exist?}
}
\value{
Logical TRUE is Freesurfer is accessible, FALSE if not
}
\description{
Uses \code{get_fs} to check if FreesurferDIR is accessible or the option
\code{freesurfer.path} is set and returns logical
}
\examples{
have_fs()
}
