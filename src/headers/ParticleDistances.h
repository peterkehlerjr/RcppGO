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
