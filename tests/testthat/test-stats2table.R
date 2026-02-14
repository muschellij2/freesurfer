mock_run_check_fs_cmd <- function(cmd, outfile, verbose, ...) {
  writeLines("mock_data", outfile)
  return(invisible(0))
}

describe("stats2table", {
  it("validates input argument is not empty", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE
    )

    expect_error(
      stats2table(
        type = "aparc",
        input = character(0),
        input_type = "subjects",
        measure = "thickness"
      ),
      "'input' must be specified and cannot be empty."
    )

    expect_error(
      stats2table(
        type = "aparc",
        input = NULL,
        input_type = "subjects",
        measure = "thickness"
      ),
      "'input' must be specified and cannot be empty."
    )
  })

  it("creates output file with correct attributes", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "aparcstats2table_mock_binary",
      run_check_fs_cmd = mock_run_check_fs_cmd,
      temp_file = function(fileext = "") tempfile(fileext = fileext)
    )

    outfile <- stats2table(
      type = "aparc",
      input = "subject1",
      input_type = "subjects",
      measure = "thickness"
    )

    expect_true(file.exists(outfile))
    expect_equal(attr(outfile, "delimiter"), "\t")
    expect_match(outfile, "\\.tsv$")

    outfile_csv <- stats2table(
      type = "aseg",
      input = "input.stats",
      input_type = "inputs",
      measure = "volume",
      delim = "comma",
      outfile = withr::local_tempfile(fileext = ".csv")
    )

    expect_true(file.exists(outfile_csv))
    expect_equal(attr(outfile_csv, "delimiter"), ",")
    expect_match(outfile_csv, "\\.csv$")
  })

  it("creates temp file when outfile is NULL", {
    withr::local_tempdir()
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "aparcstats2table_mock_binary",
      run_check_fs_cmd = mock_run_check_fs_cmd,
      temp_file = function(fileext = "") tempfile(fileext = fileext)
    )
    outfile <- stats2table(
      type = "aparc",
      input = "testsubj",
      input_type = "subjects",
      measure = "volume",
      verbose = FALSE
    )
    expect_true(file.exists(outfile))
    expect_match(basename(outfile), "^file")
  })

  it("handles different delimiters correctly", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "aparcstats2table_mock_binary",
      run_check_fs_cmd = mock_run_check_fs_cmd,
      temp_file = function(fileext = "") tempfile(fileext = fileext)
    )

    outfile_tab <- stats2table(
      type = "aparc",
      input = "subj",
      input_type = "subjects",
      measure = "area",
      delim = "tab",
      verbose = FALSE
    )
    expect_equal(attr(outfile_tab, "delimiter"), "\t")
    expect_match(outfile_tab, "\\.tsv$")

    outfile_space <- stats2table(
      type = "aparc",
      input = "subj",
      input_type = "subjects",
      measure = "area",
      delim = "space",
      verbose = FALSE
    )
    expect_equal(attr(outfile_space, "delimiter"), " ")
    expect_match(outfile_space, "\\.txt$")

    outfile_comma <- stats2table(
      type = "aparc",
      input = "subj",
      input_type = "subjects",
      measure = "area",
      delim = "comma",
      verbose = FALSE
    )
    expect_equal(attr(outfile_comma, "delimiter"), ",")
    expect_match(outfile_comma, "\\.csv$")

    outfile_semicolon <- stats2table(
      type = "aparc",
      input = "subj",
      input_type = "subjects",
      measure = "area",
      delim = "semicolon",
    )
    expect_equal(attr(outfile_semicolon, "delimiter"), ";")
    expect_match(outfile_semicolon, "\\.csv$")
  })

  it("constructs correct command arguments for subjects input type", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "aparcstats2table_mock_binary",
      run_check_fs_cmd = function(cmd, outfile, verbose, ...) {
        expect_match(cmd, "aparcstats2table_mock_binary aparcstats2table")
        expect_match(cmd, "--subjects subj1 subj2")
        expect_match(cmd, "--delimiter tab")
        expect_match(cmd, "--meas thickness")
        expect_match(cmd, "--tablefile ")
        expect_no_match(cmd, "--inputs")
        file.create(outfile)
        invisible(0)
      },
      temp_file = function(fileext = "") tempfile(fileext = fileext)
    )
    stats2table(
      type = "aparc",
      input = c("subj1", "subj2"),
      input_type = "subjects",
      measure = "thickness",
      delim = "tab",
      verbose = FALSE
    )
  })

  it("constructs correct command arguments for inputs input type", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "aparcstats2table_mock_binary",
      run_check_fs_cmd = function(cmd, outfile, verbose, ...) {
        expect_match(cmd, "aparcstats2table_mock_binary asegstats2table")
        expect_match(cmd, "--inputs input1.stats input2.stats")
        expect_match(cmd, "--delimiter comma")
        expect_match(cmd, "--meas volume")
        expect_match(cmd, "--tablefile ")
        expect_no_match(cmd, "--subjects")
        file.create(outfile)
        invisible(0)
      },
      temp_file = function(fileext = "") tempfile(fileext = fileext)
    )
    stats2table(
      type = "aseg",
      input = c("input1.stats", "input2.stats"),
      input_type = "inputs",
      measure = "volume",
      delim = "comma"
    )
  })

  it("handles skip, verbose, subj_dir, and opts arguments", {
    mock_subj_dir <- file.path(
      withr::local_tempdir(),
      "test_subjects_dir"
    )
    dir.create(mock_subj_dir, recursive = TRUE)

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function(...) "mock_binary",
      run_check_fs_cmd = function(cmd, outfile, verbose, ...) {
        expect_match(cmd, "--skip", fixed = TRUE)
        expect_match(cmd, "export SUBJECTS_DIR=", fixed = TRUE)
        expect_match(cmd, "test_subjects_dir", fixed = TRUE)
        expect_match(cmd, "some_extra_opts", fixed = TRUE)
        file.create(outfile)
        invisible(0)
      },
      temp_file = function(fileext = "") tempfile(fileext = fileext)
    )
    expect_silent(
      stats2table(
        type = "aparc",
        input = "subj_skip",
        input_type = "subjects",
        measure = "volume",
        skip = TRUE,
        verbose = FALSE,
        subj_dir = mock_subj_dir,
        opts = "some_extra_opts"
      )
    )
  })

  it("handles different measure arguments", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "aparcstats2table_mock_binary",
      run_check_fs_cmd = function(cmd, outfile, verbose, ...) {
        expect_match(cmd, "--meas area")
        file.create(outfile)
        invisible(0)
      },
      temp_file = function(fileext = "") tempfile(fileext = fileext)
    )
    stats2table(
      type = "aparc",
      input = "subj",
      input_type = "subjects",
      measure = "area",
      verbose = FALSE
    )

    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "aparcstats2table_mock_binary",
      run_check_fs_cmd = function(cmd, outfile, verbose, ...) {
        expect_match(cmd, "--meas gauscurv")
        file.create(outfile)
        invisible(0)
      },
      temp_file = function(fileext = "") tempfile(fileext = fileext)
    )
    stats2table(
      type = "aparc",
      input = "subj",
      input_type = "subjects",
      measure = "gauscurv",
      verbose = FALSE
    )
  })

  it("correctly assigns delimiter attribute to output", {
    withr::local_tempdir()
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "aparcstats2table_mock_binary",
      run_check_fs_cmd = mock_run_check_fs_cmd,
      temp_file = function(fileext = "") tempfile(fileext = fileext)
    )

    outfile_tab <- stats2table(
      type = "aparc",
      input = "subj",
      input_type = "subjects",
      measure = "area",
      delim = "tab",
      verbose = FALSE
    )
    expect_equal(attr(outfile_tab, "delimiter"), "\t")

    outfile_comma <- stats2table(
      type = "aparc",
      input = "subj",
      input_type = "subjects",
      measure = "area",
      delim = "comma",
      verbose = FALSE
    )
    expect_equal(attr(outfile_comma, "delimiter"), ",")
  })

  it("propagates run_check_fs_cmd errors", {
    local_mocked_bindings(
      validate_fs_env = function(...) TRUE,
      get_fs = function() "aparcstats2table_mock_binary",
      run_check_fs_cmd = function(cmd, outfile, verbose, ...) {
        fs_abort("FreeSurfer command failed!")
      },
      temp_file = function(fileext = "") tempfile(fileext = fileext)
    )

    expect_error(
      stats2table(
        type = "aparc",
        input = "error_subj",
        input_type = "subjects",
        measure = "thickness",
        verbose = FALSE
      ),
      "FreeSurfer command failed!"
    )
  })
})

