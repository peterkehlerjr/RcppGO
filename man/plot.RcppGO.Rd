\name{plot.RcppGO}
\alias{plot.RcppGO}
\title{plot.RcppGO}
\usage{
 \method{plot}{RcppGO}(x, ...,
    plot.type = c("static", "dynamic"), delay = 0.3,
    bestsolution = TRUE, nextposition = FALSE,
    velocity = FALSE, resForce = FALSE, radius = FALSE)
}
\arguments{
  \item{x}{Data that is returned by the 'RcppGO'
  function.}

  \item{...}{Included to comply with the generic plot function arguments.}

  \item{plot.type}{The plot type can be either 'static' or
  'dynamic'.}

  \item{delay}{The delay between the plot updates.}

  \item{bestsolution}{Indicator of the overall best found
  solution.}

  \item{nextposition}{The position of a particle in t+1.}

  \item{velocity}{The velocity vector.}

  \item{resForce}{The resultant force vector on a
  particle.}

  \item{radius}{The time dependent radius around a particle
  separating the acting forces.}
}
\value{
  Return either a 'static' or a 'dynanmic' plot.
}
\description{
  Plotting 'static' or 'dynamic' plots of
  two-dimensional data.} \details{The function is the
  condensate of tests to verify the validity of the
  algorithm in a two-dimensional search space. The
  'dynamic' plot incorporates a contourplot showing the
  particle movements. The 'delay' value is by default set
  to 0.3. Setting 'delay' to 'FALSE' makes the plotting
  device ask for every new plot.  'bestsolution' marks the
  overall best solution in the plot. 'nextposition' enables
  or disables an arrow pointing to the position of a
  particle in t+1. 'velocity' prints an arrow of the
  velocity vector of a particle. 'resForce' is the
  resultant vector of the gravitational force on a
  particle. 'radius' prints the time dependent radius of
  action of the forces.
}
\author{
  Peter Kehler
}

