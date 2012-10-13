##' \description{}  
##'
##'  \details{} 
##' @title RcppGO.Plot
##' @param RcppGO.Data Data from gRaviOpt.
##' @param Delayed If 'Particle_Sim' is 'TRUE' consecutive plots are delayed by 'Delayed' seconds.
##' @param Particle_Sim If 'TRUE' the particle movements are shown.
##' @param Physics If 'TRUE' force vectors are shown.
##' @param ... Additional/advanced graphic parameters.
##' @return The function optionally returns a static or a dynamic plot.
##' @author Peter Kehler


RcppGO.Plot <- function(RcppGO.Data, 	
                       	Delayed=0.3,						
                        Particle_Sim=FALSE,
			Physics=TRUE,
			...		
                        )
{
  options(warn = -1)
  
  GP <- RcppGO.Data$GravityParticles
  GM <- RcppGO.Data$GMemory
  Args <- RcppGO.Data$Args
  Lower <- min(RcppGO.Data$Lower)
  Upper <- max(RcppGO.Data$Upper)
  n <- RcppGO.Data$n
  g <- RcppGO.Data$g
  Iterations <- as.integer(RcppGO.Data$Iterations)
  User <- RcppGO.Data$User
  Scale <- RcppGO.Data$Scale
  Maximize <- RcppGO.Data$Maximize
  if (Args != 2) stop("Args must be 2 for a plot.")

  
  # function-wrapper
  fn <- RcppGO.Plot.Wrapper(RcppGO.Data$ObjectiveFunction)

  
  # check for "lattice" package
  PackageRectifier("lattice","gRavioptRcpp.Plot")
  
  
  # check binary variables
  BinaryRectifier(Particle_Sim)
  BinaryRectifier(Physics)
  
  
 # radius of charges: "a" in the article
  Radius <- function(GP,k)
    {
      if(Scale == TRUE){
        Scale*max(dist(GP[,1:Args,k]))
      } else {
        0.5*(1 - k/Iterations)*max(dist(GP[,1:Args,k]))
      }
    }
 
  x <- seq(Lower,Upper,length.out=50)
  y <- seq(Lower,Upper,length.out=50)
  z <- outer(x,y,fn)
  
  
  if(Particle_Sim==FALSE)
    {
      
      Wireframe <- wireframe(z,
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
                             panel.3d.wireframe="panel.3d.contour",
                             scales = list(arrows = FALSE,
                               x=list(at=seq(1,50,length.out=11),labels=round(seq(Lower,Upper,length.out=11),1)),
                               y=list(at=seq(1,50,length.out=11),labels=round(seq(Lower,Upper,length.out=11),1))
                               )
                             )
      
      Contour <- contourplot(
                             z,
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
                               )
                             )
      
      print(Wireframe,position=c(0.1,0.1,1,1),split=c(1,1,2,1),more=TRUE)
      print(Contour,position=c(0.1,0.1,1,1),split=c(2,1,2,1),more=FALSE)
      
    }	
  
  
  if(Particle_Sim==TRUE)
    {
      for (i in 1:(Iterations-1))
        {
          Sys.sleep(Delayed)
          
          if(Delayed == TRUE){
            par(ask=T)
        }
          
          image(
                x,y,z,
                col=topo.colors(25),
                sub = paste("Iteration",i,"of",Iterations,"Iterations."),
                main=paste("current best:",round(GP[1,Args+1,i],5),
                  "\nOverall best",round(GM[1,Args+1],3))
                )
          
        contour(x,y,z,add=TRUE,nlevels=25)	
          
# todo: lattice implementation of particle movements
# contourplot(
# z,
# col="blue",
# main=paste("Iteration",i,"of",Iterations,"Iterations."),
# #sub=paste("Best solution in step",i,"of",Iterations,"is",round(GP[1,Args+1,i],6),"\nbest",round(GM[1,Args+1]))),
# xlab=expression(x[1]),
# ylab=expression(x[2]),
# cuts= 25,
# labels= TRUE,
# region= TRUE,
# col.regions=topo.colors(100)
# )
          
          
          points(GP[,c("x1","x2"),i],col="red",pch=21,bg="red")
          points(GM[,c("x1","x2")],col="black",pch=22)
          text(
               GP[,c("x1","x2"),i],
               labels=c(1:n),
               cex=1,
               adj=c(0,-0.3)
               )
          
          Rad <- Radius(GP=GP,k=i)
          
          if(Physics == TRUE)
            {
              circles(x=GP[,"x1",i], y=GP[,"x2",i],r=rep(Rad,n))
                                        # force
              arrows(x0=GP[,"x1",i], y0=GP[,"x2",i], x1=(GP[,1,i]+GP[,"F_x1",i]), y1=(GP[,2,i]+GP[,"F_x2",i]),lty=2,col="blue", lwd =2) 
                                        # velocity
              arrows(x0=GP[,"x1",i], y0=GP[,"x2",i], x1=GP[,1,i]+GP[,"v_x1",i], y1=GP[,2,i]+GP[,"v_x2",i],lty=2,col="red",lwd=2) 
                                        # new positions
              arrows(x0=GP[,"x1",i], y0=GP[,"x2",i], x1=GP[,"x1",i+1], y1=GP[,"x2",i+1],lty=2,col="green", lwd =2) 
            }
          
          
        }
    }
  options(warn = 0)
}

# Experimental
# plot.new()
# plot.window(c(2,2),c(2,2))
# legend("topleft",title="Legend",c(expression(sum(F[i], i==1, n)),expression(V[i]),expression(X[i+1]),"best results"),lty=c(2,2,2,NA),pch=c(NA,NA,NA,22),col=c("blue","red","green","black"),bg="white")
# mtext(paste("current best result:\n",round(GP[1,Args+1,i],6),"\nOverall best result\n",round(GM[1,Args+1])),side=3, line=-20)

