##' \description{This is the main function for calling the optimization routine.} 
##' \details{'RcppGO' calls all 'R' subfunctions defined in 'RcppGO.Helper.R' and the algorithm written in 'C++'.}
##' @title RcppGO
##' @param ObjectiveFunction The objective function for optimization.
##' @param Args Specifies the number of arguments provided by 'ObjectiveFunction'.
##' @param Lower Vector for lower boundaries.
##' @param Upper Vector for upper boundaries.
##' @param n Number of searching particles. Default is '20'.
##' @param g Number of best solutions stored. Default is '20'.
##' @param Iterations Number of iterations. Default is '201'.
##' @param User If 'TRUE' the variable 'Scale' can be set manually. Default is 'FALSE'.
##' @param Scale Sets the particle radius. Default is '0.1'.
##' @param Maximize The objective function will be maximized, if 'TRUE'. Default is 'FALSE'. 
##' @return A list with the following parameters:
##' - the evolution of the optimization process: 'GravityParticles'
##' - the 'ObjectiveFunction'
##' - a matrix with 'g' saved best solutions: 'GMemory'
##' - the number of 'Iterations'
##' - the number of searching particles: 'n'
##' - the number of best solutions found: 'g'
##' - the 'Lower' and 'Upper' bounds
##' - the user provided values of 'Scale', 'User' and 'Maximize'
##' @author Peter Kehler
RcppGO <- function(ObjectiveFunction, 			
                         Args, 			
                         Lower, 			
                         Upper,  		
                         n=20, 		
                         g=20, 		
                         Iterations=201,	
                         User=FALSE,	
                         Scale=0.1,		
                         Maximize=FALSE			
                         )
  {
    # first case: length(Lower) & length(Upper) == 1
    if((length(Lower) & length(Upper)) == 1)
      {
        Lower <- rep(Lower, Args)
        Upper <- rep(Upper, Args)
      }

    # second case: 
    else if( (length(Lower) | length(Upper)) > 1)
      {
        if(length(Lower) != length(Upper))
          {
            stop("length(Lower) != length(Upper).")
          }
      }
      
            
    # correct parameters with value <= 0
    if (g > n) stop("g must be element of [1,n]")

    sanity.check(input=n, symbol="<=", default.type="double", default.value=20, threshold=0)
    sanity.check(input=g, symbol="<=", default.type="double", default.value=20, threshold=0)
    
    sanity.check(input=Iterations, symbol="<=", default.type="double", default.value=201, threshold=0)
    
    sanity.check(input=Scale, symbol="<=", default.type="double", default.value=0.1, threshold=0)
    sanity.check(input=Args, symbol="<=", default.type="double", default.value=2, threshold=0)
    
    
    # check binary variables
    sanity.check(input=User, default.type="logical")
    sanity.check(input=Maximize, default.type="logical")
    

   # check for 'Inf' and '-Inf'
    sanity.check(input=c(Args, Lower, Upper, n, g, Iterations, Scale), default.type="double")

    # check boundaries 
    ifelse(Lower > Upper,stop("'Lower' > 'Upper'"),"proceed")
    
    
    result <- .Call("RcppGO", ObjectiveFunction, Args, Lower, Upper, n, g, Iterations, User, Scale, Maximize, Package="RcppGO")
    
    Names <- c(paste("x",1:Args,sep=""),"fn_x",paste("v_x",1:Args,sep=""),paste("F_x",1:Args, sep=""))
    dimnames(result$GravityParticles) <- list(c(paste(1:n)),Names)
    dimnames(result$GMemory) <- list(c(paste(1:n)),Names[1:(Args+1)])
    
 

    attr(result, "class") <- "RcppGO" 
    return(result)
  }
