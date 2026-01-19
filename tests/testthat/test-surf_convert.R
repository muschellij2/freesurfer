describe("surf_convert", {
  it("calls fs_cmd with mri_convert function", {
    temp_file <- withr::local_tempfile(fileext = ".thickness")
    out_file <- withr::local_tempfile(fileext = ".dat")
    writeLines("test", temp_file)
    writeLines("1 0 0 0 1.5\n2 0 0 1 2.5", out_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      }
    )

    surf_convert(temp_file, outfile = out_file)

    expect_equal(captured_args$func, "mri_convert")
  })

  it("uses --ascii+crsf as frontopts", {
    temp_file <- withr::local_tempfile(fileext = ".thickness")
    out_file <- withr::local_tempfile(fileext = ".dat")
    writeLines("test", temp_file)
    writeLines("1 0 0 0 1.5\n2 0 0 1 2.5", out_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      }
    )

    surf_convert(temp_file, outfile = out_file)

    expect_equal(captured_args$frontopts, "--ascii+crsf")
  })

  it("sets retimg = FALSE", {
    temp_file <- withr::local_tempfile(fileext = ".thickness")
    out_file <- withr::local_tempfile(fileext = ".dat")
    writeLines("test", temp_file)
    writeLines("1 0 0 0 1.5\n2 0 0 1 2.5", out_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        0
      }
    )

    surf_convert(temp_file, outfile = out_file)

    expect_false(captured_args$retimg)
  })

  it("creates temp output file when outfile is NULL", {
    temp_file <- withr::local_tempfile(fileext = ".thickness")
    writeLines("test", temp_file)

    captured_args <- NULL
    local_mocked_bindings(
      fs_cmd = function(...) {
        captured_args <<- list(...)
        1
      }
    )

    expect_error(surf_convert(temp_file))

    expect_match(captured_args$outfile, "\\.dat$")
  })

  it("returns matrix with correct column names", {
    temp_file <- withr::local_tempfile(fileext = ".thickness")
    out_file <- withr::local_tempfile(fileext = ".dat")
    writeLines("test", temp_file)
    writeLines(c("1 0 0 0 1.5", "2 0 0 1 2.5"), out_file)

    local_mocked_bindings(
      fs_cmd = function(...) 0
    )

    result <- surf_convert(temp_file, outfile = out_file)

    expect_equal(
      colnames(result),
      c("col", "row", "slice", "frame", "value")
    )
  })

  it("parses numeric values correctly", {
    temp_file <- withr::local_tempfile(fileext = ".thickness")
    out_file <- withr::local_tempfile(fileext = ".dat")
    writeLines("test", temp_file)
    writeLines(c("1 2 3 4 5.5", "6 7 8 9 10.5"), out_file)

    local_mocked_bindings(
      fs_cmd = function(...) 0
    )

    result <- surf_convert(temp_file, outfile = out_file)

    expect_equal(unname(result[1, "col"]), 1)
    expect_equal(unname(result[1, "row"]), 2)
    expect_equal(unname(result[1, "slice"]), 3)
    expect_equal(unname(result[1, "frame"]), 4)
    expect_equal(unname(result[1, "value"]), 5.5)
    expect_equal(unname(result[2, "value"]), 10.5)
  })

  it("handles whitespace in output file", {
    temp_file <- withr::local_tempfile(fileext = ".thickness")
    out_file <- withr::local_tempfile(fileext = ".dat")
    writeLines("test", temp_file)
    writeLines(c("  1   2  3  4   5.5  ", "6 7 8 9 10.5"), out_file)

    local_mocked_bindings(
      fs_cmd = function(...) 0
    )

    result <- surf_convert(temp_file, outfile = out_file)

    expect_equal(nrow(result), 2)
    expect_equal(unname(result[1, "col"]), 1)
  })

  it("errors when fs_cmd returns non-zero", {
    temp_file <- withr::local_tempfile(fileext = ".thickness")
    out_file <- withr::local_tempfile(fileext = ".dat")
    writeLines("test", temp_file)
    writeLines("1 2 3 4 5", out_file)

    local_mocked_bindings(
      fs_cmd = function(...) 1
    )

    expect_error(surf_convert(temp_file, outfile = out_file))
  })
})
