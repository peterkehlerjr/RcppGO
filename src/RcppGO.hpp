/***
* @title:  RcppGO.hpp
*
* @author: Peter Kehler
*
* @date:   10.02.2012
*
* @description: C++ implementation of an stochastic agent-based optimization algorithm using the laws of gravity and motion
*
* @source:  loosely based on the CSS algorithm of A. Kaveh and S. Talatahari described in
 'A novel heuristic optimization method: charged system search', Acta Mechanica 213, p. 267-289 (2010)
*
*
* @email: peter.kehler.jr@googlemail.com
***/

/*==============================================================================================*/

/*
 * === libraries ====
 */

#include <RcppArmadillo.h>
// for an alternative random number generation approach
#include <stdlib.h>
#include <time.h>


/*
 * === namespaces ====
 */
using namespace Rcpp;
using namespace arma;


/*
 * === function prototypes ====
 */

RcppExport SEXP RcppGO(SEXP FunR, SEXP ArgsR, SEXP LowerR, SEXP UpperR, SEXP nR, SEXP gR, SEXP IterationsR, SEXP UserR, SEXP ScaleR, SEXP MaximizeR);

void ObjectiveFunction(cube & GravityParticles, Function & RFun, const int & Args, const int & n, double & k);

void Handling(cube & GravityParticles, double & k, const int & n, const int & Args, const NumericVector & Lower, const NumericVector & Upper);

void UpdateGMemory(cube & GravityParticles, double & k, const int & n, const int & g, mat & GMemory, const int & Args, const bool & Maximize);

void F_j(cube & GravityParticles, const int & n, const int & g, const int & Args, const double & Scale, double & k, mat & GMemory, mat & Dist, const bool & User, const double & Iterations, const bool & Maximize);

void VoidParticleDistances(cube & GravityParticles, const int & Args, const int & n, double & k, mat & Dist);

mat ParticleDistances(cube & GravityParticles, const int & Args, const int & n, double & k);

void SortSolutions(cube & GravityParticles, const int & Args, const int & n, double & k, const bool & Maximize);

double Radius(const double & Scale, cube & GravityParticles, const bool & User, double & k, const int & n, const int & Args, const double & Iterations, mat Dist);

void Vnew(cube & GravityParticles, const int & Args, double & k,  const int & n);

void Xnew(cube & GravityParticles, const int & Args, const int & n, double & k, const int & g, const double & Iterations);

double kv(double & k, const double & Iterations);

double kf(double & k, const double & Iterations);

double p_ij(cube & GravityParticles, double & k, int & j, int & i, const bool & Maximize, const int & Args, mat & GMemory); 

void MyRunif(cube & GravityParticles, const NumericVector & Lower, const NumericVector & Upper, const int & Args, const int & n);
/*==============================================================================================*/


/*
* @title:  ObjectiveFunction
* @author: Peter Kehler
* @date:   10.02.2012
* @description: Evaluates the R function.
*/
void ObjectiveFunction(cube & GravityParticles, Function & RFun, const int & Args, const int & n, double & k)
{
  mat PosTmp = GravityParticles.subcube(0,0,k, n-1,Args-1,k);
  mat X(PosTmp.begin(), n , Args, false);
  NumericVector  FunValTmp = RFun(wrap(X));
  cube GPTmp(FunValTmp.begin(), n, 1, 1, false);
  GravityParticles.subcube(0,Args,k, n-1, Args,k) = GPTmp;
}


/*
* @title:  SortSolutions
* @author: Peter Kehler
* @date:   10.02.2012
* @description: Sorts the soultions of 'ObjectiveFunction' conditional on the value of 'Maximize'.
*/
void SortSolutions(cube & GravityParticles, const int & Args, const int & n, double & k, const bool & Maximize)
{
  mat GPTmp = GravityParticles.subcube(0,0,k, n-1,Args,k);
  uvec sortet;

  if (Maximize == false)
    {
      sortet = sort_index(GPTmp.submat(0,Args, n-1,Args),0);
    }
  else
    {
      sortet = sort_index(GPTmp.submat(0,Args, n-1,Args),1);
    }
  
  for (int j = 0; j <= Args; j++)
    {
      vec GPColTmp = GPTmp.col(j);
      GPTmp.col(j) = GPColTmp.elem(sortet);
    }

  GravityParticles.subcube(0,0,k, n-1,Args,k) = GPTmp;
}


