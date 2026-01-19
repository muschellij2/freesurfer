describe("freesurfer_read3", {
  it("reads 3 bytes and returns numeric", {
    temp_file <- withr::local_tempfile()

    # Write 5 bytes of big-endian data
    writeBin(
      as.raw(c(0x00, 0x01, 0x02, 0x03, 0x05)),
      temp_file,
      endian = "big"
    )

    result <- freesurfer_read3(temp_file)
    expect_equal(result, 258) # 0x000102 = 258
  })

  it("reads 3 bytes from connection", {
    temp_file <- withr::local_tempfile()
    writeBin(as.raw(c(0x01, 0x02, 0x03)), temp_file, endian = "big")

    fid <- file(temp_file, open = "rb")
    on.exit(close(fid))

    result <- freesurfer_read3(fid)
    expect_equal(result, 66051) # 0x010203 = 66051
  })

  it("reads curvature file", {
    temp_file <- withr::local_tempfile()

    # Mock curvature file with a valid version
    writeBin(
      c(
        as.raw(c(0xFF, 0xFF, 0xFF)), # Magic number (16777215)
        as.integer(100), # vnum
        as.integer(200), # fnum
        as.integer(300), # vals_per_vertex
        rep(as.numeric(1.23), 100)
      ), # curvature values
      temp_file,
      endian = "big",
      useBytes = TRUE
    )

    local_mocked_bindings(
      freesurfer_read3 = function(fid) as.integer(16777215)
    )

    expect_no_error({
      curv_data <- freesurfer_read_curv(temp_file)
      expect_length(curv_data, 209)
    })
  })

  it("throws error for unknown version", {
    temp_file <- withr::local_tempfile()
    # Mock an invalid version
    writeBin(as.raw(c(0x00, 0x00, 0x01)), temp_file, endian = "big")

    mock_invalid_version <- function(fid) as.integer(1)
    local_mocked_bindings(
      freesurfer_read3 = mock_invalid_version
    )

    expect_snapshot_error(freesurfer_read_curv(temp_file))
  })

  it("throws error for unsupported formats", {
    temp_file <- withr::local_tempfile()

    # Write unsupported magic number
    writeBin(as.raw(c(0x00, 0x00, 0x01)), temp_file, endian = "big")

    local_mocked_bindings(
      freesurfer_read3 = function(fid) as.integer(1)
    )

    expect_error(
      freesurfer_read_surf(temp_file),
      "Unknown vertex shape"
    )
  })

  it("reads surface file (quad format)", {
    temp_file <- withr::local_tempfile()

    # Mock quad file format
    writeBin(
      c(
        as.integer(16777215), # Magic number (quad format)
        as.integer(3), # vnum
        as.integer(2), # fnum
        c(as.integer(1:12))
      ), # Dual quad faces
      temp_file,
      endian = "big",
      useBytes = TRUE
    )

    int <- 16777215L
    local_mocked_bindings(
      freesurfer_read3 = function(fid) int
    )

    expect_no_error({
      quad_data <- freesurfer_read_surf(temp_file)
      expect_equal(quad_data$faces[1, 1], int)
    })
  })

  it("reads actual data", {
    skip_if_no_freesurfer()

    fp <- file.path(fs_subj_dir(), "bert", "surf", "lh.inflated")

    expect_message(
      surf_data_fs <- freesurfer_read_surf(fp),
      "created by ah221"
    )
    expect_named(surf_data_fs, c("vertices", "faces"))
    expect_equal(
      dim(surf_data_fs$vertices),
      c(134814, 3)
    )
    expect_equal(
      dim(surf_data_fs$faces),
      c(269624, 3)
    )
  })
})
