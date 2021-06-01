### What is RcppGO?
**RcppGO** is an agent based optimization package for **R** written in **C++** aiming at "difficult" optimization problems. **[...] Optimization algorithms are guided by objective functions. A function is difficult from a mathematical perspective in this context if it is not continuous, not differentiable, or if it has multiple maxima and minima.** _(Weise, T., (2009). Global Optimization Algorithms – Theory and Application, p.56)_ 

The **RcppGO** algorithm is based on _Kaveh, A. and Talatahari, (2010). A Novel Heuristic Optimization Method: Charged System Search. Acta Mechanica, 213(3-4):267–289._

### What are the key features?
**RcppGO** 
* applicable to difficult objective functions,
* is fast due to the implementation in **C++** using the [**Armadillo**](http://arma.sourceforge.net/docs.html) library, 
* is easy to use within **R**,
* is open-source under GPL-2.0 License.

### Advantages
**RcppGO** can be used to solve objective functions meeting the following criteria. The objective function
* is non-continuous, 
* has prohibited zones,
* has side-limits,
* is non-smooth,
* is non-convex.  
* The algorithm doesn't require a good starting point. 

### Disadvantages
Due to its stochastic approach, the results of the algorithm are also stochastic. Continuous optimization problems will converge faster and most likely produce results with higher accuracy using gradient-based methods. 

### How do I try it 
In order to try the **RcppGO** package follow the INSTALLATION instructions. You can find examples and a minimal how-to in the "tests" folder of the package.

### Minimal Example
```R
library(RcppGO)

# define objective function
AluffiPentiny02 <- function(X)
{
  1/4*X[,1]^4 - 1/2*X[,1]^2 + 1/10*X[,1] + 1/2*X[,2]^2
}

# solve objective function
Example <- RcppGO(ObjectiveFunction=AluffiPentiny02, Args=2, Lower = -10, Upper = 10)

# show results
Example$GMemory

# plot dynamic agent based search
plot(x=Example, plot.type="dynamic", nextposition = TRUE)
```
### Example Plots
![Agents exploring the search space](https://github.com/peterkehlerjr/RcppGO/blob/master/vignettes/figure/Movement.png)
![Aluffi01](https://github.com/peterkehlerjr/RcppGO/blob/master/vignettes/figure/AluffiPentiny01.png)

### Supported OS
* Linux (works)
* OS X (works, requires a recent version of Xcode and an "Apple version" of gfortran though) 
* Windows (not tested)

### Author
Peter Kehler
