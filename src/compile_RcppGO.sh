#!/bin/bash  

## find directory of file
ABSPATH=$(cd "$(dirname "$0")"; pwd)
cd $ABSPATH

FILENAME=RcppGO

## remove old files
rm -rf *.o *.so 

# export librarys to PATH
RCPP_CXXFLAGS=`Rscript -e 'Rcpp:::CxxFlags()'`
RCPP_LIBS=`Rscript -e 'Rcpp:::LdFlags()'`
RCPP_ARMADILLO=`Rscript -e 'RcppArmadillo:::CxxFlags()'`


export PKG_CPPFLAGS="${RCPP_ARMADILLO} ${RCPP_CXXFLAGS}"
export PKG_LIBS="-larmadillo -llapack  ${RCPP_LIBS}"




# compiler options
GCC=true
OS=`uname`

if [ $GCC == "false" ]; then
    # compile using R
    R CMD SHLIB $FILENAME.cpp -o $FILENAME.so
fi


if [ $GCC == "true" ]; then
    
    if [ $OS == "Linux" ]; then 
    	compiler=g++
	$compiler -I/usr/share/R/include -DNDEBUG -I/home/pkehler/R/x86_64-pc-linux-gnu-library/2.15/RcppArmadillo/include -I/home/pkehler/R/x86_64-pc-linux-gnu-library/2.15/Rcpp/include  -fpic  -O3 -pipe  -g  -c $FILENAME.cpp -o $FILENAME.o
	
	$compiler -shared -o $FILENAME.so $FILENAME.o -L/home/pkehler/R/x86_64-pc-linux-gnu-library/2.15/Rcpp/lib -lRcpp -Wl,-rpath,/home/pkehler/R/x86_64-pc-linux-gnu-library/2.15/Rcpp/lib -llapack -lblas -lgfortran -lm -lquadmath -L/usr/lib/R/lib -lR
	
	echo""
	echo "Compilation succeded."
	echo ""
    fi
    
    if [ $OS == "Darwin" ]; then 
    	g++-4.6.3 -I/Library/Frameworks/R.framework/Resources/include -I/Library/Frameworks/R.framework/Resources/include/x86_64 -DNDEBUG -I/Library/Frameworks/R.framework/Versions/2.15/Resources/library/RcppArmadillo/include -I/Library/Frameworks/R.framework/Versions/2.15/Resources/library/Rcpp/include -I/usr/local/include    -fPIC  -g -O3  -c $FILENAME.cpp -o $FILENAME.o

	g++-4.6.3 -dynamiclib -Wl,-headerpad_max_install_names -undefined dynamic_lookup -single_module -multiply_defined suppress -L/usr/local/lib -o $FILENAME.so $FILENAME.o /Library/Frameworks/R.framework/Versions/2.15/Resources/library/Rcpp/lib/x86_64/libRcpp.a -L/Library/Frameworks/R.framework/Resources/lib/x86_64 -lRlapack -L/Library/Frameworks/R.framework/Resources/lib/x86_64 -lRblas -lgfortran -F/Library/Frameworks/R.framework/.. -framework R -Wl,-framework -Wl,CoreFoundation
	
	echo""
	echo "Compilation succeded."
	echo ""
    fi
fi


