library("RcppGO")

rm(list=ls())

# min at 0.0, X in [-10, 10]^2
f <- function(X)
  {
    X[,1]^2 + X[,2]^2
  }

Test00 <- RcppGO(ObjectiveFunction=f, Args=2, Lower= -10, Upper= 10)
Test00$GMemory
# RcppGO.Plot(RcppGO.Data=Test00)

#--------------------------------------------------------------------------------

# min at -0.352386, X in [-10,10]^2
AluffiPentiny <- function(X)
{
  1/4*X[,1]^4 - 1/2*X[,1]^2 + 1/10*X[,1] + 1/2*X[,2]^2
}


Test01 <- RcppGO(ObjectiveFunction=AluffiPentiny, Args=2, Lower = -10, Upper = 10, User=FALSE, Scale=0.1)
Test01$GMemory

RcppGO.Plot(RcppGO.Data = Test01, Particle_Sim = FALSE)

# --------------------------------------------------------------------------------
# min at 0.0, X in [-100,100]^2
Bohachevsky01 <- function(X)
{
  X[,1]^2 + 2*X[,2]^2 - 3/10*cos(3*pi*X[,1]) - 4/10*cos(4*pi*X[,2]) + 7/10
}
Test02 <- RcppGO(ObjectiveFunction= Bohachevsky01,  Args=2, Lower = -100, Upper = 100)
Test02$GMemory

RcppGO.Plot(RcppGO.Data = Test02, Particle_Sim = FALSE)	
# --------------------------------------------------------------------------------
# min at 	0.0, X in [-50,50]^2
Bohachevsky02 <- function(X)
{
  X[,1]^2 + 2*X[,2]^2 - 3/10*cos(3*pi*X[,1])*cos(4*pi*X[,2]) + 3/10
}
Test03 <- RcppGO(ObjectiveFunction= Bohachevsky02, Args=2, Lower = -50, Upper = 50)
Test03$GMemory

RcppGO.Plot(RcppGO.Data = Test03, Particle_Sim = FALSE)
# --------------------------------------------------------------------------------
# min at 	0.0, X in [-10,10]^2
BeckerAndLago <- function(X)
{
  (abs(X[,1])-5)^2 + (abs(X[,2])-5)^2
}
Test04 <- RcppGO(ObjectiveFunction=BeckerAndLago, Args=2, Lower = -10, Upper = 10)
Test04$GMemory

RcppGO.Plot(RcppGO.Data = Test04, Particle_Sim = FALSE)
# --------------------------------------------------------------------------------
# min at 	0.397887, X[,1] in [-5,10], X[,2] in [0,15]
Branin <- function(X)
{
  (X[,2] - 5.1/(4*pi^2)*X[,1]^2 + 5/pi*X[,1])^2 + 10*(1-1/(8*pi))*cos(X[,1]) + 10
}
Test05 <- RcppGO(ObjectiveFunction=Branin, Args=2, Lower = -10, Upper = 10, User=FALSE, Scale=0.01)
Test05$GMemory

RcppGO.Plot(RcppGO.Data = Test05, Particle_Sim = FALSE)
# --------------------------------------------------------------------------------
# min at 	-1.0316, X in [-5,5]^2
Camel <- function(X)
{
  4*X[,1]^2 - 2.1*X[,1]^4 + 1/3*X[,1]^6 + X[,1]*X[,2] - 4*X[,2]^2 + 4*X[,2]^4
}	
Test06 <- RcppGO(ObjectiveFunction=Camel,  Args=2, Lower = -5, Upper = 5, Maximize=FALSE)
Test06$GMemory

RcppGO.Plot(RcppGO.Data = Test06, Particle_Sim = FALSE)
# --------------------------------------------------------------------------------
# min at 0.4, X in [-1,1]^4
Cosine.mixture <- function(X)
{
  fn <- function(i) sum(X[i,]^2)-1/10*sum(cos(5*pi*X[i,]))
  sapply(1:nrow(X),fn)
}
Test07 <- RcppGO(ObjectiveFunction=Cosine.mixture,  Args=4, Lower = -1, Upper = 1)
Test07$GMemory
# --------------------------------------------------------------------------------
# min at 0.0, X in [-5.12,5.12]^3
DeJoung <- function(X){ X[,1]^2 + X[,2]^2 + X[,3]^2 }
Test08 <- RcppGO(ObjectiveFunction=DeJoung, Args=3, Lower = -5.12, Upper = 5.12)
Test08$GMemory
# --------------------------------------------------------------------------------
# min at -1, X in [-1,1]^n
Exponential <- function(X)
{
  fn <- function(i) -exp(-0.5*sum(X[i,]^2))
  sapply(1:nrow(X),fn)
}
	
Test09 <- RcppGO(ObjectiveFunction=Exponential,  Args=4, Lower = -1, Upper = 1)
Test09$GMemory
# --------------------------------------------------------------------------------
# min at 	0.0, X in [-100,100]^2
Griewank <- function(X)
{
  fn <- function(i) {1 + 1/200*sum(X[i,]^2) - prod(cos(X[i,]/sqrt(i)))}
  return(sapply(1:nrow(X),fn))
}
Test10 <- RcppGO(ObjectiveFunction=Griewank, Args=2, Lower = -100, Upper = 100, User=TRUE, Scale=0.01, Iterations=300)
Test10$GMemory
	
# --------------------------------------------------------------------------------
# min at 	2.0, X in [-1,1]^2
Rastrigin <- function(X)
{
  fn <- function(n) {sum(X[n,] - cos(18*X[n,]))}
  return(sapply(1:nrow(X),fn))
}	

Test11 <- RcppGO(ObjectiveFunction=Rastrigin, Args=2, Lower = -1, Upper = 1, User=TRUE, Scale=0.05)
Test11$GMemory

# --------------------------------------------------------------------------------
# min at 	0.0, X in [-30,30]^2
Rosenbrock <- function(X)
{
  100*(X[,2] - X[,1]^2)^2 + (X[,1] -1)^2
}	
Test12 <- RcppGO(ObjectiveFunction= Rosenbrock, Args=2, Lower = -30, Upper = 30)
Test12$GMemory

RcppGO.Plot(RcppGO.Data = Test12, Particle_Sim = FALSE)

