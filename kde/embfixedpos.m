% embedding encoding polar coordinates for fixed patch pixel positions
%
% Usage: [epos, phi] = embfixedpos(cphi, crho, s)
%
%   cphi : embedding coefficients for phi
%   crho : embedding coefficients for rho
%   s 	: patch size
%   epos : embeddings for all pixel positions
%   phi  : angle phi for all pixels
% 
% Author: Andrei Bursuc, 2015. 
function [epos, phi] = embfixedpos(cphi, crho, s)

	% fixed grid of the patch
	xx = (-(s-1):2:s-1);
	yy = xx';
	xx = repmat(xx, [s 1]);
	yy = repmat(yy, [1 s]);  
	xx = xx(:);
	yy = yy(:);

	% polar coordinates
	[phi, rho] = cart2pol(xx, yy);
	rho = rho ./ s;

	% embeddings for rho and phi
	ephi = angle2vec(cphi, phi(:)');
	erho = angle2vec(crho, rho(:)'*pi/2);

	% pre-compute phi-rho kronecker
	epos = zeros(size(erho,1)*size(ephi,1),size(ephi,2));
	for i = 1:size(ephi,2)
	   epos(:,i) = kron(ephi(:,i), erho(:,i));   
	end

	% apply the gaussian mask
	epos = bsxfun(@times, epos', exp(-rho(:).^2))';