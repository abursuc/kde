% simple test extracting KDE (KErnel Descriptor) from a 64x64 patch

addpath(genpath('./'));

s 				=  64;   % patch size
kapparho 	=  8;		% kappa for kernel on rho (radius in polar coordinates)
kappaphi		=	8;		% kappa for kernel on phi (angle in polar coordinates)
kappatheta	=	8;		% kappa for kernel on theta (relative gradient angle)
nrho 			=  1;		% number of frequencies for approx. of kernel on rho  
nphi			=	3;		% number of frequencies for approx. of kernel on phi
ntheta		=	3;		% number of frequencies for approx. of kernel on theta

% coefficients for the individual embeddings
crho 		= embcoef(kapparho, nrho);
cphi 		= embcoef(kappaphi, nphi);
ctheta 	= embcoef(kappatheta, ntheta);

% pre-compute phi-otimes-rho embedding for 64x64 positions
[epos, phi] = embfixedpos(cphi, crho, s);
pre.epos = epos; pre.phi = phi;

patch = imresize(im2double(rgb2gray(imread('peppers.png'))), [s s]);
% descriptor extraction
v = kde(patch, pre, ctheta);