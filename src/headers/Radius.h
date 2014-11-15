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
