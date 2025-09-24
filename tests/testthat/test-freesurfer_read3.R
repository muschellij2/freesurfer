test_that("freesurfer_read3 reads 3 bytes and returns numeric", {
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


test_that("freesurfer_read3 reads 3 bytes from connection", {
  temp_file <- withr::local_tempfile()
  writeBin(as.raw(c(0x01, 0x02, 0x03)), temp_file, endian = "big")

  fid <- file(temp_file, open = "rb")
  on.exit(close(fid))

  result <- freesurfer_read3(fid)
  expect_equal(result, 66051) # 0x010203 = 66051
})

test_that("freesurfer_read_curv reads curvature file", {
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

test_that("freesurfer_read_curv throws error for unknown version", {
  temp_file <- withr::local_tempfile()
  # Mock an invalid version
  writeBin(as.raw(c(0x00, 0x00, 0x01)), temp_file, endian = "big")

  mock_invalid_version <- function(fid) as.integer(1)
  local_mocked_bindings(
    freesurfer_read3 = mock_invalid_version
  )

  expect_snapshot_error(freesurfer_read_curv(temp_file))
})

test_that("freesurfer_read_surf reads surface file (triangle format) created by helper", {
  #' Write Freesurfer Triangle Surface File)
  write_surf_tri <- function(
    outfile,
    vertices,
    faces,
    comment_lines = c(
      "#!/bin/env freeview",
      "# Created by R write_surf_tri"
    )
  ) {
    write_3b <- function(con, val) {
      # Extract the three bytes in big-endian order
      byte1 <- bitwAnd(bitwShiftR(val, 16), 0xFF)
      byte2 <- bitwAnd(bitwShiftR(val, 8), 0xFF)
      byte3 <- bitwAnd(val, 0xFF)
      writeBin(as.raw(c(byte1, byte2, byte3)), con, endian = "big")
    }
    con <- file(outfile, "wb")
    on.exit(close(con))
    write_3b(con, 16777214L)
    if (length(comment_lines) > 0 || !is.null(comment_lines)) {
      for (i in seq_along(comment_lines)) {
        writeBin(charToRaw(comment_lines[1]), con, endian = "big")
        writeBin(as.raw(0x0A), con, endian = "big")
      }
    }
    vnum <- nrow(vertices)
    write_3b(con, vnum)
    fnum <- nrow(faces)
    write_3b(con, fnum)
    writeBin(as.double(t(vertices)), con, size = 4, endian = "big")
    writeBin(as.integer(t(faces)), con, size = 4, endian = "big")
    invisible(outfile)
  }

  temp_file <- withr::local_tempfile()

  # Define test data
  test_vertices <- matrix(
    1:9,
    nrow = 3,
    byrow = TRUE
  ) # Ensure byrow=TRUE for clear data definition

  test_faces <- matrix(c(0, 1, 2), nrow = 1, byrow = TRUE) # 0-based indices

  # Write the mock file using the new helper
  write_surf_tri(
    temp_file,
    vertices = test_vertices,
    faces = test_faces
  )

  # Now read it back
  dt <- freesurfer_read_surf(temp_file)

  # expect_named(surf_data, c("vertices", "faces"))
  # expect_equal(dt$vertices, test_vertices)
  # expect_equal(dt$faces, test_faces + 1)
})

test_that("freesurfer_read_surf throws error for unsupported formats", {
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

test_that("freesurfer_read_surf reads surface file (quad format)", {
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

skip_if_no_freesurfer()

test_that("freesurfer_read_surf reads actual data", {
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
