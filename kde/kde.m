% compute kernel descriptor for a patch
%
% Usage: v = kde(patch, pre, ctheta)
%
%   patch  : image patch
%   pre    : precomputed embeddings and phi for fixed patch pixels
%   ctheta : embedding coefficients for theta
%   v      : kernel descriptor (l2 normalized)
% 
function v = kde(patch, pre, ctheta)

% gaussian smoothing 
if exist('vl_imsmooth')
	patch = vl_imsmooth(patch, 1.4); %vl_feat was used in the paper
else
	patch = imfilter(patch, fspecial('gaussian', [5 5], 1.4), 'same', 'replicate');
end
% patch gradients
[mag, theta] = gradpatch(patch);    

% theta embedding
etheta = angle2vec(ctheta, theta(:)' - pre.phi');
% weight by magnitude, modulate, and aggregate
v = ((repmat(sqrt(mag(:)), 1, size(etheta, 1))') .* etheta) * pre.epos';
% vector l2 normalize
v = v(:) ./ sqrt(sum(v(:).^2));
