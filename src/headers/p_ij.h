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
