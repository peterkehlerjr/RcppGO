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
