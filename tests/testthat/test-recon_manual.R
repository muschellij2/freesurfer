test_that("recon_con1 passes correct options to reconner", {
  local_mocked_bindings(
    check_path = function(...) TRUE,
    reconner = function(infile, outdir, subjid, verbose, opts) {
      list(
        infile = infile,
        outdir = outdir,
        subjid = subjid,
        verbose = verbose,
        opts = opts
      )
    }
  )

  result <- recon_con1(
    infile = "input.nii",
    outdir = "/output_dir",
    subjid = "subj01",
    verbose = TRUE
  )

  expect_equal(result$opts, "-autorecon1")
  expect_equal(result$infile, "input.nii")
  expect_equal(result$outdir, "/output_dir")
  expect_equal(result$subjid, "subj01")
  expect_equal(result$verbose, TRUE)

  expect_equal(recon_con1, autorecon1)
})


test_that("recon_con2 passes correct options to reconner", {
  local_mocked_bindings(
    reconner = function(infile, outdir, subjid, verbose, opts) {
      list(
        infile = infile,
        outdir = outdir,
        subjid = subjid,
        verbose = verbose,
        opts = opts
      )
    }
  )

  result <- recon_con2(
    infile = "input.nii",
    outdir = "/output_dir",
    subjid = "subj02",
    verbose = TRUE
  )

  expect_equal(result$opts, "-autorecon2")
  expect_equal(result$infile, "input.nii")
  expect_equal(result$outdir, "/output_dir")
  expect_equal(result$subjid, "subj02")
  expect_equal(result$verbose, TRUE)

  expect_equal(recon_con2, autorecon2)
})


test_that("recon_con3 passes correct options to reconner", {
  local_mocked_bindings(
    reconner = function(infile, outdir, subjid, verbose, opts) {
      list(
        infile = infile,
        outdir = outdir,
        subjid = subjid,
        verbose = verbose,
        opts = opts
      )
    }
  )

  result <- recon_con3(
    infile = "input.nii",
    outdir = "/output_dir",
    subjid = "subj03",
    verbose = TRUE
  )

  expect_equal(result$opts, "-autorecon3")
  expect_equal(result$infile, "input.nii")
  expect_equal(result$outdir, "/output_dir")
  expect_equal(result$subjid, "subj03")
  expect_equal(result$verbose, TRUE)

  expect_equal(recon_con3, autorecon3)
})

test_that("Error is thrown if check_path fails in recon_con1", {
  local_mocked_bindings(
    check_path = function(filepath) stop("Invalid path!")
  )

  expect_error(
    recon_con1(
      infile = "invalid.nii",
      outdir = "/output_dir",
      subjid = "subj01"
    ),
    "Invalid path!"
  )
})
