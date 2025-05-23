% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mri_surf2surf.R
\name{mri_surf2surf}
\alias{mri_surf2surf}
\title{Use Freesurfers \code{mri_surf2surf} function to
resamples one cortical surface onto another}
\usage{
mri_surf2surf(
  subject = NULL,
  target_subject = NULL,
  trg_type = c("curv", "w", "mgh", "nii"),
  src_type = c("curv", "w"),
  outfile = NULL,
  hemi = c("lh", "rh"),
  sval = c("thickness"),
  subj_dir = NULL,
  opts = "",
  verbose = TRUE,
  ...
)
}
\arguments{
\item{subject}{(character) vector of subject name}

\item{target_subject}{(character) vector of target subject name}

\item{trg_type}{(character) target file type, can be curv, paint (w), mgh, or nii}

\item{src_type}{(character) source file type, can be curv or paint (w)}

\item{outfile}{(character) output filename}

\item{hemi}{(character) hemisphere to run statistics}

\item{sval}{(character) source file}

\item{subj_dir}{(character path) if a different subjects directory
is to be used other than \code{SUBJECTS_DIR} from shell, it can be
specified here.  Use with care as if the command fail, it may not reset
the \code{SUBJECTS_DIR} back correctly after the error}

\item{opts}{(character) additional options to \code{mri_surf2surf}}

\item{verbose}{(logical) print diagnostic messages}

\item{...}{Additional arguments to pass to \code{\link{system}}}
}
\value{
Name of output file
}
\description{
This function calls Freesurfer \code{mri_surf2surf} to
resample one cortical surface onto another
}
\examples{
if (have_fs()) {
   out = mri_surf2surf(
   subject = 'bert',
   target_subject = 'fsaverage',
   trg_type  = 'curv',
   src_type  = 'curv',
   hemi = "rh",
   sval = "thickness")
}
}
