rm(list=ls())

library("rbenchmark")	
library("RcppDE")
library("RcppGO")
library("DEoptim")

AluffiPentiny <- function(X)
{
  1/4*X^4 - 1/2*X^2 + 1/10*X + 1/2*X^2
}

# performance test DEoptim and RcppGO
RcppGOMean <- replicate(100,system.time(RcppGO(AluffiPentiny, 1, -10,10))[3])

RcppDEMean <- replicate(100,system.time(RcppDE::DEoptim(fn=AluffiPentiny, lower = -10, upper=10,control = list(trace = FALSE))))[3]


OptimMean <- replicate(100,system.time(optim(par=0, fn=AluffiPentiny, lower=-10, upper=10, method="L-BFGS-B"))[3])

DEMean <- replicate(100,system.time(DEoptim(fn=AluffiPentiny, lower=-10, upper=10, control = DEoptim.control(trace = FALSE)))[3])


boxplot(RcppGOMean, RcppDEMean, OptimMean, DEMean, col=c("red","blue", "yellow", "green"))



#RcppGO(AluffiPentiny, 1, -10,10)
#RcppDE::DEoptim(fn=AluffiPentiny, lower = -10, upper=10,control = list(trace = FALSE))
#optim(par=0, fn=AluffiPentiny, lower=-10, upper=10, method="L-BFGS-B")
#DEoptim(fn=AluffiPentiny, lower=-10, upper=10, control = DEoptim.control(trace = FALSE))



benchmark(RcppGO(AluffiPentiny, 1, -10,10),
				RcppDE::DEoptim(fn=AluffiPentiny, lower = -10, upper=10,control = list(trace = FALSE)),
				optim(par=0, fn=AluffiPentiny, lower=-10, upper=10, method="L-BFGS-B"),
				DEoptim(fn=AluffiPentiny, lower=-10, upper=10, control = DEoptim.control(trace = FALSE)),	
				replications=100, 
				order="relative"
				)

