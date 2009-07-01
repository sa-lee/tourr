#' The little tour.
#'
#' The little tour is a planned tour that travels between all axis parallel
#' projections.
#'
#' Usually, you will not call this function directly, but will pass it to 
#' a method that works with tour paths like \code{\link{save_history}}, 
#' or \code{\link{animate}}
#' 
#' @param d target dimensionality
#' @examples
#' animate_xy(flea[, 1:6], little_tour())
#' animate_pcp(flea[, 1:6], little_tour(3))
#' animate_scatmat(flea[, 1:6], little_tour(3))
#' animate_pcp(flea[, 1:6], little_tour(4))
little_tour <- function(d = 2) {
  little <- NULL
  step <- 0
  
  generator <- function(current, data) {
    if (is.null(little)) {
      # Initialise bases
      little <<- bases_little(ncol(data), d)
    }
    step <<- (step %% length(little)) + 1
    little[[step]]
  }
  
  new_tour_path("little", generator)
}

#' Generate bases for the little tour
#'
#' @keywords internal
#' @param n dimensionality of data
#' @param d dimensionality of target projection
bases_little <- function(p, d = 2) {
  b <- diag(rep(1, p))
  vars <- combn(p, d)
  lapply(seq_len(ncol(vars)), function(i) b[, vars[, i]] )
}
