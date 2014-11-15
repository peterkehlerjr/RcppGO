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
