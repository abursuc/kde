% Code for the method presented in the paper 
% A. Bursuc, G. Tolias, and H. Jegou, ICMR 2015, Kernel Local Descriptors with Implicit Rotation Matching
% This version of the code includes minor bug fixes and produces slightly better performance than in our paper
%
% Authors: A. Bursuc, G. Tolias, H. Jegou. 2015. 
%
% script to extract descriptors from the Brown dataset
%
addpath(genpath('./'));

pfolder 		=  '/data/patches/';    % brown dataset folder
ofolder 		=  pfolder;				  % output folder
s 			=  64;   % patch size
kapparho 		=  8;		% kappa for kernel on rho (radius in polar coordinates)
kappaphi		=  8;		% kappa for kernel on phi (angle in polar coordinates)
kappatheta		=  8;		% kappa for kernel on theta (relative gradient angle)
nrho 			=  2;		% number of frequencies for approx. of kernel on rho  
nphi			=  2;		% number of frequencies for approx. of kernel on phi
ntheta			=  3;		% number of frequencies for approx. of kernel on theta

% coefficients for the individual embeddings
crho 		= embcoef(kapparho, nrho);
cphi 		= embcoef(kappaphi, nphi);
ctheta 	= embcoef(kappatheta, ntheta);

% pre-compute phi-otimes-rho embedding for 64x64 patch pixels
[epos, phi] = embfixedpos(cphi, crho, s);
pre.epos = epos; pre.phi = phi;

if exist([pfolder, '/liberty/'], 'file') ~= 7 | exist([pfolder, '/notredame/'], 'file') ~= 7 | exist([pfolder, '/yosemite/'], 'file') ~= 7
	system('wget http://cmp.felk.cvut.cz/~toliageo/ext/brown/data.tar.gz --directory-prefix /tmp/'); 
	if exist(pfolder, 'file') ~=7, mkdir(pfolder); end 
	system(sprintf('tar -xzvf /tmp/data.tar.gz -C %s', pfolder));
end

datasets = {'liberty', 'notredame', 'yosemite'};
for d = 1:numel(datasets)
	dataset = datasets{d};
	fprintf('Dataset %s\n', dataset);
	patches = load_ext(fullfile(pfolder, dataset, [dataset, '_patches.fvecs']));

	parfor i = 1:size(patches, 2)
		patch = patches(:, i);
		patch = reshape(patch, s, s);
		% Kernel DEscriptor (KDE) extraction
		v{i} = kde(patch, pre, ctheta);
	end
	% collect all dataset vectors
	vecs{d} = cell2mat(v);
end

save(fullfile(ofolder, 'vecs.mat'), 'vecs');