/*
* @title: UpdateGMemory 
* @author: Peter Kehler
* @date:   10.02.2012
* @description: Updates the particle positions in GMemory 
*/
void UpdateGMemory(cube & GravityParticles, double & k, const int & n, const int & g, mat & GMemory, const int & Args, const bool & Maximize) 
{
  uvec sortet;

  if (k == 0)
    {
      GMemory = GravityParticles.slice(0);
    }
  else 
    {
      /* merge GMemory & GravityParticles.Slice(k) into Aux for sorting*/
      mat Merger(n+g,3*Args+1);
      Merger.submat(0,0, n-1,3*Args) = GMemory;           
      Merger.submat(n,0, (n+g-1),3*Args) = GravityParticles.slice(k);   
      
      if (Maximize == false)
	{
	  sortet = sort_index(Merger.col(Args),0); // "0" := smallest value first
	}
      else 
	{
	   sortet = sort_index(Merger.col(Args),1); // "1" := largest value first
	}
      
      for (int j = 0; j <= (3*Args); j++)
	{
	  vec ColTmp = Merger.col(j);
	  Merger.col(j) = ColTmp.elem(sortet);
	}

      GMemory = Merger.rows(0, n-1);  // update GMemory
    }
}


/*
* @title:  Radius
* @author: Peter Kehler
* @date:   10.02.2012
* @description: Calculates the radius surrounding a particle
*/
double Radius(const double & Scale, cube & GravityParticles, const bool & User, double & k, const int & n, const int & Args, const double & Iterations)
{
  double result;
  mat MaxDistTmp = max(ParticleDistances(GravityParticles, Args, n, k));
  double MaxDist = max(conv_to< vec >::from(MaxDistTmp));

  if (User == true)
    {
      result = Scale * MaxDist;
    }
  else 
    {
      result = 0.5*(1 - k/Iterations) * MaxDist;
    }
  return result;
}


/*
* @title:  p_ij
* @author: Peter Kehler
* @date:   10.02.2012
* @description: Probability of attraction between particle 'i' and 'j'
*/
double p_ij(cube & GravityParticles, double & k, int & j, int & i, const bool & Maximize, const int & Args, mat & GMemory)
{ 
  /* 
     // this code slows the program considerably down
     Function runif = Function("runif");
     NumericVector vTmp = runif(1);
     vec v(vTmp.begin(),1,false);
  */
  vec v(1);
  v = randu<vec>(1);
  
  double xi = as_scalar(v);
  double Particle_j = as_scalar(GravityParticles.subcube(j,Args,k, j,Args,k));
  double Particle_i = as_scalar(GMemory.submat(i,Args, i,Args));
  if (Maximize == true)
    {
      if ( (Particle_j > Particle_i) && (xi > 0.1))
	{
	  return 0.0;
	}
      else 
	{
	  return 1.0;
	}
    }
  else 
    {
      if ( (Particle_j < Particle_i) && (xi < 0.1))
	{
	  return 0.0;
	}
      else 
	{
	  return 1.0;
	} 
    } 
}


