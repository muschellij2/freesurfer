describe("utils-files", {
  it("handles empty input", {
    expect_equal(batch_file_exists(character(0)), logical(0))
  })

  it("returns named logical vector for existing files", {
    td <- local_tempdir()
    f1 <- file.path(td, "one.txt")
    f2 <- file.path(td, "two.txt")
    file.create(f1)
    file.create(f2)
    res <- batch_file_exists(c(f1, f2))
    expect_named(res, c(f1, f2))
    expect_true(all(res))
  })

  it("reports missing files (warning)", {
    td <- local_tempdir()
    existing <- file.path(td, "exists.txt")
    file.create(existing)
    missing <- file.path(td, "nope.txt")
    expect_warning(
      res <- batch_file_exists(c(existing, missing), warn = TRUE),
      "Some files are missing"
    )
    expect_false(res[missing])
    expect_true(res[existing])
  })

  it("errors when missing and error = TRUE", {
    td <- local_tempdir()
    missing <- file.path(td, "will_not_exist.txt")
    expect_error(
      batch_file_exists(missing, error = TRUE),
      "Missing required files"
    )
  })

  it("enforces single path and error behaviour", {
    td <- local_tempdir()
    f <- file.path(td, "afile.txt")
    file.create(f)
    expect_true(check_path(f))

    # multiple paths -> error
    expect_error(check_path(c(f, f)), "check_path expects a single path")

    # non-existent with error = FALSE returns FALSE
    missing <- file.path(td, "nope2.txt")
    expect_false(check_path(missing, error = FALSE))

    # non-existent with error = TRUE errors with details
    expect_error(check_path(missing, error = TRUE), "File does not exist")
  })

  it("errors on empty input", {
    expect_error(validate_fs_inputs(character(0)), "No input files provided")
  })

  it("checks formats and reports invalid files", {
    td <- local_tempdir()
    a <- file.path(td, "a.nii.gz") |>
      normalizePath(mustWork = FALSE)
    b <- file.path(td, "b.mgz") |>
      normalizePath(mustWork = FALSE)
    file.create(a)
    file.create(b)
    expect_error(
      validate_fs_inputs(c(a, b), formats = c("nii.gz")),
      "Invalid file formats detected"
    )

    # when formats match there is no error
    expect_equal(
      validate_fs_inputs(a, formats = c("nii.gz")),
      normalizePath(a, mustWork = FALSE)
    )
  })

  it("enforces must_exist by delegating to batch_file_exists", {
    td <- local_tempdir()
    exists <- file.path(td, "exists.mgz")
    file.create(exists)
    missing <- file.path(td, "missing.mgz")
    expect_error(
      validate_fs_inputs(c(exists, missing), must_exist = TRUE),
      "Missing required files"
    )

    # must_exist = FALSE should return expanded paths even if missing
    out <- validate_fs_inputs(c(exists, missing), must_exist = FALSE)
    expect_equal(out, normalizePath(c(exists, missing), mustWork = FALSE))
  })

  it("returns temp path when retimg = TRUE and outfile is NULL", {
    res <- validate_outfile(NULL, retimg = TRUE, default_ext = ".nii.gz")
    expect_true(endsWith(res, ".nii.gz"))
  })

  it("errors when retimg = FALSE and outfile is NULL", {
    expect_error(
      validate_outfile(NULL, retimg = FALSE),
      "Output file path required when retimg = FALSE"
    )
  })

  it("expands outfile and creates parent directory if missing", {
    td <- local_tempdir()
    parent <- file.path(td, "nested", "sub")
    outfile <- file.path(parent, "out.nii.gz")
    # ensure parent does not exist yet
    expect_false(dir.exists(parent))
    res <- validate_outfile(outfile, retimg = FALSE)
    expect_equal(res, path.expand(outfile))
    expect_true(dir.exists(parent))
  })

  it("is a thin wrapper for validate_outfile", {
    # when retimg = TRUE and outfile = NULL it should behave like validate_outfile
    res1 <- validate_outfile(NULL, retimg = TRUE, default_ext = ".nii.gz")
    res2 <- check_outfile(NULL, TRUE, fileext = ".nii.gz")
    expect_true(endsWith(res2, ".nii.gz"))
    expect_type(res2, "character")
  })
})
