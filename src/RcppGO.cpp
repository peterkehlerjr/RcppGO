#include "RcppGO.hpp"

/* === RcppGO ===
 * @title:  RcppGO
 * @author: Peter Kehler
 * @date:   10.02.2012
 * @description: RcppGO is responsible for the optimization process and output.
 *
 * @param: SEXP ObjectiveFunctionR         Takes the objective function that is to be optimized.
 * @param: SEXP ArgsR        The number of indepent variables of the objective function.
 * @param: SEXP nR           Number of optimizing particles.
 * @param: SEXP gR           Number of best solutions the program calculates.
 * @param: SEXP LowerR       Lower limit for independent variables.
 * @param: SEXP UpperR       Upper limit for independent variables.
 * @param: SEXP IterationsR  Number of iterations until the program ends.
 * @param: SEXP UserR        Possibility for the user to set 'Scale' manually. false by default.
 * @param: SEXP ScaleR       If 'User' is 'true', the particle radius can be set with 'Scale'. 
 * @param: SEXP MaximizeR    If 'true', 'ObjectiveFunction' will be maximized. 'false' by default.
 **/

RcppExport SEXP RcppGO (SEXP ObjectiveFunctionR, 			
			SEXP ArgsR, 			
			SEXP LowerR, 			
			SEXP UpperR,  		
			SEXP nR, 		
			SEXP gR, 		
			SEXP IterationsR,	
			SEXP UserR,	
			SEXP ScaleR,		
			SEXP MaximizeR
			)
{
  BEGIN_RCPP
  
    srand(time(NULL)); 

  // conversion of R parameters
  Function RFun = Function (ObjectiveFunctionR);
  const int Args = as<int>(ArgsR);
  const int n = as<int>(nR);
  const int g = as<int>(gR);
  const NumericVector Upper(UpperR);
  const NumericVector Lower(LowerR);
  const double Iterations = as<double>(IterationsR);
  const double Scale = as<double>(ScaleR);
  const bool User = as<bool>(UserR);
  const bool Maximize = as<bool>(MaximizeR);

  cube GravityParticles(n, 3*Args+1, Iterations);
  GravityParticles.zeros();
  mat GMemory(n, 3*Args+1);
  GMemory.zeros();
  
  // generate initial positions
  MyRunif(GravityParticles, Lower, Upper, Args, n);
  
  mat Dist;
  Dist.zeros();
  
  // calculations
  for (double k = 0.0; k < (Iterations-1); k++) 
    {
      // handling
      Handling(GravityParticles, k, n, Args, Lower, Upper);
      
      // evaluate R function
      ObjectiveFunction(GravityParticles, RFun, Args, n, k);
      
      // sort solutions
      SortSolutions(GravityParticles, Args, n, k, Maximize);
      
      // update GMemory
      UpdateGMemory(GravityParticles, k, n, g, GMemory, Args, Maximize);
      
      // distance matrix in step 'k'
      VoidParticleDistances(GravityParticles, Args, n, k, Dist);
      
      // resultand force on particle 'j'
      F_j(GravityParticles, n, g, Args, Scale, k, GMemory, Dist, User, Iterations, Maximize);
      
      // calculate new particle positions
      Xnew(GravityParticles, Args, n, k, g, Iterations);
      
      // calculate new particle velocities 
      Vnew(GravityParticles, Args, k, n);
    }
  
  mat GMemoryOut(0, Args+1); 
  GMemoryOut =  GMemory.submat(0, 0, n-1, Args) ;


  // results
  List result = List::create(_["GravityParticles"] = wrap(GravityParticles),
			     _["ObjectiveFunction"] = wrap(RFun),
			     _["GMemory"] = wrap(GMemoryOut),
			     _["Iterations"] = wrap(Iterations),
			     _["Args"] = wrap(Args),
			     _["n"] = wrap(n),
			     _["g"] = wrap(g),
			     _["Lower"] = wrap(Lower),
			     _["Upper"] = wrap(Upper),
			     _["Scale"] = wrap(Scale),
			     _["User"] = wrap(User),
			     _["Maximize"] = wrap(Maximize)
			     );
  
  return wrap(result);
  END_RCPP
    }
