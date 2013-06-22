\name{RcppGO}
\alias{RcppGO}
\title{RcppGO}
\usage{
  RcppGO(ObjectiveFunction, Args, Lower, Upper, n = 20,
    g = 20, Iterations = 201, User = FALSE, Scale = 0.1,
    Maximize = FALSE)
}
\arguments{
  \item{ObjectiveFunction}{The objective function for
  optimization.}

  \item{Args}{Specifies the number of arguments provided by
  'ObjectiveFunction'.}

  \item{Lower}{Vector for lower boundaries.}

  \item{Upper}{Vector for upper boundaries.}

  \item{n}{Number of searching particles. Default is '20'.}

  \item{g}{Number of best solutions stored. Default is
  '20'.}

  \item{Iterations}{Number of iterations. Default is
  '201'.}

  \item{User}{If 'TRUE' the variable 'Scale' can be set
  manually. Default is 'FALSE'.}

  \item{Scale}{Sets the particle radius. Default is '0.1'.}

  \item{Maximize}{The objective function will be maximized,
  if 'TRUE'. Default is 'FALSE'.}
}
\value{
  A list with the following parameters: - the evolution of
  the optimization process: 'GravityParticles' - the
  'ObjectiveFunction' - a matrix with 'g' saved best
  solutions: 'GMemory' - the number of 'Iterations' - the
  number of searching particles: 'n' - the number of best
  solutions found: 'g' - the 'Lower' and 'Upper' bounds -
  the user provided values of 'Scale', 'User' and
  'Maximize'
}
\description{
  This is the main function for calling the
  optimization routine.} \details{'RcppGO' calls all 'R'
  subfunctions defined in 'RcppGO.Helper.R' and the
  algorithm written in 'C++'.
}
\author{
  Peter Kehler
}

