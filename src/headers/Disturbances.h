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
