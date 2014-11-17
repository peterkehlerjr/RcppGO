##' \description{This function modifies the user input 'fn' into the
##' standard pattern required by the 'outer()' function.}
##' @title RcppGO.Plot.Wrapper()
##' @param fn The objective function.
##' @return readable code for 'outer()'.
##' @author Peter Kehler
RcppGO.Plot.Wrapper <- function(fn)
{
  fnString <- deparse(fn)
  fnString <- gsub(" ","",fnString,fixed=TRUE)
  fnString <- paste(fnString,sep="",collapse="")
  
  if (Args == 2)
  {
    fnString <- gsub("(X)","(x,y)",fnString,fixed=TRUE)
    fnString <- gsub("X[,1]","x",fnString,fixed=TRUE)
    fnString <- gsub("X[,2]","y",fnString,fixed=TRUE)
  }
  
  if (Args == 1)
  {
    fnString <- gsub("(X)","(x)",fnString,fixed=TRUE)
    fnString <- gsub("X[,1]","x",fnString,fixed=TRUE)
  }
  
  return(eval(parse(text=fnString)))
}


##' \description{This function plots circles of length(x) into a two-dimensional space.}
##' @title circles
##' @param x Defines the x coordinate of the circle.
##' @param y Defines the y coordinate of the circle.
##' @param r Defines the radius 'r' of each circle.
##' @param col Defines the color of the circle, if 'col' is a vector. Otherwise every circle has the same color.
##' @param border If 'True' a border is drawn. 
##' @param ... Additional parameters for the 'circle' function.
##' @return Plot of length(x) circles into a two-dimensional space.
##' @author Peter Kehler
circles <- function(x, y, r, col = rep(0, length(x)),border = rep(1, length(x)), ...)
{
  
  circle <- function(x, y, r, ...)
    {
      ang <- seq(0, 2*pi, length = 100)
      xx <- x + r * cos(ang)
      yy <- y + r * sin(ang)
      polygon(xx, yy, ...)
    }
  
  for(i in 1:length(x))
    {
      circle(x[i], y[i], r[i], col = col[i], border = border[i], ...)
    }
}



##' \description{The function provides an ad-hoc set of tests for input checks and correction.}
##'
##' \details{The tests so far include a type test of the given 'input' against a 'default.type'. If a 'threshold' according to 'symbol' is violated, 'input' is substituted by a 'default.value' and a warning message is issued. In addition a test against +/- Inf values is conducted and a warning message is issued.  The function is not checked against all possible value combinations and may produce unforseen errors.}
##' @title sanity.check
##' @param input The input to be tested.
##' @param symbol The mathematical describing the relation between 'input' and 'threshold'.
##' @param default.type A default type 'input' is tested against.
##' @param default.value A default value, if 'threshold' is violated.
##' @param threshold A threshold for 'input'.
##' @return Depening on the violations found the function returns warnings or corrects the given 'input'.
##' @author Peter Kehler
sanity.check <- function(input, symbol, default.type=NULL, default.value=NULL, threshold=NULL)
  {
    if (typeof(input)!= default.type)
      {
        stop("\t The type of your input is '",typeof(input),"'.\n \t Required type is '", substitute(default.type),"'.\n\t Process terminated.\n")
      }

    if (any(input == Inf | input== -Inf))
      {
       warning("One or more values of input are +/-Inf. This could cause undesirable effects.")     
      }

    if (!(missing(symbol)))
      {
        symbol.test <- eval(parse(text=paste(input,symbol,threshold))) 

        if (symbol.test == TRUE)
          {
            warning("Threshold exceeded. The input will be set to its default value.\n")
            eval.parent(substitute(input <-substitute(default.value)))
          }
      }
  }



