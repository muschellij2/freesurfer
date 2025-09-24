# Helper function to create mock aseg.stats file content
mock_aseg_stats_content <- function(
  subject_name = "MockSubject",
  num_measures = 2,
  num_structures = 3,
  include_colheaders = TRUE,
  include_measures = TRUE,
  extra_header_lines = 0
) {
  content <- character()

  if (extra_header_lines > 0) {
    content <- c(content, paste0("# extra_header_line_", 1:extra_header_lines))
  }

  content <- c(content, paste0("# subjectname ", subject_name))
  content <- c(content, "# date 2025/07/14")
  content <- c(content, "# NMEASURES 123")

  if (include_measures) {
    measure_lines <- character()
    if (num_measures >= 1) {
      measure_lines <- c(
        measure_lines,
        "# Measure brainseg, brainseg, brain segmentation volume, 1218061.000000, mm^3"
      )
    }
    if (num_measures >= 2) {
      measure_lines <- c(
        measure_lines,
        "# Measure lhcortex, lhcortexvol, left hemisphere cortical gray matter volume, 244352.047461, mm^3"
      )
    }
    if (num_measures >= 3) {
      measure_lines <- c(
        measure_lines,
        "# Measure estimatedtotalintracranialvol, etiv, estimated total intracranial volume, 1520021.264474, mm^3"
      )
    }

    for (line in measure_lines) {
      if (sum(gregexpr(",", line)[[1]] != -1) != 4) {
        warning(paste(
          "INTERNAL MOCK DATA WARNING: Measure line does not have 4 commas (5 fields):",
          line
        ))
      }
    }
    content <- c(content, measure_lines)
  }

  content <- c(content, "# CTAB_FILE CTAB")
  content <- c(content, "# CTAB_HASH 1234567890")

  if (include_colheaders) {
    hdr_line <- "# ColHeaders Index SegId NVoxels Volume_mm3 StructName normMean normStdDev normMin normMax normRange"

    content <- c(content, hdr_line)

    for (i in 1:num_structures) {
      struct_name <- switch(
        as.character(i),
        "1" = "Left-Lateral-Ventricle",
        "2" = "Left-Cerebellum-Cortex",
        "3" = "Right-Thalamus"
      )
      data_line <- sprintf(
        "%d %d %.0f %.1f %s %.4f %.4f %.0f %.0f %.0f",
        i, # Index
        i * 100, # SegId
        round(runif(1, 1000, 10000)), # NVoxels (integer)
        runif(1, 5000, 10000), # Volume_mm3 (double)
        struct_name, # StructName
        runif(1, 30, 90), # normMean
        runif(1, 5, 15), # normStdDev
        round(runif(1, 10, 50)), # normMin (integer)
        round(runif(1, 70, 120)), # normMax (integer)
        round(runif(1, 40, 90)) # normRange (integer)
      )
      content <- c(content, data_line)
    }
  }

  return(content)
}

expected_structure_cols <- c(
  "Index",
  "SegId",
  "NVoxels",
  "Volume_mm3",
  "StructName",
  "normMean",
  "normStdDev",
  "normMin",
  "normMax",
  "normRange"
)

# --- Test Cases for ---

