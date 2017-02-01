% script to evaluate descriptors from the Brown dataset

addpath(genpath('./'));

pfolder 		= '/data/patches/';    % brown dataset folder
ofolder 		= pfolder;				  % output folder
dpca_val	   = [80];			% PCA output dimensionality to evaluate for
pw1         = 1.0;			% power-law exponent on initial vectors
pw2         = 0.5;			% power-law exponent on PCA-reduced vectors

load(fullfile(ofolder, 'vecs.mat'), 'vecs');
datasets = {'liberty', 'notredame', 'yosemite'};

% vector post-processing
vecs = cellfun(@(x) vecpostproc(x, pw1), vecs, 'un', 0);

% evaluate each dataset with full vectors
for d = 1:numel(datasets)
	dataset = datasets{d};

  	pairs = load(sprintf('%s/%s/m50_100000_100000_0.txt',pfolder, dataset));
	res = eval_brown (vecs{d}, pairs);
	fprintf('%10s : fpr95 = %.4f\n', dataset, res.fpr_95);	
end
fprintf('\n');	

% evaluate each dataset with PCA
for d = 1:numel(datasets)
	dataset = datasets{d};
  	pairs = load(sprintf('%s/%s/m50_100000_100000_0.txt',pfolder, dataset));

	% use each of the other 2 datasets for learning the PCA
	for d2 = setdiff(1:numel(datasets), d)
		[~, eigvec, eigval, m] = yael_pca(vecs{d2});
		for dpca = dpca_val
			v = vecpostproc(apply_pca(vecs{d}, m, eigvec, dpca), pw2);
			res = eval_brown (v, pairs);

			fprintf('%10s PCA %3dD on %10s : fpr95 = %.4f\n', dataset, dpca, datasets{d2}, res.fpr_95);	
		end
	end

	% use both of the other 2 datasets for learning the PCA
	d2 = setdiff(1:numel(datasets), d);
	[~, eigvec, eigval, m] = yael_pca([vecs{d2(1)}, vecs{d2(2)}]);
	for dpca = dpca_val
		v = vecpostproc(apply_pca(vecs{d}, m, eigvec, dpca), pw2);
		res = eval_brown (v, pairs);	
		fprintf('%10s PCA %3dD on %10s : fpr95 = %.4f\n', dataset, dpca, 'both', res.fpr_95);	
	end
end
