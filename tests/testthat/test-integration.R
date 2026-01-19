describe("FreeSurfer Integration Tests", {
  describe("fs_help", {
    it("returns help text for mri_convert", {
      skip_if_no_freesurfer()

      result <- fs_help("mri_convert", display = FALSE)

      expect_type(result, "character")
      expect_true(length(result) > 0)
    })
  })

  describe("mri_convert", {
    it("converts nifti to nifti", {
      skip_if_no_freesurfer()

      img <- oro.nifti::nifti(array(rnorm(8), dim = c(2, 2, 2)))
      outfile <- withr::local_tempfile(fileext = ".nii.gz")

      withr::local_options(freesurfer.verbose = FALSE)
      result <- mri_convert(img, outfile = outfile)

      expect_true(file.exists(outfile))
    })
  })

  describe("mri_info", {
    it("returns info for nifti image", {
      skip_if_no_freesurfer()

      img <- oro.nifti::nifti(array(rnorm(8), dim = c(2, 2, 2)))

      result <- mri_info(img, retimg = FALSE, intern = TRUE)

      expect_type(result, "character")
      expect_true(length(result) > 0)
    })
  })

  describe("read_mgz", {
    it("reads mgz file from bert subject", {
      skip_if_no_freesurfer()

      bert_mgz <- file.path(fs_subj_dir(), "bert", "mri", "brain.mgz")
      skip_if_not(file.exists(bert_mgz), "bert subject not available")

      result <- read_mgz(bert_mgz)

      expect_s4_class(result, "nifti")
    })
  })

  describe("mris_convert", {
    it("converts surface file to ascii", {
      skip_if_no_freesurfer()

      bert_surf <- file.path(fs_subj_dir(), "bert", "surf", "lh.white")
      skip_if_not(file.exists(bert_surf), "bert subject not available")

      outfile <- withr::local_tempfile(fileext = ".asc")
      result <- mris_convert(infile = bert_surf, outfile = outfile)

      expect_true(file.exists(result))
    })
  })

  describe("convert_surface", {
    it("converts surface to vertices and faces", {
      skip_if_no_freesurfer()

      bert_surf <- file.path(fs_subj_dir(), "bert", "surf", "lh.white")
      skip_if_not(file.exists(bert_surf), "bert subject not available")

      result <- convert_surface(bert_surf)

      expect_type(result, "list")
      expect_true("vertices" %in% names(result))
      expect_true("faces" %in% names(result))
    })
  })

  describe("surf_convert", {
    it("converts surface measure to matrix", {
      skip_if_no_freesurfer()

      bert_thickness <- file.path(fs_subj_dir(), "bert", "surf", "lh.thickness")
      skip_if_not(file.exists(bert_thickness), "bert subject not available")

      withr::local_options(freesurfer.verbose = FALSE)
      result <- surf_convert(bert_thickness)

      expect_true(is.matrix(result))
      expect_equal(ncol(result), 5)
    })
  })

  describe("mris_euler_number", {
    it("calculates euler number for surface", {
      skip_if_no_freesurfer()

      bert_surf <- file.path(fs_subj_dir(), "bert", "surf", "lh.white")
      skip_if_not(file.exists(bert_surf), "bert subject not available")

      result <- suppressWarnings(mris_euler_number(bert_surf))

      expect_true(is.character(result) || is.null(result))
    })
  })

  describe("asegstats2table", {
    it("converts aseg stats to table", {
      skip_if_no_freesurfer()

      bert_stats <- file.path(fs_subj_dir(), "bert", "stats", "aseg.stats")
      skip_if_not(file.exists(bert_stats), "bert subject not available")

      outfile <- asegstats2table(subjects = "bert", measure = "volume")

      expect_true(file.exists(outfile))
    })
  })

  describe("aparcstats2table", {
    it("converts aparc stats to table", {
      skip_if_no_freesurfer()

      bert_stats <- file.path(
        fs_subj_dir(), "bert", "stats", "lh.aparc.stats"
      )
      skip_if_not(file.exists(bert_stats), "bert subject not available")

      outfile <- aparcstats2table(
        subjects = "bert",
        hemi = "lh",
        measure = "thickness"
      )

      expect_true(file.exists(outfile))
    })
  })

  describe("read_aseg_stats", {
    it("reads aseg stats file", {
      skip_if_no_freesurfer()

      bert_stats <- file.path(fs_subj_dir(), "bert", "stats", "aseg.stats")
      skip_if_not(file.exists(bert_stats), "bert subject not available")

      result <- read_aseg_stats(bert_stats)

      expect_type(result, "list")
      expect_s3_class(result$measures, "data.frame")
      expect_s3_class(result$structures, "data.frame")
      expect_true(nrow(result$structures) > 0)
    })
  })

  describe("read_annotation", {
    it("reads annotation file", {
      skip_if_no_freesurfer()

      bert_annot <- file.path(
        fs_subj_dir(), "bert", "label", "lh.aparc.annot"
      )
      skip_if_not(file.exists(bert_annot), "bert subject not available")

      result <- read_annotation(bert_annot)

      expect_type(result, "list")
    })
  })

  describe("freesurfer_read_surf", {
    it("reads surface file", {
      skip_if_no_freesurfer()

      bert_surf <- file.path(fs_subj_dir(), "bert", "surf", "lh.white")
      skip_if_not(file.exists(bert_surf), "bert subject not available")

      result <- freesurfer_read_surf(bert_surf)

      expect_type(result, "list")
      expect_true("vertices" %in% names(result))
    })
  })

  describe("freesurfer_read_curv", {
    it("reads curvature file", {
      skip_if_no_freesurfer()

      bert_curv <- file.path(fs_subj_dir(), "bert", "surf", "lh.curv")
      skip_if_not(file.exists(bert_curv), "bert subject not available")

      result <- freesurfer_read_curv(bert_curv)

      expect_type(result, "double")
      expect_true(length(result) > 0)
    })
  })

  describe("read_fs_label", {
    it("reads label file", {
      skip_if_no_freesurfer()

      bert_label <- file.path(
        fs_subj_dir(), "bert", "label", "lh.cortex.label"
      )
      skip_if_not(file.exists(bert_label), "bert subject not available")

      result <- read_fs_label(bert_label)

      expect_s3_class(result, "data.frame")
    })
  })
})
