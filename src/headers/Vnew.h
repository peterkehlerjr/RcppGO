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
