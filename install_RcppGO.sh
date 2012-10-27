#!/bin/bash  

## find directory of file
ABSPATH=$(cd "$(dirname "$0")"; pwd)
cd $ABSPATH

cd ..
 
FILENAME=RcppGO

# export librarys to PATH
RCPP_CXXFLAGS=`Rscript -e 'Rcpp:::CxxFlags()'`
RCPP_LIBS=`Rscript -e 'Rcpp:::LdFlags()'`
RCPP_ARMADILLO=`Rscript -e 'RcppArmadillo:::CxxFlags()'`


export PKG_CPPFLAGS="${RCPP_ARMADILLO} ${RCPP_CXXFLAGS}"
export PKG_LIBS="-larmadillo -llapack  ${RCPP_LIBS}"

R CMD INSTALL RcppGO*