##' \description{Plotting 'static' or 'dynamic' plots of two-dimensional data.}
##' \details{The function is the condensate of tests to verify the validity of the algorithm in a two-dimensional search space. The 'dynamic' plot incorporates a contourplot showing the particle movements. The 'delay' value is by default set to 0.3. Setting 'delay' to 'FALSE' makes the plotting device ask for every new plot.  'bestsolution' marks the overall best solution in the plot. 'nextposition'  enables or disables an arrow pointing to the position of a particle in t+1. 'velocity' prints an arrow of the velocity vector of a particle. 'resForce' is the resultant vector of the gravitational force on a particle. 'radius' prints the time dependent radius of action of the forces.}
##' @title plot.RcppGO
##' @param x Data that is returned by the 'RcppGO' function.
##' @param ... Included to comply with the generic plot function arguments. 
##' @param plot.type The plot type can be either 'contour', 'performance', 'wireframe' or 'dynamic'.
##' @param delay The delay between the plot updates.
##' @param bestsolution Indicator of the overall best found solution.
##' @param nextposition The position of a particle in t+1.
##' @param velocity The velocity vector.
##' @param resForce The resultant force vector on a particle.
##' @param radius The time dependent radius around a particle separating the acting forces.
##' @return Return either a 'static' or a 'dynanmic' plot.
##' @author Peter Kehler
plot.RcppGO <- function(x,  
                        ...,
                        plot.type=c("contour", "wireframe", "performance", "dynamic"),
                        delay=0.3,  
                        bestsolution=TRUE,
                        nextposition=FALSE,
                        velocity=FALSE,
                        resForce=FALSE,
                        radius=FALSE
                        )
  {
    options(warn = -1)
    
    # check plot.type
    if (plot.type %in% c("contour", "wireframe", "performance", "dynamic") == FALSE)
      {
        stop("plot.type: \"",plot.type ,"\" is unknown.\n Choose 'contour', 'wireframe', 'performance'or 'dynamic'.")
      }

    # create variables
    GP <- x$GravityParticles
    GM <- x$GMemory
    Args <- x$Args
    Lower <- min(x$Lower)
    Upper <- max(x$Upper)
    n <- x$n
    g <- x$g
    Iterations <- as.integer(x$Iterations)
    User <- x$User
    Scale <- x$Scale
    Maximize <- x$Maximize
    if (Args > 2) stop("Attention: Args > 2.")
    
    # function-wrapper
    fn <- RcppGO.Plot.Wrapper(x$ObjectiveFunction)
    
    # check binary variables
    sanity.check(input=bestsolution,default.type="logical")
    sanity.check(input=nextposition,default.type="logical")
    sanity.check(input=velocity,default.type="logical")
    sanity.check(input=resForce,default.type="logical")
    sanity.check(input=radius,default.type="logical")
    
    # check numeric variables
    # sanity.check(input=delay, symbol="<=", default.type="double", default.value=0.3, threshold=0)

    # radius of charges
    Radius <- function(GP,k)
      {
        if(Scale == TRUE)
          {
            Scale*max(dist(GP[,1:Args,k]))
          } else {
            0.5*(1 - k/Iterations)*max(dist(GP[,1:Args,k]))
          }
      }

    x01 <- seq(Lower,Upper,length.out=50)
    x02 <- seq(Lower,Upper,length.out=50)
    x03 <- outer(x01,x02,fn)

    if (Args == 1)
    {
      plot(fn, xlim=c(Lower, Upper))
    } else 
    {
    
    # dynamic plot
    if (plot.type=="dynamic")
      {
        for (i in 1:(Iterations-1))
          {
            Sys.sleep(delay)
            
            if(delay == TRUE)
              {
                par(ask=TRUE)
              }
          
            image(
              x01,x02,x03,
              col=topo.colors(25),
              sub = paste("Iteration",i,"of",Iterations,"Iterations."),
              main=paste("current best:",round(GP[1,Args+1,i],5),
                "\nOverall best",round(GM[1,Args+1],3))
              )
          
            contour(x01,x02,x03,add=TRUE,nlevels=25)	
          
            
            points(GP[,c("x1","x2"),i],col="red",pch=21,bg="red")
            points(GM[,c("x1","x2")],col="black",pch=22)
            text(
              GP[,c("x1","x2"),i],
              labels=c(1:n),
              cex=1,
              adj=c(0,-0.3)
              )
          
            Rad <- Radius(GP=GP,k=i)
     
            if (bestsolution == TRUE)
              {
                points(x=GM[1,1], y=GM[1,2] , type="p")  
              }
            
            if (nextposition == TRUE)
              {
                arrows(x0=GP[,"x1",i], y0=GP[,"x2",i], x1=GP[,"x1",i+1], y1=GP[,"x2",i+1],lty=2,col="green", lwd =2) 
              }
            
            if (velocity == TRUE)
              {
                arrows(x0=GP[,"x1",i], y0=GP[,"x2",i], x1=GP[,1,i]+GP[,"v_x1",i], y1=GP[,2,i]+GP[,"v_x2",i],lty=2,col="red",lwd=2) 
              }
                       
            if (resForce == TRUE)
              {
                arrows(x0=GP[,"x1",i], y0=GP[,"x2",i], x1=(GP[,1,i]+GP[,"F_x1",i]), y1=(GP[,2,i]+GP[,"F_x2",i]),lty=2,col="blue", lwd =2)
              }
                      
            if (radius == TRUE)
              {
                circles(x=GP[,"x1",i], y=GP[,"x2",i],r=rep(Rad,n))
              }
          }
      }
    
    # wireframe
    if (plot.type=="wireframe")
      {
        Wireframe <- wireframe(x03,
                               shade=FALSE,
                               drape=TRUE,
                               colorkey=TRUE,
                               pretty = TRUE,
                               col.regions=topo.colors(100), 
                               aspect=c(1,0.5),
                               light.source = c(10,0,10),
                               screen = list(x = -70,y = -20, z = 0),
                               xlab=expression(x[1]),
                               ylab=expression(x[2]),
                               zlab=expression(z),
                               nlevel=20,
                               scales = list(arrows = FALSE,
                                 x=list(at=seq(1,50,length.out=11),labels=round(seq(Lower,Upper,length.out=11),1)),
                                 y=list(at=seq(1,50,length.out=11),labels=round(seq(Lower,Upper,length.out=11),1))
                                 )
                               )
        print(Wireframe)
      }
    
    # contour plot
    if (plot.type=="contour")
      {
        Contour <- contourplot(x03,
                               col="blue",
                               xlab=expression(x[1]),
                               ylab=expression(x[2]),
                               cuts= 25,
                               labels= FALSE,
                               region= TRUE,
                               col.regions=topo.colors(100),
                               scales = list(
                                 x=list(at=seq(1,50,length.out=11),labels=round(seq(Lower,Upper,length.out=11),1)),
                                 y=list(at=seq(1,50,length.out=11),labels=round(seq(Lower,Upper,length.out=11),1))
                                 ),
                               add=TRUE
                               )
        print(Contour)
      }


    if (plot.type=="performance")
      {
        # determine position, where GMemory[1,"fn_x"] == GravityParticles[1,"fn_x", ] for the first time

        y.values <- rep(NA, length=Iterations)
        y.values[1] <- GP[1,"fn_x",1]
        
        for (i in 2:Iterations)
          {
            if (Maximize == TRUE)
              {
                if(GP[1,"fn_x",i] >= y.values[i-1])
                  {
                    y.values[i] <- GP[1,"fn_x",i]
                  }
                else
                  {
                    y.values[i] <- y.values[i-1]
                  }
              }
            
            if (Maximize == FALSE)
              {
                if(GP[1,"fn_x",i] <= y.values[i-1])
                  {
                    y.values[i] <- GP[1,"fn_x",i]
                  }
                else
                  {
                    y.values[i] <- y.values[i-1]
                  }
              }
          }

        if(any(is.na(y.values))) stop("An error occurred: Values with 'NA'.\n")
        
        # for now the plot allows only one series
        plot(x= seq(1:Iterations),
             y= y.values,
             xlim= c(1,Iterations),
             ylim= c(min(y.values), max(y.values)),
             main= "performance plot",
             xlab= "iteration",
             ylab= "best solution",
             type="l",
             col="blue",
             lwd=2
             )
      }
    }
    options(warn = 0)
    
  }


