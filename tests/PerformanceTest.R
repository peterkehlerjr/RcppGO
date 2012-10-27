library("RcppDE")
library("RcppGO")

AluffiPentiny <- function(X)
{
  1/4*X^4 - 1/2*X^2 + 1/10*X + 1/2*X^2
}

# performance test DEoptim and RcppGO
(RcppGOMean <- mean(replicate(100,system.time(RcppGO(AluffiPentiny, 1, -10,10))[3])))
(DEMean <- mean(replicate(100,system.time(DEoptim(fn=AluffiPentiny, lower = -10, upper=10,control = list(trace = FALSE))))[3]))

RcppGOMean/DEMean
(RcppGOMean/DEMean)^-1



mean(replicate(100,system.time(optim(par=0, fn=AluffiPentiny, lower=-10, upper=10, method="L-BFGS-B"))))
