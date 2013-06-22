\name{sanity.check}
\alias{sanity.check}
\title{sanity.check}
\usage{
  sanity.check(input, symbol, default.type = NULL,
    default.value = NULL, threshold = NULL)
}
\arguments{
  \item{input}{The input to be tested.}

  \item{symbol}{The mathematical describing the relation
  between 'input' and 'threshold'.}

  \item{default.type}{A default type 'input' is tested
  against.}

  \item{default.value}{A default value, if 'threshold' is
  violated.}

  \item{threshold}{A threshold for 'input'.}
}
\value{
  Depening on the violations found the function returns
  warnings or corrects the given 'input'.
}
\description{
  The function provides an ad-hoc set of tests
  for input checks and correction.
}
\details{
  details{The tests so far include a type test of the
  given 'input' against a 'default.type'. If a 'threshold'
  according to 'symbol' is violated, 'input' is substituted
  by a 'default.value' and a warning message is issued. In
  addition a test against +/- Inf values is conducted and a
  warning message is issued.  The function is not checked
  against all possible value combinations and may produce
  unforseen errors.}
}
\author{
  Peter Kehler
}

