function result = AngleMod180(ang)
% AngleMod180 - a MATLAB m-file version of utility code found in
% ssest_filter.c
% Adapted by C. Beal
% Date: 6/26/2018

result = mod(ang + 180, 360);
result = result + 360*(result < 0);
result = result - 180;