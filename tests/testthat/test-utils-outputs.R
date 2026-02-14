describe("utils-outputs", {
  it("errors with the main message", {
    expect_error(fs_abort("something went wrong"), "something went wrong")
  })

  it("includes FreeSurfer command when provided", {
    expect_error(
      fs_abort("failed", cmd = "recon-all"),
      "FreeSurfer command: recon-all"
    )
  })

  it("includes details when provided", {
    expect_error(fs_abort("failed", details = "extra info"), "extra info")
  })

  it("includes both command and details when provided", {
    # each expect_error re-runs the call; check for command and details separately
    expect_error(
      fs_abort("failed", cmd = "recon-all", details = "extra info"),
      "FreeSurfer command: recon-all"
    )
    expect_error(
      fs_abort("failed", cmd = "recon-all", details = "extra info"),
      "extra info"
    )
  })

  it("warns with the main message", {
    expect_warning(fs_warn("be careful"), "be careful")
  })

  it("includes Command: when cmd provided", {
    expect_warning(
      fs_warn("warning", cmd = "mri_convert"),
      "Command: mri_convert"
    )
  })

  it("includes details when provided", {
    expect_warning(
      fs_warn("warning", details = "additional detail"),
      "additional detail"
    )
  })

  it("accepts ... and still warns", {
    # pass an extra named argument through ... to ensure no error is raised
    expect_warning(fs_warn("ok", foo = "bar"), "ok")
  })

  it("messages with the main message", {
    expect_message(fs_inform("informational text"), "informational text")
  })

  it("includes details when provided", {
    expect_message(fs_inform("info", details = "more info"), "more info")
  })

  it("accepts ... and still messages", {
    expect_message(fs_inform("info", extra = TRUE), "info")
  })
})
