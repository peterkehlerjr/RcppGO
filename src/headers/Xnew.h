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
