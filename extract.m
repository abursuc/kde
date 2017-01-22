% extract descriptors from the Brown dataset
addpath(genpath('./'));

pfolder 		= '/mnt/lascar/toliageo/datasets/patches/';    % brown dataset folder
ofolder 		= '/mnt/lascar/toliageo/projects/kde/';		  % output folder
s 				=  64;   % patch size
kapparho 	    =  8;		% kappa for kernel on rho (radius in polar coordinates)
kappaphi		=	8;		% kappa for kernel on phi (angle in polar coordinates)
kappatheta	    =	8;		% kappa for kernel on theta (relative gradient angle)
nrho 			=  2;		% number of frequencies for approx. of kernel on rho  
nphi			=	2;		% number of frequencies for approx. of kernel on phi
ntheta		    =	3;		% number of frequencies for approx. of kernel on theta
sge			    = 	150;

% coefficients for the individual embeddings
crho 		= embcoef(kapparho, nrho);
cphi 		= embcoef(kappaphi, nphi);
ctheta 	= embcoef(kappatheta, ntheta);

% pre-compute phi-otimes-rho embedding for 64x64 patch pixels
[epos, phi] = embfixedpos(cphi, crho, s);
pre.epos = epos; pre.phi = phi;

p=gcp('nocreate');if isempty(p),poolsize=0;else,poolsize=p.NumWorkers;end;if sge&poolsize~=sge,delete(p);parpool(sge);end

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
