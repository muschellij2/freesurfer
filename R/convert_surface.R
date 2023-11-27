#' @title Convert Freesurfer Surface
#' @description Reads in a surface file from Freesurfer and separates
#' into vertices and faces
#' 
#' @param infile Input surface file
#' @param ... additional arguments to pass to 
#' \code{\link{mris_convert}}
#'
#' @return List of 3 elements: a header indicating the number of 
#' vertices and faces, the vertices, and the faces
#' @export
#'
#' @note This was adapted from the gist: 
#' \url{https://gist.github.com/mm--/4a4fc7badacfad874102}
#' @examples 
#' if (have_fs()) {
#' infile = file.path(fs_subj_dir(), 
#'                    "bert", "surf", "rh.pial")
#' res = convert_surface(infile = infile)
#' }
convert_surface = function(infile, ...) {
  
  ########
  # adapted from
  # https://gist.github.com/mm--/4a4fc7badacfad874102
  ##########
  file = mris_convert(infile = infile, ...)
  lines = readLines(file)
  ## Read in lines, filtering out comments
  lines <- grep("^(#.*)?$", lines, 
                value = TRUE, invert = TRUE)
  
  ## Get the number of vertices and the number of faces
  infos <- as.numeric(unlist(strsplit(lines[1], " ")))
  ## Skip header
  splits <- split(lines, 
                  rep(c("header", "vertices", "faces"), 
                             times = c(1, infos)))
  
  
  ## Strings to 3 column numeric matrix
  str_to_matrix <- function(strings) {
    strings = strsplit(strings, split = " +")
    strings = lapply(strings, as.numeric)
    strings = do.call("rbind", strings)
    strings = strings[, 1:3]
    return(strings)
  }  
  ## Convert vertices and faces
  # verts <- str_to_matrix(splits$Vertices)
  splits$vertices = str_to_matrix(splits$vertices)
  #Faces have to start at 1
  splits$faces = str_to_matrix(splits$faces) + 1 
  
  return(splits)
}

#' @title Convert Freesurfer Surface to Triangles
#' @description Reads in a surface file from Freesurfer and 
#' converts it into triangles 
#' 
#' @param infile Input surface file
#' @param ... additional arguments to pass to 
#' \code{\link{convert_surface}}
#'
#' @return Matrix of triangles with the number of rows equal
#' to the number of faces (not the triplets - total faces)
#' @export
#'
#' @examples 
#' if (have_fs()) {
#' infile = file.path(fs_subj_dir(), 
#'                    "bert", "surf", "rh.pial")
#' right_triangles = surface_to_triangles(infile = infile)
#' infile = file.path(fs_subj_dir(), 
#'                    "bert", "surf", "lh.pial")
#' left_triangles = surface_to_triangles(infile = infile) 
#' if (requireNamespace("rgl", quietly = TRUE)) {
#'   rgl::open3d()
#'   rgl::triangles3d(right_triangles, 
#'   color = rainbow(nrow(right_triangles)))
#'   rgl::triangles3d(left_triangles, 
#'   color = rainbow(nrow(left_triangles)))
#' }
#' infile = file.path(fs_subj_dir(), 
#'                    "bert", "surf", "rh.inflated")
#' right_triangles = surface_to_triangles(infile = infile)  
#' infile = file.path(fs_subj_dir(), 
#'                    "bert", "surf", "lh.inflated") 
#' left_triangles = surface_to_triangles(infile = infile)  
#' if (requireNamespace("rgl", quietly = TRUE)) {
#'   rgl::open3d()
#'   rgl::triangles3d(left_triangles, 
#'   color = rainbow(nrow(left_triangles)))
#'   rgl::triangles3d(right_triangles, 
#'   color = rainbow(nrow(right_triangles)))   
#' } 
#' }
surface_to_triangles = function(infile, ...) {
  splits = convert_surface(infile, ...)
  
  faces = as.vector(t(splits$faces))
  triangles <- splits$vertices[faces,]
  return(triangles)
}


#' @title Convert Freesurfer Surface to Wavefront OBJ
#' @description Reads in a surface file from Freesurfer and converts it
#' to a Wavefront OBJ file
#' 
#' @param infile Input surface file
#' @param outfile output Wavefront OBJ file.  If \code{NULL}, 
#' a temporary file will be created
#' @param ... additional arguments to pass to 
#' \code{\link{convert_surface}}
#'
#' @return Character filename of output file
#' @export
#'
#' @examples 
#' if (have_fs()) {
#' infile = file.path(fs_subj_dir(), 
#'                    "bert", "surf", "rh.pial")
#' res = surface_to_obj(infile = infile)
#' }
surface_to_obj = function(infile, outfile = NULL, ...) {
  splits = convert_surface(infile, ...)
  
  if (is.null(outfile)) {
    outfile = tempfile(fileext = ".obj")
  }
  scipen = getOption("scipen")
  on.exit({
    options(scipen = scipen)
  })
  # ## You can't have scientific notation in .obj files
  options(scipen = 999)
  vertLines <- paste("v", 
                     splits$vertices[,1], 
                     splits$vertices[,2], 
                     splits$vertices[,3])
  faceLines <- paste("f", 
                     splits$faces[,1], 
                     splits$faces[,2], 
                     splits$faces[,3])

  writeLines(c(vertLines, faceLines), con = outfile)
  return(outfile)
}
