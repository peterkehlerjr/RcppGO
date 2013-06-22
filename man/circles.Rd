\name{circles}
\alias{circles}
\title{circles}
\usage{
  circles(x, y, r, col = rep(0, length(x)),
    border = rep(1, length(x)), ...)
}
\arguments{
  \item{x}{Defines the x coordinate of the circle.}

  \item{y}{Defines the y coordinate of the circle.}

  \item{r}{Defines the radius 'r' of each circle.}

  \item{col}{Defines the color of the circle, if 'col' is a
  vector. Otherwise every circle has the same color.}

  \item{border}{If 'True' a border is drawn.}

  \item{...}{Additional parameters for the 'circle'
  function.}
}
\value{
  Plot of length(x) circles into a two-dimensional space.
}
\description{This function plots circles of length(x)
  into a two-dimensional space.}

\author{
  Peter Kehler
}

