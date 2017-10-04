## helpers.R

exampleHist <- function( n ){
  
  set.seed(123)
  x <- rnorm( n )
  hist( x )
  
}