set terminal epslatex color colortext
set output "graphics/aluffi02.tex"


# set terminal pngcairo  transparent enhanced font "arial,10" fontscale 1.0 size 500, 350
# set output 'contours.18.png'
set view 60, 30, 1.3, 1.1
set samples 25, 25
set isosamples 26, 26
set contour base
set cntrparam bspline
#set title "$f(x,y)=\\frac{1}{4} x^4 - \\frac{1}{2}x^2 + \\frac{1}{10}x + \\frac{1}{2}y^2$"
set xlabel "x"
set ylabel "y"
set zlabel "f(x,y)"
set zlabel  offset character 1, 0, 0 font "" textcolor lt -1 norotate
splot [-2:2] [-2:2] (x**4)/4 - (x**2)/2 + x/10 + (y**2)/2  title "$f(x,y)=\\frac{1}{4} x^4 - \\frac{1}{2}x^2 + \\frac{1}{10}x + \\frac{1}{2}y^2$"
