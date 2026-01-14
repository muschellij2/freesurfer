test_that("convert_surface handles valid input correctly", {
  # Mock mris_convert to return a temporary file with surface data
  mock_file <- withr::local_tempfile()
  writeLines(
    c(
      "# header comment",
      "3 2",
      "0.1 0.2 0.3",
      "0.4 0.5 0.6",
      "0.7 0.8 0.9",
      "1 2 3",
      "3 2 1"
    ),
    mock_file
  )

  local_mocked_bindings(
    mris_convert = function(infile, ...) mock_file
  )

  result <- convert_surface("dummy_input")

  expect_equal(
    result$vertices,
    matrix(
      seq(0.1, 0.9, by = 0.1),
      ncol = 3,
      byrow = TRUE
    )
  )

  expect_equal(
    result$faces,
    matrix(
      c(2, 3, 4, 4, 3, 2),
      ncol = 3,
      byrow = TRUE
    )
  )
})

test_that("convert_surface handles invalid files gracefully", {
  # Mock mris_convert to return a temporary file with invalid data
  mock_file <- withr::local_tempfile()
  writeLines(
    c(
      "# Invalid header",
      "NaN"
    ),
    mock_file
  )

  local_mocked_bindings(
    mris_convert = function(infile, ...) mock_file,
    get_fs_license = mock_get_license
  )
  expect_error(
    convert_surface("dummy_input"),
    "Invalid header in"
  )
})

test_that("surface_to_triangles converts surface to triangles correctly", {
  # Mock convert_surface to return a predefined object
  mock_split <- list(
    vertices = matrix(
      c(
        0.1,
        0.2,
        0.3,
        0.4,
        0.5,
        0.6,
        0.7,
        0.8,
        0.9
      ),
      ncol = 3,
      byrow = TRUE
    ),
    faces = matrix(
      c(
        1,
        2,
        3
      ),
      ncol = 3,
      byrow = TRUE
    )
  )

  local_mocked_bindings(
    convert_surface = function(infile, ...) mock_split
  )
  triangles <- surface_to_triangles("dummy_input")

  expect_equal(
    triangles,
    matrix(
      c(
        0.1,
        0.2,
        0.3,
        0.4,
        0.5,
        0.6,
        0.7,
        0.8,
        0.9
      ),
      ncol = 3,
      byrow = TRUE
    )
  )
})

test_that("surface_to_obj creates Wavefront OBJ file", {
  mock_split <- list(
    vertices = matrix(
      c(
        0.1,
        0.2,
        0.3,
        0.4,
        0.5,
        0.6,
        0.7,
        0.8,
        0.9
      ),
      ncol = 3,
      byrow = TRUE
    ),
    faces = matrix(
      c(
        1,
        2,
        3
      ),
      ncol = 3,
      byrow = TRUE
    )
  )

  local_mocked_bindings(
    convert_surface = function(infile, ...) mock_split
  )
  # Test with user-defined output file
  outfile <- withr::local_tempfile()
  result <- surface_to_obj("dummy_input", outfile)

  expect_equal(result, outfile)
  content <- readLines(outfile)
  expect_true("v 0.1 0.2 0.3" %in% content)
  expect_true("v 0.4 0.5 0.6" %in% content)
  expect_true("v 0.7 0.8 0.9" %in% content)
  expect_true("f 1 2 3" %in% content)

  # Test with default (temporary) output file
  temp_result <- surface_to_obj("dummy_input")
  expect_true(file.exists(temp_result))
})

skip_if_no_freesurfer()

test_that("convert_surface works with actual FreeSurfer", {
  lh_pial_file <- file.path(
    fs_subj_dir(),
    "bert",
    "surf",
    "lh.pial"
  )

  expect_message(
    result <- convert_surface(lh_pial_file),
    "mris_convert"
  )

  expect_true(is.matrix(result$vertices))
  expect_true(is.matrix(result$faces))
  expect_equal(ncol(result$vertices), 3)
  expect_equal(ncol(result$faces), 3)
})
