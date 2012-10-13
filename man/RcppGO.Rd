\name{RcppGO}
\alias{RcppGO}
\concept{optimization}
\docType{package}
\title{
  Stochastic Optimization using physical laws.
}
\description{
\code{RcppGO} performs a global optimization process of \code{ObjectiveFunction} using laws of motion and gravity.
}

\usage{
RcppGO(ObjectiveFunction, Args, Lower, Upper, n, g, Iterations, User, Scale, Maximize)
}

\arguments{
  \item{ObjectiveFunction}{the function to be optimized . \code{ObjectiveFunction} has to be written in matrix form. See \code{examples}.}
  \item{Args}{the number of arguments \code{ObejectiveFunction} has.}
  \item{Lower, Upper}{numeric vectors for lower and upper bounds for arguments the search for the global optimum takes place. A discrimination for the i-th argument can be achieved via e.g. \code{Lower = c(-10,-10)} and \code{Upper = c(10,10)} for \code{Args = 2}.}
  \item{n}{number of particles searching inside the bounds. Default is set to \code{20}.}
  \item{g}{number of best solutions to be saved. Default is set to \code{20}.}
  \item{Iterations}{number of iterations until the program terminates. Default is set to \code{201}.}
  \item{User}{enables user to set value of \code{Scale} manually. Default is set to \code{FALSE}.}
  \item{Scale}{sets particle radius. Default is set to \code{0.1}.}
  \item{Maximize}{determines if a function is minimized or maximized. Default is set to \code{FALSE}.}
}


\details{
Package:  RcppGO\cr
Type:  Package\cr
Version: 0.1\cr
Date: 2012-02-10\cr
License: LGPLv3 \cr
}

\author{
Peter Kehler

Maintainer: Peter Kehler <peter.kehler.jr@googlemail.com>
}

\references{
Kaveh, A. and Talatahari, S.
\emph{A novel heuristic optimization method: charged system search}. 
Acta Mechanica 213, p. 267-289 (2010) 
}

\note{
  Please cite the package in publications. Use \code{citation("RcppGO")}.
}


\examples{
# Aluffi Pentiny Function with one argument
# with the global minimum f(X)= -0.03481192 at (-0.4641551)
AluffiPentiny01 <- function(X)
{
  1/4*X^4 - 1/2*X^2 + 1/10*X + 1/2*X^2
}

Example01 <- RcppGO(ObjectiveFunction=AluffiPentiny01, Args=1, Lower = -10, Upper = 10, User=FALSE, Scale=0.1)
Example01$GMemory

# Aluffi Pentiny Function with two arguments
# written in matrix notation
# with the global minimum f(X)= -0.352386 at (-1.0465, 0)

AluffiPentiny02 <- function(X)
{
  1/4*X[,1]^4 - 1/2*X[,1]^2 + 1/10*X[,1] + 1/2*X[,2]^2
}

Example02 <- RcppGO(ObjectiveFunction=AluffiPentiny02, Args=2, Lower = -10, Upper = 10, User=FALSE, Scale=0.1)
Example02$GMemory

# 
RcppGO.Plot(RcppGO.Data = Example02, Particle_Sim = FALSE)
RcppGO.Plot(RcppGO.Data = Example02, Particle_Sim = TRUE)


# Cosine.mixture Function with four arguments
# written in matrix notation
# with the global minimum f(X)= -0.4 at (0, 0, 0, 0)
Cosine.mixture <- function(X)
{
  fn <- function(i) sum(X[i,]^2)-1/10*sum(cos(5*pi*X[i,]))
  sapply(1:nrow(X),fn)
}
Example03 <- RcppGO(ObjectiveFunction=Cosine.mixture,  Args=4, Lower = -1, Upper = 1)
Example03$GMemory


# ====== end of examples  =======
}
\keyword{nonlinear}
\keyword{optimize}