describe("asegstats2table", {
  it("errors when both subjects and inputs are specified", {
    expect_error(
      asegstats2table(
        subjects = "subj",
        inputs = "input.stats",
        measure = "volume",
        verbose = FALSE
      ),
      "'subjects' and 'inputs' cannot both be specified for asegstats2table."
    )
  })

  it("errors when neither subjects nor inputs are specified", {
    expect_error(
      asegstats2table(
        subjects = NULL,
        inputs = NULL,
        measure = "volume"
      ),
      "Either 'subjects' or 'inputs' must be specified for asegstats2table."
    )
  })

  it("calls stats2table correctly with subjects argument", {
    mock_stats2table_call <- function(type, input, input_type, measure, ...) {
      expect_equal(type, "aseg")
      expect_equal(input, "subj1")
      expect_equal(input_type, "subjects")
      expect_equal(measure, "volume")
      withr::local_tempfile(fileext = ".txt")
    }
    local_mocked_bindings(stats2table = mock_stats2table_call)

    outfile <- asegstats2table(
      subjects = "subj1",
      measure = "volume",
      verbose = FALSE
    )
  })

  it("calls stats2table correctly with inputs argument", {
    mock_stats2table_call <- function(type, input, input_type, measure, ...) {
      expect_equal(type, "aseg")
      expect_equal(input, "input1.stats")
      expect_equal(input_type, "inputs")
      expect_equal(measure, "mean")
      return(withr::local_tempfile(fileext = ".txt"))
    }
    local_mocked_bindings(stats2table = mock_stats2table_call)

    outfile <- asegstats2table(
      inputs = "input1.stats",
      measure = "mean",
      verbose = FALSE
    )
  })
})

