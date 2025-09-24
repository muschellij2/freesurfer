test_that("creates correct directory structure and copies files", {
  subj_root_dir <- withr::local_tempdir()

  label_file <- withr::local_tempfile(
    fileext = ".txt",
    tmpdir = subj_root_dir
  )
  mri_files <- c(
    withr::local_tempfile(
      fileext = ".mgz",
      tmpdir = subj_root_dir
    ),
    withr::local_tempfile(
      fileext = ".mgz",
      tmpdir = subj_root_dir
    )
  )
  stats_files <- c(
    withr::local_tempfile(
      fileext = ".stats",
      tmpdir = subj_root_dir
    ),
    withr::local_tempfile(
      fileext = ".stats",
      tmpdir = subj_root_dir
    )
  )
  surf_file <- withr::local_tempfile(
    fileext = ".surf",
    tmpdir = subj_root_dir
  )

  # A dummy_content to make files valid before copying
  writeLines("dummy_content", label_file)
  lapply(mri_files, function(f) writeLines("dummy_content", f))
  lapply(stats_files, function(f) writeLines("dummy_content", f))
  writeLines("dummy_content", surf_file)

  # Run function
  result <- construct_subj_dir(
    label = label_file,
    mri = mri_files,
    stats = stats_files,
    surf = surf_file,
    subj = "test_subj",
    subj_root_dir = subj_root_dir
  )

  expect_named(result, c("subj", "subj_dir", "types"))
  expect_equal(result$subj, "test_subj")

  expect_equal(result$subj_dir, subj_root_dir)

  expect_setequal(result$types, c("label", "mri", "stats", "surf"))

  # Assertions: Check directory existence within the created subject directory
  expected_subdirs_within_subj <- file.path(
    file.path(subj_root_dir, "test_subj"),
    c("label", "mri", "stats", "surf")
  )
  expect_true(all(file.exists(expected_subdirs_within_subj)))

  # Assertions: Check files copied correctly into their respective subdirectories
  expect_true(file.exists(file.path(
    expected_subdirs_within_subj[1],
    basename(label_file)
  )))
  expect_true(all(file.exists(file.path(
    expected_subdirs_within_subj[2],
    basename(mri_files)
  ))))
  expect_true(all(file.exists(file.path(
    expected_subdirs_within_subj[3],
    basename(stats_files)
  ))))
  expect_true(file.exists(file.path(
    expected_subdirs_within_subj[4],
    basename(surf_file)
  )))
})

test_that("handles NULL parameters gracefully", {
  subj_root_dir <- tempdir()

  # Run function with NULL parameters
  result <- construct_subj_dir(
    label = NULL,
    mri = NULL,
    stats = NULL,
    surf = NULL,
    touch = NULL,
    subj = "test_null_params",
    subj_root_dir = subj_root_dir
  )

  # Assertions: Check output structure
  expect_named(result, c("subj", "subj_dir", "types"))
  expect_equal(result$subj, "test_null_params")
  expect_equal(result$types, character(0))

  # Assertions: Check directory created and empty
  subject_dir <- file.path(subj_root_dir, result$subj)
  expect_true(dir.exists(subject_dir))
  expect_length(list.files(subject_dir, recursive = TRUE), 0)

  # Teardown: Clean up temporary files
  unlink(subj_root_dir, recursive = TRUE)
})

test_that("generates temporary ID if subj is NULL", {
  subj_root_dir <- tempdir()

  # Run function without specifying `subj`
  result <- construct_subj_dir(
    label = NULL,
    mri = NULL,
    stats = NULL,
    surf = NULL,
    touch = NULL,
    subj_root_dir = subj_root_dir
  )

  # Assertions: Generated `subj` should be a string resembling a temporary ID
  expect_type(result$subj, "character")
  expect_true(startsWith(result$subj, "file"))
  expect_true(dir.exists(file.path(subj_root_dir, result$subj)))

  # Teardown: Clean up temporary files
  unlink(subj_root_dir, recursive = TRUE)
})

test_that("stops on missing files", {
  subj_root_dir <- tempdir()

  # Provide a non-existent file
  nonexistent_file <- file.path(subj_root_dir, "fake_file.txt")

  # Expect error with message containing the non-existent file
  expect_error(
    construct_subj_dir(
      label = nonexistent_file,
      subj = "test_nonexistent",
      subj_root_dir = subj_root_dir
    )
  )
})

test_that("creates partial folders when some parameters are NULL", {
  subj_root_dir <- tempdir()
  mri_file <- tempfile(fileext = ".mgz", tmpdir = subj_root_dir)
  stats_file <- tempfile(fileext = ".stats", tmpdir = subj_root_dir)
  writeLines("dummy_content", mri_file)
  writeLines("dummy_content", stats_file)

  # Run function with some NULL parameters
  result <- construct_subj_dir(
    label = NULL,
    mri = mri_file,
    stats = stats_file,
    surf = NULL,
    subj = "partial_test",
    subj_root_dir = subj_root_dir
  )

  # Assertions: Check directories and files
  created_dirs <- file.path(subj_root_dir, result$subj, c("mri", "stats"))
  expect_true(all(file.exists(created_dirs))) # Only "mri" and "stats" created

  expect_true(file.exists(file.path(created_dirs[1], basename(mri_file))))
  expect_true(file.exists(file.path(created_dirs[2], basename(stats_file))))

  # Teardown: Clean up temporary files
  unlink(subj_root_dir, recursive = TRUE)
})
