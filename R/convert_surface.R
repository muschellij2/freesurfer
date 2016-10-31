#' @title Convert Freesurfer Surface
#' @description Reads in a surface file from Freesurfer which allows
#' for coloring
#' 
#' @param infile Input surface file
#' @param ... additional arguments to pass to 
#' \code{\link{mris_convert}}
#'
#' @return List of 3 elements: a header indicating the number of 
#' vertices and faces, the vertices, and the faces
#' @export
#'
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
                             times=c(1, infos)))
  
  
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


#' @title Plots Freesurfer Surface in 3D
#' @description Reads in a surface file from Freesurfer which allows
#' for coloring
#' 
#' @param infile Input surface file
#' @param ... additional arguments to pass to 
#' \code{\link{mris_convert}}
#'
#' @return List of 3 elements: a header indicating the number of 
#' vertices and faces, the vertices, and the faces
#' @export
#'
#' @importFrom rgl rgl.open rgl.triangles
#' @examples 
#' if (have_fs()) {
#' infile = file.path(fs_subj_dir(), 
#'                    "bert", "surf", "rh.pial")
#' res = convert_surface(infile = infile)
#' }
plot3d_surface = function(infile, ...) {
  
  splits = convert_surface(infile)
  
  faces = as.vector(t(splits$faces))
  triangles <- splits$vertices[faces,]

  rgl.open()
  scene = rgl.triangles(triangles, ...)
  
  return(scene)
}



# 
# faces <- str_to_matrix(splits$Faces) + 1      
# 
# ## Get a list of all triangles
# triangles <- verts[as.vector(t(faces)),]
# 
# rgl.open()
# rgl.triangles(triangles, color = rainbow(nrow(triangles)))
# play3d(spin3d(axis=c(1,0,0), rpm=60/3), duration=3)
# play3d(spin3d(axis=c(0,0,-1), rpm=60/3), duration=3)
# 
# ## You can't have scientific notation in .obj files
# options(scipen=999)
# vertLines <- paste("v", verts[,1], verts[,2], verts[,3])
# faceLines <- paste("f", faces[,1], faces[,2], faces[,3])
# 
# fileConn <- file(paste0(file, ".obj"))
# writeLines(c(vertLines, faceLines), fileConn)
# close(fileConn)