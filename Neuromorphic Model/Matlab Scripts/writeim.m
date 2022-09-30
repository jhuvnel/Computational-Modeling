function s = writeim(varargin)
% WRITEIM - Write a UNC image file (.im)
%
%     WRITEIM(FILENAME, I)
% S = WRITEIM(FILENAME, I)
%
% Where:
%
%   I is the image data.
%   S will contain the header struct.
%
% See Also: READIM
%
% $Id: writeim.m 8 2006-02-07 21:00:44Z mjs $

if nargin < 2 || (~ischar(varargin{1}) || ~isnumeric(varargin{2}))
	disp(sprintf('\nUSAGE:\n\n %s',help(mfilename)));
	return;
end

s=[];

im = varargin{2};

% Transpose M,N to go from Matlab to C pixel ordering

if ndims(im) == 2
	im = permute(im, [2,1]);
else
	im = permute(im, [2,1,3]);
end

if nargout == 0
	im_mex(deblank(varargin{1}), im);
elseif nargout == 1
	s = im_mex(deblank(varargin{1}), im);
end