test_that("reads a valid aseg.stats file correctly (default lowercase)", {
  mock_content <- mock_aseg_stats_content(
    num_measures = 2,
    num_structures = 3
  )

  withr::with_tempfile(
    "mock_aseg_stats",
    fileext = ".stats",
    {
      writeLines(
        mock_content,
        con = mock_aseg_stats
      )

      result <- read_aseg_stats(mock_aseg_stats)

      # Check overall structure
      expect_type(result, "list")
      expect_named(result, c("measures", "structures"))
      expect_s3_class(result$measures, "data.frame")
      expect_s3_class(result$structures, "data.frame")

      # Check 'measures' data frame
      expect_equal(nrow(result$measures), 2)
      expect_equal(ncol(result$measures), 5)
      expect_equal(
        colnames(result$measures),
        c("measure", "measure_long", "meaning", "value", "units")
      )

      expect_equal(result$measures$measure[1], "brainseg")
      expect_equal(result$measures$meaning[1], "brain segmentation volume")

      expect_equal(nrow(result$structures), 3)

      expect_equal(
        colnames(result$structures),
        expected_structure_cols
      )

      expect_type(result$structures$Index, "double")
      expect_type(result$structures$SegId, "double")
      expect_type(result$structures$StructName, "character")

      expect_equal(
        result$structures$StructName[1],
        "Left-Lateral-Ventricle"
      )
      expect_equal(result$structures$Index[1], 1)
      expect_equal(result$structures$SegId[1], 100)
    }
  )

  skip_if_no_freesurfer()

  af <- file.path(
    fs_subj_dir(),
    "bert",
    "stats",
    "aseg.stats"
  )
  result <- read_aseg_stats(af)
  measures <- result$measures

  # Check overall structure
  expect_s3_class(measures, "data.frame")
  expect_equal(ncol(measures), 5)
  expect_equal(
    colnames(measures),
    c("measure", "measure_long", "meaning", "value", "units")
  )

  # Check that there is at least one measure (assuming a non-empty file)
  expect_gt(nrow(measures), 0)

  # Check data types (all character/string as per your function's output)
  expect_type(measures$measure, "character")
  expect_type(measures$measure_long, "character")
  expect_type(measures$meaning, "character")
  expect_type(measures$value, "character") # Value is read as character
  expect_type(measures$units, "character")

  # Check for the presence of expected measures (using 'grepl' for robustness with lowercase conversion)
  expect_true(any(grepl("brainseg", measures$measure, ignore.case = TRUE)))
  expect_true(any(grepl("lhcortex", measures$measure, ignore.case = TRUE)))
  expect_true(any(grepl(
    "estimatedtotalintracranialvol",
    measures$measure,
    ignore.case = TRUE
  )))

  # --- Assertions for 'structures' data frame ---
  structures <- result$structures

  # Check overall structure
  expect_s3_class(structures, "data.frame")
  expect_gt(nrow(structures), 0)
  expect_equal(ncol(structures), 10)
  expect_equal(
    colnames(structures),
    expected_structure_cols
  )

  # Check data types for structures
  expect_type(structures$Index, "double")
  expect_type(structures$SegId, "double")
  expect_type(structures$NVoxels, "double")
  expect_type(structures$Volume_mm3, "double")
  expect_type(structures$StructName, "character")
  expect_type(structures$normMean, "double")
  expect_type(structures$normStdDev, "double")
  expect_type(structures$normMin, "double")
  expect_type(structures$normMax, "double")
  expect_type(structures$normRange, "double")

  expect_true(any(grepl("Left-Lateral-Ventricle", structures$StructName)))
  expect_true(any(grepl("Right-Thalamus", structures$StructName)))
  expect_true(any(grepl("Brain-Stem", structures$StructName)))

  expect_false(all(is.na(structures$Index)))
  expect_false(all(is.na(structures$NVoxels)))
  expect_false(all(is.na(structures$Volume_mm3)))
  expect_false(all(is.na(structures$normMean)))
})

test_that("works with lowercase = FALSE", {
  mock_content <- mock_aseg_stats_content(num_measures = 1)

  withr::with_tempfile("mock_aseg_stats_no_lc", fileext = ".stats", {
    writeLines(
      mock_content,
      con = mock_aseg_stats_no_lc
    )

    result <- read_aseg_stats(mock_aseg_stats_no_lc, lowercase = FALSE)

    # Check that measures are NOT lowercased
    expect_equal(result$measures$measure[1], "brainseg")
    expect_equal(result$measures$meaning[1], "brain segmentation volume")
  })
})

test_that("handles file starting with lines before # subjectname", {
  mock_content <- mock_aseg_stats_content(
    num_measures = 1,
    num_structures = 1,
    extra_header_lines = 5
  )

  withr::with_tempfile("mock_aseg_stats_extra_header", fileext = ".stats", {
    writeLines(mock_content, con = mock_aseg_stats_extra_header)

    result <- read_aseg_stats(mock_aseg_stats_extra_header)

    # Check that the parsing correctly started from # subjectname
    expect_equal(nrow(result$measures), 1)
    expect_equal(nrow(result$structures), 1)
    expect_equal(result$measures$measure[1], "brainseg")
  })
})

test_that("throws error for non-existent file", {
  non_existent_file <- file.path(tempdir(), "non_existent.stats")
  expect_error(
    read_aseg_stats(non_existent_file),
    "does not exist"
  )
})

test_that("handles empty file (no content)", {
  withr::with_tempfile(
    "mock_empty_file",
    fileext = ".stats",
    {
      writeLines(character(0), con = mock_empty_file)

      expect_error(
        read_aseg_stats(mock_empty_file),
        "from' must be of length 1"
      )
    }
  )
})
