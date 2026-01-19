describe("aparcs_to_bg", {
  it("handles basic functionality correctly", {
    local_mocked_bindings(
      aparcstats2table = function(...) {},
      read_fs_table = function(file, ...) {
        subjects <- c("subj1", "subj2")

        data.frame(
          subject_id = subjects,
          lh_lingual = rnorm(length(subjects), mean = 2, sd = 0.1),
          rh_lingual = rnorm(length(subjects), mean = 1, sd = 0.4),
          Accumbens.area = rnorm(length(subjects), mean = 0.5, sd = 0.05)
        )
      }
    )

    # Tests for successful transformation
    result <- aparcs_to_bg(
      subjects = c("subj1", "subj2"),
      measure = "thickness"
    )
    expect_s3_class(result, "data.frame")
    expect_equal(
      colnames(result),
      c("id", "name", "thickness")
    )
    expect_equal(nrow(result), 6)

    # Testing variable renaming and reshaping
    expect_identical(
      unique(result$name),
      c("ACCU", "lLING", "rLING")
    )

    result2 <- aparcs_to_bg(
      subjects = c("subj1", "subj2"),
      measure = "thickness",
      clean_col_names = FALSE
    )
    expect_identical(
      unique(result2$name),
      c("Accumbens.area", "lh_lingual", "rh_lingual")
    )
  })

  it("handles invalid files gracefully", {
    local_mocked_bindings(
      aparcstats2table = function(subjects, measure, ...) {
        withr::local_tempfile(fileext = ".csv")
      }
    )

    expect_error(
      aparcs_to_bg(subjects = "test", measure = "invalid"),
      "File does not exist"
    )
  })

  it("works with actual FreeSurfer data", {
    skip_if_no_freesurfer()

    withr::local_envvar(FREESURFER_VERBOSE = "FALSE")
    result <- aparcs_to_bg(subjects = "bert", measure = "thickness")

    expect_s3_class(result, "data.frame")
    expect_true(all(c("id", "name", "thickness") %in% colnames(result)))
    expect_true(nrow(result) == 36)
    expect_true(all(result$id == "bert"))
  })
})