/*
* @title:  F_j
* @author: Peter Kehler
* @date:   10.02.2012
* @description: Calculate forces resulting on every particle.
*/
void F_j(cube & GravityParticles, const int & n, const int & g, const int & Args, const double & Scale, double & k, mat & GMemory, mat & Dist, const bool & User, const double & Iterations, const bool & Maximize)
{
  // use article variable names, where possible 
  double d = Radius(Scale, GravityParticles, User, k, n, Args, Iterations);
  mat Forces(g, Args);
  
  for (int j = 0; j < n; j++) 
    {
      for (int i = 0; i < g; i++)
	{
	  double r = Dist(i, j);
	  mat GPTmp = GravityParticles.subcube(j,0,k, j,Args-1,k);
	  mat GMGPDif = GMemory.submat(i,0, i,Args-1) - GPTmp;
	  double m_i = as_scalar(abs(GMemory.submat(i,Args, i,Args)));
	  double probability = p_ij(GravityParticles, k, j, i, Maximize, Args, GMemory);

	  if (r < d)
	    {
	      Forces.submat(i,0, i,Args-1) = m_i/pow(d,3) * GMGPDif * probability;
	    }
	  else 
	    {
	      Forces.submat(i,0, i,Args-1) = m_i/pow(r,3) * GMGPDif * probability;
	    }
	}

      GravityParticles.subcube(j,(2*Args+1),k, j,(3*Args),k) = sum(Forces,0);
    }
}


/*
* @title:  kf
* @author: Peter Kehler
* @date:   10.02.2012
* @description: Influence factor of attracting forces.
*/
double kf(double & k, const double & Iterations)
{
  return 0.5*(1 + k/Iterations);
}


/*
* @title:  kv
* @author: Peter Kehler
* @date:   10.02.2012
* @description: Influence factor of particle velocity.
*/
double kv(double & k, const double & Iterations)
{
  return 0.5*(1 - k/Iterations);
}


/*
* @title:  Xnew
* @author: Peter Kehler
* @date:   10.02.2012
* @description: Calculates the resultant positions due to the law of motion.
*/
void Xnew(cube & GravityParticles, const int & Args, const int & n, double & k, const int & g, const double & Iterations)
{
  mat xi1 = randu<mat>(n, Args);                               
  mat xi2 = randu<mat>(n, Args);  

  mat F = GravityParticles.subcube(0,2*Args+1,k, n-1,3*Args,k);

  mat V = GravityParticles.subcube(0,Args+1,k, n-1,2*Args,k);

  mat Xold = GravityParticles.subcube(0,0,k, n-1,Args-1,k);
  GravityParticles.subcube(0,0,k+1, n-1,Args-1,k+1) = kf(k, Iterations) * xi1 % F + kv(k, Iterations) * xi2 % V + Xold;
}


/*
* @title:  Vnew
* @author: Peter Kehler
* @date:   10.02.2012
* @description: Calculates the velocity of every particle.
*/
void Vnew(cube & GravityParticles, const int & Args, double & k,  const int & n)
{
  mat Xnew = GravityParticles.subcube(0,0,k+1, n-1,Args-1,k+1);
  mat Xold = GravityParticles.subcube(0,0,k, n-1,Args-1,k);
  GravityParticles.subcube(0,Args+1,k+1, n-1,2*Args,k+1) =  Xnew - Xold;
}


/*
* @title:  VoidParticleDistances
* @author: Peter Kehler
* @date:   10.02.2012
* @description: Calculates the distance matrix for all particles.
*/
void VoidParticleDistances(cube & GravityParticles, const int & Args, const int & n, double & k, mat & Dist)
{
  mat M = GravityParticles.subcube(0,0,k, n-1,3*Args,k);
  mat L(n,n);
  L.zeros();

  for (int i = 0; i < n; i++)
    {
      for (int j = 0; j <= i; j++)
	{
	  if (j == i){ break; }
	  mat Particle_i = M.submat(i,0, i,Args-1);
	  mat Particle_j = M.submat(j,0, j,Args-1);

	  mat Quad = (Particle_j - Particle_i) % (Particle_j - Particle_i);
	  L(i,j) = as_scalar(sqrt(sum(Quad,1)));
	}
    }
  Dist = symmatl(L);
}


