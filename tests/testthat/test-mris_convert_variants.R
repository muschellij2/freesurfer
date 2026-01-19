describe("mris_convert_annot", {
  it("prepends --annot to opts", {
    captured_opts <- NULL
    local_mocked_bindings(
      mris_convert = function(...) {
        args <- list(...)
        captured_opts <<- args$opts
        "output.asc"
      }
    )

    mris_convert_annot(
      annot = "/path/to/lh.aparc.annot",
      infile = "/path/to/lh.white"
    )

    expect_match(captured_opts, "^--annot /path/to/lh.aparc.annot")
  })

  it("appends existing opts after annot", {
    captured_opts <- NULL
    local_mocked_bindings(
      mris_convert = function(...) {
        args <- list(...)
        captured_opts <<- args$opts
        "output.asc"
      }
    )

    mris_convert_annot(
      annot = "/path/to/lh.aparc.annot",
      opts = "--extra-flag",
      infile = "/path/to/lh.white"
    )

    expect_match(captured_opts, "--annot .* --extra-flag")
  })

  it("passes additional arguments to mris_convert", {
    captured_args <- NULL
    local_mocked_bindings(
      mris_convert = function(...) {
        captured_args <<- list(...)
        "output.gii"
      }
    )

    mris_convert_annot(
      annot = "/path/to/annot",
      infile = "/path/to/surf",
      ext = ".gii"
    )

    expect_equal(captured_args$infile, "/path/to/surf")
    expect_equal(captured_args$ext, ".gii")
  })

  it("collapses multiple opts", {
    captured_opts <- NULL
    local_mocked_bindings(
      mris_convert = function(...) {
        args <- list(...)
        captured_opts <<- args$opts
        "output.asc"
      }
    )

    mris_convert_annot(
      annot = "/path/to/annot",
      opts = c("-a", "-b"),
      infile = "/path/to/surf"
    )

    expect_match(captured_opts, "--annot /path/to/annot -a -b")
  })
})

describe("mris_convert_curv", {
  it("prepends -c to opts", {
    captured_opts <- NULL
    local_mocked_bindings(
      mris_convert = function(...) {
        args <- list(...)
        captured_opts <<- args$opts
        "output.asc"
      }
    )

    mris_convert_curv(
      curv = "/path/to/lh.thickness",
      infile = "/path/to/lh.white"
    )

    expect_match(captured_opts, "^-c /path/to/lh.thickness")
  })

  it("appends existing opts after curv", {
    captured_opts <- NULL
    local_mocked_bindings(
      mris_convert = function(...) {
        args <- list(...)
        captured_opts <<- args$opts
        "output.asc"
      }
    )

    mris_convert_curv(
      curv = "/path/to/lh.thickness",
      opts = "--extra-flag",
      infile = "/path/to/lh.white"
    )

    expect_match(captured_opts, "-c .* --extra-flag")
  })

  it("passes additional arguments to mris_convert", {
    captured_args <- NULL
    local_mocked_bindings(
      mris_convert = function(...) {
        captured_args <<- list(...)
        "output.asc"
      }
    )

    mris_convert_curv(
      curv = "/path/to/curv",
      infile = "/path/to/surf",
      outfile = "/path/to/out.asc"
    )

    expect_equal(captured_args$infile, "/path/to/surf")
    expect_equal(captured_args$outfile, "/path/to/out.asc")
  })
})

describe("mris_convert_normals", {
  it("appends -n to opts", {
    captured_opts <- NULL
    local_mocked_bindings(
      mris_convert = function(...) {
        args <- list(...)
        captured_opts <<- args$opts
        "output.asc"
      }
    )

    mris_convert_normals(infile = "/path/to/lh.white")

    expect_match(captured_opts, "-n\\s*$")
  })

  it("prepends existing opts before -n", {
    captured_opts <- NULL
    local_mocked_bindings(
      mris_convert = function(...) {
        args <- list(...)
        captured_opts <<- args$opts
        "output.asc"
      }
    )

    mris_convert_normals(
      opts = "--extra-flag",
      infile = "/path/to/lh.white"
    )

    expect_match(captured_opts, "--extra-flag.*-n")
  })

  it("passes additional arguments to mris_convert", {
    captured_args <- NULL
    local_mocked_bindings(
      mris_convert = function(...) {
        captured_args <<- list(...)
        "output.asc"
      }
    )

    mris_convert_normals(
      infile = "/path/to/surf",
      outfile = "/path/to/out.asc",
      ext = ".dat"
    )

    expect_equal(captured_args$infile, "/path/to/surf")
    expect_equal(captured_args$outfile, "/path/to/out.asc")
    expect_equal(captured_args$ext, ".dat")
  })

  it("collapses multiple opts", {
    captured_opts <- NULL
    local_mocked_bindings(
      mris_convert = function(...) {
        args <- list(...)
        captured_opts <<- args$opts
        "output.asc"
      }
    )

    mris_convert_normals(
      opts = c("-a", "-b"),
      infile = "/path/to/surf"
    )

    expect_match(captured_opts, "-a -b.*-n")
  })
})

describe("mris_convert_vertex", {
  it("appends -v to opts", {
    captured_opts <- NULL
    local_mocked_bindings(
      mris_convert = function(...) {
        args <- list(...)
        captured_opts <<- args$opts
        "output.asc"
      }
    )

    mris_convert_vertex(infile = "/path/to/lh.white")

    expect_match(captured_opts, "-v\\s*$")
  })

  it("prepends existing opts before -v", {
    captured_opts <- NULL
    local_mocked_bindings(
      mris_convert = function(...) {
        args <- list(...)
        captured_opts <<- args$opts
        "output.asc"
      }
    )

    mris_convert_vertex(
      opts = "--extra-flag",
      infile = "/path/to/lh.white"
    )

    expect_match(captured_opts, "--extra-flag.*-v")
  })

  it("passes additional arguments to mris_convert", {
    captured_args <- NULL
    local_mocked_bindings(
      mris_convert = function(...) {
        captured_args <<- list(...)
        "output.asc"
      }
    )

    mris_convert_vertex(
      infile = "/path/to/surf",
      outfile = "/path/to/out.asc"
    )

    expect_equal(captured_args$infile, "/path/to/surf")
    expect_equal(captured_args$outfile, "/path/to/out.asc")
  })

  it("collapses multiple opts", {
    captured_opts <- NULL
    local_mocked_bindings(
      mris_convert = function(...) {
        args <- list(...)
        captured_opts <<- args$opts
        "output.asc"
      }
    )

    mris_convert_vertex(
      opts = c("-a", "-b"),
      infile = "/path/to/surf"
    )

    expect_match(captured_opts, "-a -b.*-v")
  })
})
