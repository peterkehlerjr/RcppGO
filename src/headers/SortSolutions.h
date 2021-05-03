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
      sortet = sort_index(GPTmp.submat(0,Args, n-1,Args),"ascend");
    }
  else
    {
      sortet = sort_index(GPTmp.submat(0,Args, n-1,Args),"descend");
    }
  
  for (int j = 0; j <= Args; j++)
    {
      vec GPColTmp = GPTmp.col(j);
      GPTmp.col(j) = GPColTmp.elem(sortet);
    }

  GravityParticles.subcube(0,0,k, n-1,Args,k) = GPTmp;
}
