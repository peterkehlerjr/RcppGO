/***

@title: RcppGO.h

@author: Peter Kehler

@email: peter.kehler.jr@googlemail.com

 ***/



/* === Libraries ==== */
 

#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]
#include <stdlib.h>
#include <time.h>


/* === namespaces ==== */
using namespace Rcpp;
using namespace arma;


RcppExport SEXP RcppGO(SEXP FunR, SEXP ArgsR, SEXP LowerR, SEXP UpperR, SEXP nR, SEXP gR, SEXP IterationsR, SEXP UserR, SEXP ScaleR, SEXP MaximizeR);

    

/*
 * === function prototypes ====
 */

RcppExport SEXP RcppGO(SEXP FunR, SEXP ArgsR, SEXP LowerR, SEXP UpperR, SEXP nR, SEXP gR, SEXP IterationsR, SEXP UserR, SEXP ScaleR, SEXP MaximizeR);

void ObjectiveFunction(cube & GravityParticles, Function & RFun, const int & Args, const int & n, double & k);

void Handling(cube & GravityParticles, double & k, const int & n, const int & Args, const NumericVector & Lower, const NumericVector & Upper);

void UpdateGMemory(cube & GravityParticles, double & k, const int & n, const int & g, mat & GMemory, const int & Args, const bool & Maximize);

void VoidParticleDistances(cube & GravityParticles, const int & Args, const int & n, double & k, mat & Dist);

mat ParticleDistances(cube & GravityParticles, const int & Args, const int & n, double & k);

void SortSolutions(cube & GravityParticles, const int & Args, const int & n, double & k, const bool & Maximize);

double Radius(const double & Scale, cube & GravityParticles, const bool & User, double & k, const int & n, const int & Args, const double & Iterations, mat Dist);

void F_j(cube & GravityParticles, const int & n, const int & g, const int & Args, const double & Scale, double & k, mat & GMemory, mat & Dist, const bool & User, const double & Iterations, const bool & Maximize);

void Vnew(cube & GravityParticles, const int & Args, double & k,  const int & n);

void Xnew(cube & GravityParticles, const int & Args, const int & n, double & k, const int & g, const double & Iterations);

double kv(double & k, const double & Iterations);

double kf(double & k, const double & Iterations);

double p_ij(cube & GravityParticles, double & k, int & j, int & i, const bool & Maximize, const int & Args, mat & GMemory); 

void MyRunif(cube & GravityParticles, const NumericVector & Lower, const NumericVector & Upper, const int & Args, const int & n);
/*==============================================================================================*/

#include "headers/ObjectiveFunction.h"
#include "headers/Handling.h"
#include "headers/UpdateGMemory.h"
#include "headers/p_ij.h"
#include "headers/Radius.h"
#include "headers/F_j.h"
#include "headers/VoidParticleDistances.h"
#include "headers/ParticleDistances.h"
#include "headers/SortSolutions.h"
#include "headers/Vnew.h"
#include "headers/Xnew.h"
#include "headers/Disturbances.h"
#include "headers/RcppGO_RNG.h"   
