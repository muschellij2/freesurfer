describe("fs_help_rd", {
  it("returns fallback when FreeSurfer not available", {
    local_mocked_bindings(have_fs = function(...) FALSE)
    result <- fs_help_rd("mri_convert")
    expect_match(result, "FreeSurfer is not installed")
    expect_match(result, "mri_convert\\.help\\(\\)")
  })

  it("includes func_name in fallback message", {
    local_mocked_bindings(have_fs = function(...) FALSE)
    result <- fs_help_rd("nu_correct")
    expect_match(result, "nu_correct\\.help\\(\\)")
  })

  it("returns 'not available' when command errors", {
    local_mocked_bindings(
      have_fs = function(...) TRUE,
      get_fs = function(...) stop("no FreeSurfer")
    )
    result <- fs_help_rd("mri_convert")
    expect_match(result, "Help not available")
    expect_match(result, "mri_convert")
  })

  it("uses default help_arg and bin_app", {
    captured_bin_app <- NULL
    local_mocked_bindings(
      have_fs = function(...) TRUE,
      get_fs = function(bin_app = "bin") {
        captured_bin_app <<- bin_app
        stop("mock")
      }
    )
    fs_help_rd("mri_convert")
    expect_equal(captured_bin_app, "bin")
  })

  it("passes custom help_arg and bin_app", {
    captured_bin_app <- NULL
    captured_cmd <- NULL
    local_mocked_bindings(
      have_fs = function(...) TRUE,
      get_fs = function(bin_app = "bin") {
        captured_bin_app <<- bin_app
        stop("mock")
      }
    )
    fs_help_rd("nu_correct", "-help", "mni/bin")
    expect_equal(captured_bin_app, "mni/bin")
  })
})

describe("roxy_tag_parse.roxy_tag_fsHelp", {
  make_tag <- function(raw) {
    structure(list(raw = raw), class = c("roxy_tag_fsHelp", "roxy_tag"))
  }

  it("parses command name only", {
    tag <- make_tag("mri_convert")
    result <- roxy_tag_parse(tag)
    expect_equal(result$val$func_name, "mri_convert")
    expect_equal(result$val$help_arg, "--help")
    expect_equal(result$val$bin_app, "bin")
  })

  it("parses command name with custom help_arg", {
    tag <- make_tag("nu_correct -help")
    result <- roxy_tag_parse(tag)
    expect_equal(result$val$func_name, "nu_correct")
    expect_equal(result$val$help_arg, "-help")
    expect_equal(result$val$bin_app, "bin")
  })

  it("parses command name with custom help_arg and bin_app", {
    tag <- make_tag("nu_correct -help mni/bin")
    result <- roxy_tag_parse(tag)
    expect_equal(result$val$func_name, "nu_correct")
    expect_equal(result$val$help_arg, "-help")
    expect_equal(result$val$bin_app, "mni/bin")
  })

  it("trims whitespace from raw input", {
    tag <- make_tag("  mri_convert  ")
    result <- roxy_tag_parse(tag)
    expect_equal(result$val$func_name, "mri_convert")
  })
})

describe("format.rd_section_fsHelp", {
  make_section <- function(func_name, help_arg = "--help", bin_app = "bin") {
    structure(
      list(value = list(
        func_name = func_name,
        help_arg = help_arg,
        bin_app = bin_app
      )),
      class = "rd_section_fsHelp"
    )
  }

  it("generates Sexpr with default args", {
    section <- make_section("mri_convert")
    result <- format(section)
    expect_match(result, "FreeSurfer CLI Help")
    expect_match(result, 'freesurfer::fs_help_rd\\("mri_convert"')
    expect_match(result, '"--help"')
    expect_match(result, '"bin"')
    expect_match(result, "Sexpr\\[results=rd,stage=render\\]")
  })

  it("generates Sexpr with custom args", {
    section <- make_section("nu_correct", "-help", "mni/bin")
    result <- format(section)
    expect_match(result, 'freesurfer::fs_help_rd\\("nu_correct"')
    expect_match(result, '"-help"')
    expect_match(result, '"mni/bin"')
  })

  it("generates Sexpr for trac-all", {
    section <- make_section("trac-all")
    result <- format(section)
    expect_match(result, 'freesurfer::fs_help_rd\\("trac-all"')
  })
})
