#' Interpolate geodesically between bases.
#' 
#' This function takes a set of bases and produces a tour by geodesically 
#' interpolating between each basis
#' 
#' @param basis_set input basis set
#' @param angle target distance (in radians) between bases
#' @keywords hplot
#' @examples
#' t1 <- save_history(flea[, 1:6], grand_tour(1), max = 10)
#' dim(t1)
#' dim(interpolate(t1, 0.01))
#' dim(interpolate(t1, 0.05))
#' dim(interpolate(t1, 0.1))
interpolate <- function(basis_set, angle = 0.05) {
  basis_set <- as.list(basis_set)

  n <- length(basis_set)
  if (n < 2) return(basis_set)

  output <- list(basis_set[[1]])
  new_basis <- c(TRUE)
  
  get_basis <- function(i) basis_set[[i]]
  path <- geodesic_path(get_basis(1), get_basis(2))
  dist <- sqrt(sum(path$tau ^ 2))

  i <- 2
  step <- 2
  nsteps <- ceiling(dist / angle)

  while(i < n | step < nsteps) {
    proj <- path$interpolate(step / nsteps)
    output <- append(output, list(proj))
    new_basis <- append(new_basis, step == 1)

    if (step == nsteps) {
      i <- i + 1
      path <- geodesic_path(proj, get_basis(i))
      dist <- sqrt(sum(path$tau ^ 2))

      step <- 0
      nsteps <- ceiling(dist / angle)
    }
    step <- step + 1
  }  
  
  oarray <- unlist(output)
  dim(oarray) <- c(nrow(output[[1]]), ncol(output[[2]]), length(output))
  attr(oarray, "data") <- attr(basis_set, "data")
  attr(oarray, "new_basis") <- new_basis
  class(oarray) <- c("history_array", class(oarray))
  oarray
}