/*
* @title:  ParticleDistances
* @author: Peter Kehler
* @date:   10.02.2012
* @description: Calculates the distance matrix for all particles.
*/
mat ParticleDistances(cube & GravityParticles, const int & Args, const int & n, double & k)
{
  mat M = GravityParticles.subcube(0,0,k, n-1,3*Args,k);
  mat L(n,n);
  L.zeros();

  for (int i = 0; i < n; i++)
    {
      for (int j = 0; j <= i; j++)
	{
	  if (j == i){ break; }
	  mat Particle_i = M.submat(i,0, i,Args-1);
	  mat Particle_j = M.submat(j,0, j,Args-1);

	  mat Quad = (Particle_j - Particle_i) % (Particle_j - Particle_i);
	  L(i,j) = as_scalar(sqrt(sum(Quad,1)));
	}
    }
  L = symmatl(L);
  return L;
}



/*
* @title:  Handling
* @author: Peter Kehler
* @date:   15.08.2012
* @description: runif for vectorized 'Lower' / 'Upper' values.
*/
void MyRunif(cube & GravityParticles, const NumericVector & Lower, const NumericVector  & Upper, const int & Args, const int & n)
{
  for (int j = 0; j < Args; j++)
    {
      for(int i = 0; i < n; i++)
	{
	  vec RunifTmp = Lower(j) + (Upper(j) - Lower(j)) * randu<vec>(1);
	  GravityParticles(i,j,0) = RunifTmp(0);
	}
    }
}


/*
* @title:  Handling
* @author: Peter Kehler
* @date:   15.08.2012
* @description: Handles outliers and forces solutions in [Upper, Lower].
*/
void Handling(cube & GravityParticles, double & k, const int & n, const int & Args, const NumericVector & Lower, const NumericVector & Upper)
{
  for(int j = 0; j < Args; j++)
    {
      for(int i = 0; i < n; i++)
	{
	  if(GravityParticles(i,j,k) < Lower(j) || GravityParticles(i,j,k) > Upper(j))
	    {
	      vec RunifTmp = Lower(j) + (Upper(j) - Lower(j)) * randu<vec>(1);
	      GravityParticles(i, j, k) = RunifTmp(0);
	    }
	}
    }
}

/*
====================================================================================  
 */

/*
* @title:  MyRunif
* @author: Peter Kehler
* @date:   02.03.2012
* @description: runif for vectorized 'Lower' / 'Upper' values.
*/
// void MyRunif(cube & GravityParticles, const NumericVector & Lower, const NumericVector  & Upper, const int & Args, const int & n)
// {
//   Function runif = Function("runif");
  
//   RNGScope scope;
  
//   int dim = n*Args;
//   NumericVector  V = runif(dim, Lower, Upper);
//   vec W(V.begin(), dim, false);
  
//   cube InitPos(n, Args, 1);
  
//   int col_j = 0; 
//   int row_i = 0;
//   for (int k = 0; k < dim; k++)
//     {
//       if(col_j == Args) 
// 	{
// 	  row_i = row_i + 1;
// 	  col_j = 0; 
// 	}
//       if (row_i == n) row_i = 0;
//       InitPos(row_i, col_j, 0) = W(k);
//       col_j = col_j + 1;
//     }
//   GravityParticles.subcube(0, 0, 0, n-1, Args-1, 0)  = InitPos;
// }


/*
* @title:  Handling
* @author: Peter Kehler
* @date:   05.03.2012
* @description: Outlier correction.
*/
// void Handling(cube & GravityParticles, double & k, const int & n, const int & Args, const NumericVector & Lower, const NumericVector & Upper)
// {
//   Function runif = Function("runif");

//   RNGScope scope;

//   for(int j = 0; j < Args; j++)
//     {
//       for(int i = 0; i < n; i++)
// 	{
// 	  if(GravityParticles(i,j,k) < Lower(j) || GravityParticles(i,j,k) > Upper(j))
// 	    {
// 	      NumericVector V = runif(1, Lower(j), Upper(j));
// 	      vec W(V.begin(), 1, false);
// 	      GravityParticles(i,j,k) = W(0);
// 	    }
// 	}
//     }
// }
