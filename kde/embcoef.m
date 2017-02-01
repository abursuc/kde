% Fourier coefficients for the normalized Von Mises function
%
% Usage: an = embcoef (kappa, n)
%
%   n: number of frequencies
%   kappa: von mises shape parameter
%   an : Fourier coefficients
% 
% Author: Herve Jegou, 2014.
function an = embcoef (kappa, n)

C = 0.5 * (besseli(0,kappa)-exp(-kappa)) / sinh(kappa);
an = besseli([1:n],kappa)'./sinh(kappa)';
an = [C; an];