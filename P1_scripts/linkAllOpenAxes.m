% Script to link all axes of open plots

myAxes = findall(groot,'type','axes');
linkaxes(myAxes,'x')