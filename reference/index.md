# Package index

## Setup & Configuration

Functions to configure and verify your FreeSurfer installation.

- [`have_fs()`](https://muschellij2.github.io/freesurfer/reference/have_fs.md)
  : Logical check if Freesurfer is accessible
- [`get_fs()`](https://muschellij2.github.io/freesurfer/reference/get_fs.md)
  : Generate FreeSurfer Command Line Environment Setup
- [`get_fs_setting()`](https://muschellij2.github.io/freesurfer/reference/get_fs_setting.md)
  [`get_fs_home()`](https://muschellij2.github.io/freesurfer/reference/get_fs_setting.md)
  [`get_fs_license()`](https://muschellij2.github.io/freesurfer/reference/get_fs_setting.md)
  [`get_fs_subdir()`](https://muschellij2.github.io/freesurfer/reference/get_fs_setting.md)
  [`get_fs_source()`](https://muschellij2.github.io/freesurfer/reference/get_fs_setting.md)
  [`get_fs_verbosity()`](https://muschellij2.github.io/freesurfer/reference/get_fs_setting.md)
  [`get_fs_output()`](https://muschellij2.github.io/freesurfer/reference/get_fs_setting.md)
  [`get_mni_bin()`](https://muschellij2.github.io/freesurfer/reference/get_fs_setting.md)
  : Retrieve FreeSurfer Configuration Settings
- [`freesurferdir()`](https://muschellij2.github.io/freesurfer/reference/fs_dir.md)
  [`freesurfer_dir()`](https://muschellij2.github.io/freesurfer/reference/fs_dir.md)
  [`fs_dir()`](https://muschellij2.github.io/freesurfer/reference/fs_dir.md)
  [`fs_subj_dir()`](https://muschellij2.github.io/freesurfer/reference/fs_dir.md)
  : Get FreeSurfer Directory Paths
- [`set_fs_subj_dir()`](https://muschellij2.github.io/freesurfer/reference/set_fs_subj_dir.md)
  **\[deprecated\]** : Set FreeSurfer Subjects Directory
- [`fs_sitrep()`](https://muschellij2.github.io/freesurfer/reference/fs_sitrep.md)
  : FreeSurfer Situation Report
- [`fs_version()`](https://muschellij2.github.io/freesurfer/reference/fs_version.md)
  : Find Freesurfer Version
- [`fs_imgext()`](https://muschellij2.github.io/freesurfer/reference/fs_imgext.md)
  : Determine extension of image based on Freesurfer output type

## Reading FreeSurfer Files

Functions to read FreeSurfer-specific file formats into R.

- [`freesurfer_read_curv()`](https://muschellij2.github.io/freesurfer/reference/freesurfer_read_curv.md)
  : Read Freesufer Curv file
- [`freesurfer_read_surf()`](https://muschellij2.github.io/freesurfer/reference/freesurfer_read_surf.md)
  : Read Freesurfer Surface file
- [`read_annotation()`](https://muschellij2.github.io/freesurfer/reference/read_annotation.md)
  : Read Freesurfer annotation file
- [`read_aseg_stats()`](https://muschellij2.github.io/freesurfer/reference/read_aseg_stats.md)
  : Read FreeSurfer Anatomical Segmentation Statistics
- [`read_fs_label()`](https://muschellij2.github.io/freesurfer/reference/read_fs_label.md)
  : Read Label File
- [`read_fs_table()`](https://muschellij2.github.io/freesurfer/reference/read_fs_table.md)
  [`read_stats_table()`](https://muschellij2.github.io/freesurfer/reference/read_fs_table.md)
  : Read FreeSurfer Table Output
- [`read_mgz()`](https://muschellij2.github.io/freesurfer/reference/read_mgz.md)
  [`read_mgh()`](https://muschellij2.github.io/freesurfer/reference/read_mgz.md)
  : Read MGH or MGZ File
- [`read_mnc()`](https://muschellij2.github.io/freesurfer/reference/read_mnc.md)
  : Read MNC File

## Image Conversion

Convert between different neuroimaging file formats.

- [`mri_convert()`](https://muschellij2.github.io/freesurfer/reference/mri_convert.md)
  [`mri_convert.help()`](https://muschellij2.github.io/freesurfer/reference/mri_convert.md)
  : Convert Medical Image Formats with FreeSurfer
- [`mri_info()`](https://muschellij2.github.io/freesurfer/reference/mri_info.md)
  : MRI information
- [`mnc2nii()`](https://muschellij2.github.io/freesurfer/reference/mnc2nii.md)
  [`mnc2nii.help()`](https://muschellij2.github.io/freesurfer/reference/mnc2nii.md)
  : Convert MNC to NIfTI
- [`nii2mnc()`](https://muschellij2.github.io/freesurfer/reference/nii2mnc.md)
  [`nii2mnc.help()`](https://muschellij2.github.io/freesurfer/reference/nii2mnc.md)
  : Convert NIfTI to MNC
- [`checkmnc()`](https://muschellij2.github.io/freesurfer/reference/checkmnc-methods.md)
  : Force object to filename with .mnc extension

## Image Processing

Core image processing operations like normalization, segmentation, and
skull stripping.

- [`mri_normalize()`](https://muschellij2.github.io/freesurfer/reference/mri_normalize.md)
  : Use Freesurfers MRI Normalize Algorithm
- [`mri_segment()`](https://muschellij2.github.io/freesurfer/reference/mri_segment.md)
  [`mri_segment.help()`](https://muschellij2.github.io/freesurfer/reference/mri_segment.md)
  : Use Freesurfers MRI Segmentation Algorithm
- [`mri_watershed()`](https://muschellij2.github.io/freesurfer/reference/mri_watershed.md)
  [`mri_watershed.help()`](https://muschellij2.github.io/freesurfer/reference/mri_watershed.md)
  : Use Freesurfers MRI Watershed Algorithm
- [`mri_mask()`](https://muschellij2.github.io/freesurfer/reference/mri_mask.md)
  : Use Freesurfers MRI Mask
- [`mri_deface()`](https://muschellij2.github.io/freesurfer/reference/mri_deface.md)
  : MRI Deface
- [`mri_synthstrip()`](https://muschellij2.github.io/freesurfer/reference/mri_synthstrip.md)
  [`synthstrip()`](https://muschellij2.github.io/freesurfer/reference/mri_synthstrip.md)
  : Use Freesurfers MRI SynthStrip
- [`nu_correct()`](https://muschellij2.github.io/freesurfer/reference/nu_correct.md)
  [`nu_correct.help()`](https://muschellij2.github.io/freesurfer/reference/nu_correct.md)
  : Use FreeSurfer's Non-Uniformity Correction

## Surface Operations

Functions for working with cortical surface data.

- [`mris_convert()`](https://muschellij2.github.io/freesurfer/reference/mris_convert.md)
  [`mris_convert_annot()`](https://muschellij2.github.io/freesurfer/reference/mris_convert.md)
  [`mris_convert_curv()`](https://muschellij2.github.io/freesurfer/reference/mris_convert.md)
  [`mris_convert_normals()`](https://muschellij2.github.io/freesurfer/reference/mris_convert.md)
  [`mris_convert_vertex()`](https://muschellij2.github.io/freesurfer/reference/mris_convert.md)
  [`mris_convert.help()`](https://muschellij2.github.io/freesurfer/reference/mris_convert.md)
  : Convert Cortical Surface File Formats with FreeSurfer
- [`mri_surf2surf()`](https://muschellij2.github.io/freesurfer/reference/mri_surf2surf.md)
  [`mri_surf2surf.help()`](https://muschellij2.github.io/freesurfer/reference/mri_surf2surf.md)
  : Resample Cortical Surface Data with FreeSurfer
- [`surf_convert()`](https://muschellij2.github.io/freesurfer/reference/surf_convert.md)
  : Convert Surface Data to ASCII
- [`convert_surface()`](https://muschellij2.github.io/freesurfer/reference/convert_surface.md)
  : Convert Freesurfer Surface
- [`surface_to_obj()`](https://muschellij2.github.io/freesurfer/reference/surface_to_obj.md)
  : Convert Freesurfer Surface to Wavefront OBJ
- [`surface_to_triangles()`](https://muschellij2.github.io/freesurfer/reference/surface_to_triangles.md)
  : Convert Freesurfer Surface to Triangles
- [`mris_euler_number()`](https://muschellij2.github.io/freesurfer/reference/mris_euler_number.md)
  : MRIs Euler Number

## Reconstruction Pipelines

Run FreeSurfer’s automated reconstruction pipelines.

- [`reconner()`](https://muschellij2.github.io/freesurfer/reference/reconner.md)
  : Reconstruction Helper for FreeSurfer's recon-all
- [`recon_all()`](https://muschellij2.github.io/freesurfer/reference/recon.md)
  [`recon()`](https://muschellij2.github.io/freesurfer/reference/recon.md)
  [`recon_steps()`](https://muschellij2.github.io/freesurfer/reference/recon.md)
  : FreeSurfer Reconstruction Pipeline Functions
- [`recon_con1()`](https://muschellij2.github.io/freesurfer/reference/recon_manual.md)
  [`autorecon1()`](https://muschellij2.github.io/freesurfer/reference/recon_manual.md)
  [`recon_con2()`](https://muschellij2.github.io/freesurfer/reference/recon_manual.md)
  [`autorecon2()`](https://muschellij2.github.io/freesurfer/reference/recon_manual.md)
  [`recon_con3()`](https://muschellij2.github.io/freesurfer/reference/recon_manual.md)
  [`autorecon3()`](https://muschellij2.github.io/freesurfer/reference/recon_manual.md)
  : Manual Freesurfer Reconstruction Workflow
- [`tracker()`](https://muschellij2.github.io/freesurfer/reference/trac.md)
  [`trac_all()`](https://muschellij2.github.io/freesurfer/reference/trac.md)
  [`trac_prep()`](https://muschellij2.github.io/freesurfer/reference/trac.md)
  [`trac_bedpost()`](https://muschellij2.github.io/freesurfer/reference/trac.md)
  [`trac_path()`](https://muschellij2.github.io/freesurfer/reference/trac.md)
  [`tracker.help()`](https://muschellij2.github.io/freesurfer/reference/trac.md)
  : FreeSurfer Diffusion Tractography Pipeline
- [`construct_subj_dir()`](https://muschellij2.github.io/freesurfer/reference/construct_subj_dir.md)
  : Construct Subject Directory

## Statistics & Analysis

Extract and analyze statistics from FreeSurfer outputs.

- [`stats2table()`](https://muschellij2.github.io/freesurfer/reference/stats2table.md)
  [`asegstats2table()`](https://muschellij2.github.io/freesurfer/reference/stats2table.md)
  [`aparcstats2table()`](https://muschellij2.github.io/freesurfer/reference/stats2table.md)
  [`aparcstats2table.help()`](https://muschellij2.github.io/freesurfer/reference/stats2table.md)
  [`asegstats2table.help()`](https://muschellij2.github.io/freesurfer/reference/stats2table.md)
  : Generalized Stats to Table
- [`aparcs_to_bg()`](https://muschellij2.github.io/freesurfer/reference/aparcs_to_bg.md)
  : Convert Freesurfer aparcs Table to brainGraph
- [`fs_lut`](https://muschellij2.github.io/freesurfer/reference/fs_lut.md)
  : Freesurfer look up table (LUT)

## Utilities

Helper functions for working with FreeSurfer.

- [`fs_cmd()`](https://muschellij2.github.io/freesurfer/reference/fs_cmd.md)
  : Execute FreeSurfer Commands from R
- [`fs_help()`](https://muschellij2.github.io/freesurfer/reference/fs_help.md)
  : Wrapper for getting FreeSurfer help
- [`temp_file()`](https://muschellij2.github.io/freesurfer/reference/temp_file.md)
  : Create a Temporary File with a Newly Created Directory

## FreeSurfer Help Documentation

Access FreeSurfer command-line help directly from R.

- [`fs_help()`](https://muschellij2.github.io/freesurfer/reference/fs_help.md)
  : Wrapper for getting FreeSurfer help
- [`mnc2nii()`](https://muschellij2.github.io/freesurfer/reference/mnc2nii.md)
  [`mnc2nii.help()`](https://muschellij2.github.io/freesurfer/reference/mnc2nii.md)
  : Convert MNC to NIfTI
- [`mri_convert()`](https://muschellij2.github.io/freesurfer/reference/mri_convert.md)
  [`mri_convert.help()`](https://muschellij2.github.io/freesurfer/reference/mri_convert.md)
  : Convert Medical Image Formats with FreeSurfer
- [`mri_info.help()`](https://muschellij2.github.io/freesurfer/reference/mri_info.help.md)
  : MRI information Help
- [`mri_mask.help()`](https://muschellij2.github.io/freesurfer/reference/mri_mask.help.md)
  : MRI Normalize Help
- [`mri_normalize.help()`](https://muschellij2.github.io/freesurfer/reference/mri_normalize.help.md)
  : MRI Normalize Help
- [`mri_segment()`](https://muschellij2.github.io/freesurfer/reference/mri_segment.md)
  [`mri_segment.help()`](https://muschellij2.github.io/freesurfer/reference/mri_segment.md)
  : Use Freesurfers MRI Segmentation Algorithm
- [`mri_surf2surf()`](https://muschellij2.github.io/freesurfer/reference/mri_surf2surf.md)
  [`mri_surf2surf.help()`](https://muschellij2.github.io/freesurfer/reference/mri_surf2surf.md)
  : Resample Cortical Surface Data with FreeSurfer
- [`mri_synthstrip.help()`](https://muschellij2.github.io/freesurfer/reference/mri_synthstrip.help.md)
  : MRI Normalize Help
- [`mri_watershed()`](https://muschellij2.github.io/freesurfer/reference/mri_watershed.md)
  [`mri_watershed.help()`](https://muschellij2.github.io/freesurfer/reference/mri_watershed.md)
  : Use Freesurfers MRI Watershed Algorithm
- [`mris_convert()`](https://muschellij2.github.io/freesurfer/reference/mris_convert.md)
  [`mris_convert_annot()`](https://muschellij2.github.io/freesurfer/reference/mris_convert.md)
  [`mris_convert_curv()`](https://muschellij2.github.io/freesurfer/reference/mris_convert.md)
  [`mris_convert_normals()`](https://muschellij2.github.io/freesurfer/reference/mris_convert.md)
  [`mris_convert_vertex()`](https://muschellij2.github.io/freesurfer/reference/mris_convert.md)
  [`mris_convert.help()`](https://muschellij2.github.io/freesurfer/reference/mris_convert.md)
  : Convert Cortical Surface File Formats with FreeSurfer
- [`mris_euler_number.help()`](https://muschellij2.github.io/freesurfer/reference/mris_euler_number.help.md)
  : MRI Euler Number Help
- [`nii2mnc()`](https://muschellij2.github.io/freesurfer/reference/nii2mnc.md)
  [`nii2mnc.help()`](https://muschellij2.github.io/freesurfer/reference/nii2mnc.md)
  : Convert NIfTI to MNC
- [`nu_correct()`](https://muschellij2.github.io/freesurfer/reference/nu_correct.md)
  [`nu_correct.help()`](https://muschellij2.github.io/freesurfer/reference/nu_correct.md)
  : Use FreeSurfer's Non-Uniformity Correction
- [`stats2table()`](https://muschellij2.github.io/freesurfer/reference/stats2table.md)
  [`asegstats2table()`](https://muschellij2.github.io/freesurfer/reference/stats2table.md)
  [`aparcstats2table()`](https://muschellij2.github.io/freesurfer/reference/stats2table.md)
  [`aparcstats2table.help()`](https://muschellij2.github.io/freesurfer/reference/stats2table.md)
  [`asegstats2table.help()`](https://muschellij2.github.io/freesurfer/reference/stats2table.md)
  : Generalized Stats to Table
- [`tracker()`](https://muschellij2.github.io/freesurfer/reference/trac.md)
  [`trac_all()`](https://muschellij2.github.io/freesurfer/reference/trac.md)
  [`trac_prep()`](https://muschellij2.github.io/freesurfer/reference/trac.md)
  [`trac_bedpost()`](https://muschellij2.github.io/freesurfer/reference/trac.md)
  [`trac_path()`](https://muschellij2.github.io/freesurfer/reference/trac.md)
  [`tracker.help()`](https://muschellij2.github.io/freesurfer/reference/trac.md)
  : FreeSurfer Diffusion Tractography Pipeline
