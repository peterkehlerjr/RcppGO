library(RcppGO)

AluffiPentiny01 <- function(X)
{
  1/4*X^4 - 1/2*X^2 + 1/10*X + 1/2*X^2
}

Example01Output <- RcppGO(ObjectiveFunction=AluffiPentiny01, Args=1, Lower = -10, Upper = 10)


str(Example01Output)

Example01Output$GMemory


# constrained example
  AluffiPentiny01a <- function (X)
  {
    if (X^2 + X < 3) return (Inf)
    else return(1/ 4*X ^4 - 1/2 *X ^2 + 1/ 10 *X + 1/ 2*X ^2)    
  }

Example01aOutput <- RcppGO(ObjectiveFunction=AluffiPentiny01a, Args=1, Lower = -10, Upper = 10)

Example01aOutput$GMemory
