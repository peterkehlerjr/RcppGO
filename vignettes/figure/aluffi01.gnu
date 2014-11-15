# run via M-x gnuplot-run-buffer or C-x p

#set terminal postscript enhanced color
#set output '| ps2pdf - plot.pdf'

#set terminal epslatex standalone color colortext

set terminal epslatex color colortext
set output "graphics/aluffi01.tex"

set xlabel "x"
set ylabel "f(x)"

f(x) = (x**4)/4 + x/10 
g(x) =  10
plot [-2:2]  f(x) with lines lw 5 title "$f(x)=\\frac{1}{4} x^4  + \\frac{1}{10}x $" #, \
     #g(x) with lines lw 5 title "$g(x)=10$"
