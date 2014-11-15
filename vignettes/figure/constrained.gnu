# run via M-x gnuplot-run-buffer or C-x p

#set terminal postscript enhanced color
#set output '| ps2pdf - plot.pdf'

#set terminal epslatex standalone color colortext

set terminal epslatex color colortext
set output "graphics/constrained.tex"

f(x) = (x**4)/4 - (x**2)/2 + x/10 + (x**2)/2
g(x) =  2*x
plot [-2:2]  f(x) with lines lw 5 title "$f(x)=\\frac{1}{4} x^4 - \\frac{1}{2}x^2 + \\frac{1}{10}x + \\frac{1}{2}x^2$", \
     g(x) with lines lw 5 title "$g(x)=2x$"
