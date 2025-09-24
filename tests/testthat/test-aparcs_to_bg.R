# test_that("aparcs_to_bg handles basic functionality correctly", {
#   # Mocking necessary external dependencies
#   mock_aparcstats2table <- function(subjects, measure, ...) {
#     tmp <- withr::local_tempfile(fileext = ".csv")
#     write.csv(
#       data.frame(
#         subject_id = c("subj1", "subj2"),
#         lh_thickness = c(1.5, 1.8),
#         rh_thickness = c(2.5, 2.8)
#       ),
#       file = tmp,
#       row.names = FALSE
#     )
#     tmp
#   }

#   local_mocked_bindings(
#     aparcstats2table = mock_aparcstats2table,
#     read_fs_table = function(file) {
#       read.csv(file)
#     }
#   )

#   # Tests for successful transformation
#   result <- aparcs_to_bg(subjects = c("subj1", "subj2"), measure = "thickness")
#   expect_is(result, "data.frame")
#   expect_equal(
#     colnames(result),
#     c("id", "name", "thickness")
#   )
#   expect_equal(nrow(result), 4) # Derived from reshaped data

#   # Testing variable renaming and reshaping
#   expect_identical(
#     unique(result$name),
#     c("l_thickness", "r_thickness")
#   )
# })

# test_that("aparcs_to_bg handles empty data correctly", {
#   # Mock for empty data
#   mock_aparcstats2table <- function(subjects, measure, ...) {
#     tempfile <- withr::local_tempfile(fileext = ".csv")
#     write.csv(data.frame(), tempfile, row.names = FALSE)
#     tempfile
#   }

#   local_mocked_bindings(
#     aparcstats2table = mock_aparcstats2table
#   )

#   expect_warning(
#     result <- aparcs_to_bg(subjects = NULL, measure = "thickness"),
#     "Empty data"
#   )
#   expect_equal(nrow(result), 0)
#   expect_equal(ncol(result), 0)
# })

# test_that("aparcs_to_bg handles invalid files gracefully", {
#   mock_aparcstats2table <- function(subjects, measure, ...) {
#     withr::local_tempfile(fileext = ".csv")
#   }

#   local_mocked_bindings(
#     aparcstats2table = mock_aparcstats2table
#   )

#   expect_error(
#     aparcs_to_bg(subjects = "test", measure = "invalid"),
#     "Error in `read_fs_table`"
#   )
# })

# test_that("aparcs_to_bg handles edge cases", {
#   # Mock for edge cases
#   mock_aparcstats2table <- function(subjects, measure, ...) {
#     tempfile <- withr::local_tempfile(fileext = ".csv")
#     write.csv(
#       data.frame(
#         subject_id = c("subj1"),
#         column_with_div = c(1.5),
#         lh_meanThickness = c(2.0)
#       ),
#       tempfile,
#       row.names = FALSE
#     )
#     tempfile
#   }

#   mock_read_fs_table <- function(file) {
#     read.csv(file)
#   }

#   local_mocked_bindings(
#     aparcstats2table = mock_aparcstats2table,
#     read_fs_table = mock_read_fs_table
#   )

#   result <- aparcs_to_bg(subjects = "subj1", measure = "thickness")
#   expect_equal(
#     unique(result$name),
#     c("column_with", "l_meanThickness")
#   )
#   expect_false(any(grepl("div", result$name))) # Ensure `_div` is removed
# })

# test_that("aparcs_to_bg handles additional arguments", {
#   # Mock the additional arguments scenario
#   mock_aparcstats2table <- function(subjects, measure, ...) {
#     args <- list(...)
#     expect_true("arg1" %in% names(args))
#     tempfile <- withr::local_tempfile(fileext = ".csv")
#     write.csv(
#       data.frame(
#         subject_id = c("subj1", "subj2"),
#         lh_thickness = c(1.5, 1.8),
#         rh_thickness = c(2.5, 2.8)
#       ),
#       tempfile,
#       row.names = FALSE
#     )
#     tempfile
#   }

#   local_mocked_bindings(
#     aparcstats2table = mock_aparcstats2table
#   )

#   result <- aparcs_to_bg(
#     subjects = c("subj1", "subj2"),
#     measure = "thickness",
#     arg1 = "value"
#   )
#   expect_is(result, "data.frame")
#   expect_equal(nrow(result), 4)
# })
