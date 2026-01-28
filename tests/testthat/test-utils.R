describe("mkdir", {
  it("creates a new directory", {
    temp_base <- withr::local_tempdir()
    temp_dir <- file.path(temp_base, "test_mkdir_dir")

    expect_false(dir.exists(temp_dir))
    mkdir(temp_dir)
    expect_true(dir.exists(temp_dir))
  })

  it("handles existing directories without error", {
    temp_base <- withr::local_tempdir()
    temp_dir <- file.path(temp_base, "test_existing_dir")
    mkdir(temp_dir)

    expect_true(dir.exists(temp_dir))
    expect_silent(mkdir(temp_dir))
    expect_true(dir.exists(temp_dir))
  })
})

describe("temp_file", {
  it("creates a temporary file path with directory", {
    withr::local_tempdir()
    temp_file <- temp_file(pattern = "test_file_")

    expect_type(temp_file, "character")
    expect_true(dir.exists(dirname(temp_file)))
    expect_match(temp_file, "test_file_")
  })

  it("applies custom pattern and extension", {
    withr::local_tempdir()
    temp_file <- temp_file(pattern = "custom_pattern_", fileext = ".txt")

    expect_match(basename(temp_file), "^custom_pattern_.*\\.txt$")
    expect_true(dir.exists(dirname(temp_file)))
  })

  it("works without custom arguments", {
    withr::local_tempdir()
    temp_file <- temp_file()

    expect_true(file.exists(dirname(temp_file)))
  })

  it("creates directory but not the file itself", {
    withr::local_tempdir()
    temp_file <- temp_file(pattern = "test_no_file_creation_")

    expect_false(file.exists(temp_file))
    expect_true(dir.exists(dirname(temp_file)))
  })

  it("respects custom tmpdir argument", {
    base_tmp <- withr::local_tempdir()
    tf <- temp_file(tmpdir = base_tmp, pattern = "provided_dir_")

    expect_true(grepl(basename(base_tmp), tf, fixed = TRUE))
    expect_true(dir.exists(dirname(tf)))
  })
})

describe("sys_info", {
  it("returns expected components", {
    si <- sys_info()

    expect_type(si, "list")
    expect_true(all(c("platform", "r_version", "shell") %in% names(si)))
    expect_type(si$platform, "character")
    expect_type(si$r_version, "character")
    expect_type(si$shell, "character")
  })
})

describe("check_path", {
  it("returns TRUE for existing file", {
    temp_file <- withr::local_tempfile()
    file.create(temp_file)
    expect_true(check_path(temp_file))
  })

  it("errors for missing file when error = TRUE", {
    missing_file <- tempfile()
    expect_error(
      check_path(missing_file),
      "File does not exist"
    )
  })

  it("returns FALSE for missing file when error = FALSE", {
    missing_file <- tempfile()
    expect_false(check_path(missing_file, error = FALSE))
  })
})

describe("check_outfile", {
  it("returns tempfile when retimg = TRUE and outfile = NULL", {
    temp_file <- check_outfile(outfile = NULL, retimg = TRUE)

    expect_type(temp_file, "character")
    expect_match(temp_file, "\\.nii\\.gz$")
  })

  it("errors when outfile = NULL and retimg = FALSE", {
    expect_error(
      check_outfile(outfile = NULL, retimg = FALSE),
      "Either provide outfile or set retimg = TRUE"
    )
  })

  it("returns expanded path for valid outfile", {
    dummy_file <- withr::local_tempfile()
    outfile_path <- path.expand(dummy_file)
    result <- check_outfile(outfile = outfile_path, retimg = FALSE)

    expect_equal(result, normalizePath(outfile_path, mustWork = FALSE))
  })

  it("applies custom file extension for tempfiles", {
    custom_ext <- ".testfile"
    temp_file <- check_outfile(
      outfile = NULL,
      retimg = TRUE,
      fileext = custom_ext
    )

    expect_match(temp_file, "\\.testfile$")
  })
})

describe("validate_fs_env", {
  it("returns invisibly TRUE when FreeSurfer available", {
    local_fs_unset()
    local_mocked_bindings(
      have_fs = function() TRUE,
      get_fs_license = function(...) {
        list(value = "/tmp/license.txt", exists = TRUE)
      }
    )

    result <- validate_fs_env(check_license = FALSE)
    expect_true(result)
  })

  it("checks license when check_license = TRUE", {
    local_fs_unset()
    local_mocked_bindings(
      have_fs = function() TRUE,
      get_fs_license = function(...) {
        list(value = "/tmp/license.txt", exists = TRUE)
      }
    )

    res <- tryCatch(
      withCallingHandlers(
        {
          validate_fs_env(check_license = TRUE)
          list(warn = FALSE, ok = TRUE)
        },
        warning = function(w) {
          invokeRestart("muffleWarning")
          list(warn = TRUE, ok = TRUE)
        }
      ),
      error = function(e) list(warn = NA, ok = FALSE)
    )

    expect_true(is.list(res))
    expect_true(res$ok)
  })
})
