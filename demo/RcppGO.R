# defining a benchmark function
# min at -0.352386, X in [-10,10]^2
AluffiPentiny <- function(X)
  {
    1/4*X[,1]^4 - 1/2*X[,1]^2 + 1/10*X[,1] + 1/2*X[,2]^2
  }

# call and save the optimization process in 'demo01''
demo01 <- RcppGO(ObjectiveFunction=AluffiPentiny,
                 Args=2,
                 Lower = -10,
                 Upper = 10,
                 User=FALSE,
                 Scale=0.1)

# show the best solutions found
demo01$GMemory