describe("aparcstats2table", {
  it("errors when subjects is empty", {
    expect_error(
      aparcstats2table(subjects = character(0)),
      "Subjects must be specified for aparcstats2table."
    )
  })

  it("errors when subjects is NULL", {
    expect_error(
      aparcstats2table(subjects = NULL, verbose = FALSE),
      "Subjects must be specified for aparcstats2table."
    )
  })

  it("calls stats2table with correct hemi and parc options", {
    mock_stats2table_call <- function(
      type,
      input,
      input_type,
      measure,
      opts,
      ...
    ) {
      expect_equal(type, "aparc")
      expect_equal(input, "subj_aparc")
      expect_equal(input_type, "subjects")
      expect_equal(measure, "thickness")
      expect_match(opts, "--hemi lh")
      expect_match(opts, "--parc aparc")
      return(withr::local_tempfile(fileext = ".txt"))
    }
    local_mocked_bindings(stats2table = mock_stats2table_call)

    outfile <- aparcstats2table(
      subjects = "subj_aparc",
      hemi = "lh",
      measure = "thickness",
      parc = "aparc",
      verbose = FALSE
    )
  })

  it("combines internal and user-provided opts", {
    mock_stats2table_call <- function(
      type,
      input,
      input_type,
      measure,
      opts,
      ...
    ) {
      expect_match(opts, "--hemi rh")
      expect_match(opts, "--parc aparc.a2009s")
      expect_match(opts, "--user-flag --another-flag")
      return(withr::local_tempfile(fileext = ".txt"))
    }
    local_mocked_bindings(stats2table = mock_stats2table_call)

    outfile <- aparcstats2table(
      subjects = "subj_combined_opts",
      hemi = "rh",
      measure = "volume",
      parc = "aparc.a2009s",
      opts = "--user-flag --another-flag",
      verbose = FALSE
    )
  })
})

describe("aparcstats2table integration", {
  it("runs with FreeSurfer", {
    skip_if_no_freesurfer()

    bert_stats <- file.path(fs_subj_dir(), "bert", "stats", "lh.aparc.stats")
    skip_if_not(file.exists(bert_stats), "bert subject not available")

    outfile <- withr::local_tempfile(fileext = ".tsv")

    result <- aparcstats2table(
      subjects = c("bert"),
      hemi = "lh",
      measure = "thickness",
      delim = "tab",
      outfile = outfile,
      verbose = FALSE
    )

    expect_true(file.exists(outfile))
    attr(outfile, "delimiter") <- "\t"
    expect_equal(result, outfile)

    content <- read.table(outfile, header = TRUE, sep = "\t")
    expect_true(nrow(content) > 0)
    expect_true("bert" %in% content[, 1])
  })
})
