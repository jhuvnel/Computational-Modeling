function [i,s] = readim(varargin)
% READIM - Read a UNC image file (.im)
%
%     I = READIM(FILENAME)
% [I,S] = READIM(FILENAME)
%
% Where:
%
%   I will contain the image data.
%   S will contain the header struct.
%
% See Also: WRITEIM
%
% $Id: readim.m 8 2006-02-07 21:00:44Z mjs $

if nargin < 1 | ~ischar(varargin{1})
	disp(sprintf('\nUSAGE:\n\n %s',help(mfilename)));
	return;
end

s = [];

if nargout == 2
	[i,s] = im_mex(deblank(varargin{1}));
elseif nargout == 1
	i = im_mex(deblank(varargin{1}));
end

% Permute the rows and columns to go from C to Matlab pixel
% ordering.

if ndims(i) == 2
	i = permute(i, [2,1]);
else
	i = permute(i, [2,1,3]);
end

% Convert it to double (Matlab's default, IP toolbox doesn't support single)

i = double(i);
