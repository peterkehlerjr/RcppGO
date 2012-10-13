OS=`uname`
GCC=true

RCPP_CXXFLAGS=`Rscript -e 'Rcpp:::CxxFlags()'`
RCPP_LIBS=`Rscript -e 'Rcpp:::LdFlags()'`
RCPP_ARMADILLO=`Rscript -e 'RcppArmadillo:::CxxFlags()'`


if [ $GCC == "true" ]; then
    
    if [ $OS == "Linux" ]; then 
    echo "Hello from Linux"

    fi
    
    if [ $OS == "Darwin" ]; then 
    echo "Hello from OSX"
    fi
fi










