read_lut = function() {
  lut_file = file.path(fs_dir(), "FreeSurferColorLUT.txt")
  lut = readLines(lut_file)
  lut = grep("^(#.*)?$", lut, value = TRUE, invert = TRUE)
  lut = lut[!(lut %in% "")]

  str_to_matrix <- function(strings) {
    strings = strsplit(strings, split = " +")
    strings = do.call("rbind", strings)
    return(strings)
  }

  mat = str_to_matrix(lut)
  colnames(mat) = c("index", "label", "R", "G", "B", "A")
  mat = data.frame(mat, stringsAsFactors = FALSE)
  mat$index = as.numeric(mat$index)
  mat$R = as.numeric(mat$R)
  mat$G = as.numeric(mat$G)
  mat$B = as.numeric(mat$B)
  mat$A = as.numeric(mat$A)

  mat <- dplyr::arrange(mat, index)
  stopifnot(!any(duplicated(mat$index)))
  return(mat)
}

fs_lut = read_lut()

usethis::use_data(fs_lut, overwrite = TRUE)
