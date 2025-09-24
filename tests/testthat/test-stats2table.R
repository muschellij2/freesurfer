# This is the function that actually executes the system command.
# We will mock this specifically using local_mocked_bindings.
mock_run_check_fs_cmd <- function(cmd, outfile, verbose, ...) {
  message(paste("Mocking command execution:", cmd))
  writeLines("mock_data", outfile)
  return(invisible(0))
}

test_that("stats2table validates 'input' argument", {
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

test_that("stats2table handles basic valid arguments and creates output file", {
  local_mocked_bindings(
    get_fs = function() {
      "aparcstats2table_mock_binary"
    },
    run_check_fs_cmd = mock_run_check_fs_cmd,
    temp_file = function(fileext = "") {
      tempfile(fileext = fileext)
    }
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

test_that("stats2table creates temp file if outfile is NULL", {
  withr::local_tempdir()
  local_mocked_bindings(
    get_fs = function() {
      "aparcstats2table_mock_binary"
    },
    run_check_fs_cmd = mock_run_check_fs_cmd,
    temp_file = function(fileext = "") {
      tempfile(fileext = fileext)
    }
  )
  outfile <- stats2table(
    type = "aparc",
    input = "testsubj",
    input_type = "subjects",
    measure = "volume"
  )
  expect_true(file.exists(outfile))
  expect_match(basename(outfile), "^file")
})

test_that("stats2table handles different delimiters correctly", {
  local_mocked_bindings(
    get_fs = function() {
      "aparcstats2table_mock_binary"
    },
    run_check_fs_cmd = mock_run_check_fs_cmd,
    temp_file = function(fileext = "") {
      tempfile(fileext = fileext)
    }
  )

  # Test tab
  outfile_tab <- stats2table(
    type = "aparc",
    input = "subj",
    input_type = "subjects",
    measure = "area",
    delim = "tab"
  )
  expect_equal(attr(outfile_tab, "delimiter"), "\t")
  expect_match(outfile_tab, "\\.tsv$")

  # Test space
  outfile_space <- stats2table(
    type = "aparc",
    input = "subj",
    input_type = "subjects",
    measure = "area",
    delim = "space"
  )
  expect_equal(attr(outfile_space, "delimiter"), " ")
  expect_match(outfile_space, "\\.txt$")

  # Test comma
  outfile_comma <- stats2table(
    type = "aparc",
    input = "subj",
    input_type = "subjects",
    measure = "area",
    delim = "comma"
  )
  expect_equal(attr(outfile_comma, "delimiter"), ",")
  expect_match(outfile_comma, "\\.csv$")

  # Test semicolon
  outfile_semicolon <- stats2table(
    type = "aparc",
    input = "subj",
    input_type = "subjects",
    measure = "area",
    delim = "semicolon"
  )
  expect_equal(attr(outfile_semicolon, "delimiter"), ";")
  expect_match(outfile_semicolon, "\\.csv$")
})

test_that("stats2table constructs correct command arguments for subjects", {
  local_mocked_bindings(
    get_fs = function() {
      "aparcstats2table_mock_binary"
    },
    run_check_fs_cmd = function(cmd, outfile, verbose, ...) {
      # Custom mock for this test
      expect_match(cmd, "aparcstats2table_mock_binary aparcstats2table")
      expect_match(cmd, "--subjects subj1 subj2")
      expect_match(cmd, "--delimiter tab")
      expect_match(cmd, "--meas thickness")
      expect_match(cmd, "--tablefile ")
      expect_no_match(cmd, "--inputs") # Ensure inputs is not present
      file.create(outfile)
      invisible(0)
    },
    temp_file = function(fileext = "") {
      tempfile(fileext = fileext)
    }
  )
  stats2table(
    type = "aparc",
    input = c("subj1", "subj2"),
    input_type = "subjects",
    measure = "thickness",
    delim = "tab"
  )
})

test_that("stats2table constructs correct command arguments for inputs", {
  local_mocked_bindings(
    get_fs = function() {
      "aparcstats2table_mock_binary"
    },
    run_check_fs_cmd = function(cmd, outfile, verbose, ...) {
      # Custom mock for this test
      expect_match(cmd, "aparcstats2table_mock_binary asegstats2table")
      expect_match(cmd, "--inputs input1.stats input2.stats")
      expect_match(cmd, "--delimiter comma")
      expect_match(cmd, "--meas volume")
      expect_match(cmd, "--tablefile ")
      expect_no_match(cmd, "--subjects") # Ensure subjects is not present
      file.create(outfile)
      invisible(0)
    },
    temp_file = function(fileext = "") {
      tempfile(fileext = fileext)
    }
  )
  stats2table(
    type = "aseg",
    input = c("input1.stats", "input2.stats"),
    input_type = "inputs",
    measure = "volume",
    delim = "comma"
  )
})

test_that("stats2table handles skip, verbose, subj_dir, and opts", {
  mock_subj_dir <- file.path(
    withr::local_tempdir(),
    "test_subjects_dir"
  )
  dir.create(mock_subj_dir, recursive = TRUE)

  local_mocked_bindings(
    get_fs = function() {
      "aparcstats2table_mock_binary"
    },
    run_check_fs_cmd = function(cmd, outfile, verbose, ...) {
      # Custom mock for this test
      expect_match(cmd, "--skip")
      expect_match(cmd, "--debug")
      expect_match(cmd, paste0("export SUBJECTS_DIR=", mock_subj_dir, ";"))
      expect_match(cmd, "some_extra_opts")
      file.create(outfile)
      invisible(0)
    },
    temp_file = function(fileext = "") {
      tempfile(fileext = fileext)
    }
  )

  stats2table(
    type = "aparc",
    input = "subj_skip",
    input_type = "subjects",
    measure = "volume",
    skip = TRUE,
    verbose = TRUE,
    subj_dir = mock_subj_dir,
    opts = "some_extra_opts"
  )
})

test_that("stats2table handles different `measure` arguments", {
  local_mocked_bindings(
    get_fs = function() {
      "aparcstats2table_mock_binary"
    },
    run_check_fs_cmd = function(cmd, outfile, verbose, ...) {
      # Custom mock for this test
      expect_match(cmd, "--meas area")
      file.create(outfile)
      invisible(0)
    },
    temp_file = function(fileext = "") {
      tempfile(fileext = fileext)
    }
  )
  stats2table(
    type = "aparc",
    input = "subj",
    input_type = "subjects",
    measure = "area"
  )

  local_mocked_bindings(
    get_fs = function() {
      "aparcstats2table_mock_binary"
    },
    run_check_fs_cmd = function(cmd, outfile, verbose, ...) {
      # Custom mock for this test
      expect_match(cmd, "--meas gauscurv")
      file.create(outfile)
      invisible(0)
    },
    temp_file = function(fileext = "") {
      tempfile(fileext = fileext)
    }
  )
  stats2table(
    type = "aparc",
    input = "subj",
    input_type = "subjects",
    measure = "gauscurv"
  )
})

test_that("stats2table correctly assigns delimiter attribute", {
  withr::local_tempdir()
  local_mocked_bindings(
    get_fs = function() {
      "aparcstats2table_mock_binary"
    },
    run_check_fs_cmd = mock_run_check_fs_cmd,
    temp_file = function(fileext = "") {
      tempfile(fileext = fileext)
    }
  )

  outfile_tab <- stats2table(
    type = "aparc",
    input = "subj",
    input_type = "subjects",
    measure = "area",
    delim = "tab"
  )
  expect_equal(attr(outfile_tab, "delimiter"), "\t")

  outfile_comma <- stats2table(
    type = "aparc",
    input = "subj",
    input_type = "subjects",
    measure = "area",
    delim = "comma"
  )
  expect_equal(attr(outfile_comma, "delimiter"), ",")
})

test_that("stats2table handles `run_check_fs_cmd` failure", {
  local_mocked_bindings(
    get_fs = function() {
      "aparcstats2table_mock_binary"
    },
    run_check_fs_cmd = function(cmd, outfile, verbose, ...) {
      # Custom mock for this test
      # Simulate an error from the system command
      stop("FreeSurfer command failed!")
    },
    temp_file = function(fileext = "") {
      tempfile(fileext = fileext)
    }
  )

  expect_error(
    stats2table(
      type = "aparc",
      input = "error_subj",
      input_type = "subjects",
      measure = "thickness"
    ),
    "FreeSurfer command failed!"
  )
})


test_that("stats2table works with Freesurfer", {
  skip_if_no_freesurfer()

  outfile <- withr::local_tempfile(fileext = ".tsv")

  result <- aparcstats2table(
    subjects = c("bert"), # Replace with a subject you know exists
    hemi = "lh",
    measure = "thickness",
    delim = "tab",
    outfile = outfile,
    verbose = FALSE
  )

  expect_true(file.exists(outfile))
  attr(outfile, "delimiter") <- "\t"
  expect_equal(result, outfile)

  # Check the content of the file (basic check)
  content <- read.table(outfile, header = TRUE, sep = "\t")
  expect_true(nrow(content) > 0)
  expect_true("bert" %in% content[, 1])
})

# --- asegstats tests ---
test_that("asegstats2table validates 'subjects' and 'inputs' exclusivity", {
  expect_error(
    asegstats2table(
      subjects = "subj",
      inputs = "input.stats",
      measure = "volume"
    ),
    "'subjects' and 'inputs' cannot both be specified for asegstats2table."
  )
  expect_error(
    asegstats2table(
      subjects = NULL,
      inputs = NULL,
      measure = "volume"
    ),
    "Either 'subjects' or 'inputs' must be specified for asegstats2table."
  )
})

test_that("asegstats2table calls stats2table correctly with subjects", {
  # Mock stats2table to verify its arguments
  mock_stats2table_call <- function(type, input, input_type, measure, ...) {
    expect_equal(type, "aseg")
    expect_equal(input, "subj1")
    expect_equal(input_type, "subjects")
    expect_equal(measure, "volume")
    withr::local_tempfile(fileext = ".txt")
  }
  local_mocked_bindings(stats2table = mock_stats2table_call)

  outfile <- asegstats2table(subjects = "subj1", measure = "volume")
})

test_that("asegstats2table calls stats2table correctly with inputs", {
  # Mock stats2table to verify its arguments
  mock_stats2table_call <- function(type, input, input_type, measure, ...) {
    expect_equal(type, "aseg")
    expect_equal(input, "input1.stats")
    expect_equal(input_type, "inputs")
    expect_equal(measure, "mean")
    # Simulate stats2table's return
    return(withr::local_tempfile(fileext = ".txt"))
  }
  local_mocked_bindings(stats2table = mock_stats2table_call)

  outfile <- asegstats2table(inputs = "input1.stats", measure = "mean")
})


test_that("aparcstats2table validates 'subjects' argument", {
  expect_error(
    aparcstats2table(subjects = character(0)),
    "Subjects must be specified for aparcstats2table."
  )
  expect_error(
    aparcstats2table(subjects = NULL),
    "Subjects must be specified for aparcstats2table."
  )
})

# --- aparcstats2table tests ---
test_that("aparcstats2table calls stats2table correctly and constructs opts", {
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
    # Simulate stats2table's return
    return(withr::local_tempfile(fileext = ".txt"))
  }
  local_mocked_bindings(stats2table = mock_stats2table_call)

  outfile <- aparcstats2table(
    subjects = "subj_aparc",
    hemi = "lh",
    measure = "thickness",
    parc = "aparc"
  )
})

test_that("aparcstats2table combines internal and user-provided opts", {
  # Mock stats2table to verify its arguments
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
    expect_match(opts, "--user-flag --another-flag") # Check for user-provided opts
    # Simulate stats2table's return
    return(withr::local_tempfile(fileext = ".txt"))
  }
  local_mocked_bindings(stats2table = mock_stats2table_call)

  outfile <- aparcstats2table(
    subjects = "subj_combined_opts",
    hemi = "rh",
    measure = "volume",
    parc = "aparc.a2009s",
    opts = "--user-flag --another-flag"
  )
})
