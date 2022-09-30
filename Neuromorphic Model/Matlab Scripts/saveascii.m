function varargout = saveascii(x,xfile,varargin)
%SAVEASCII   Saves the matrix columns with a specified ascii format.  
%   SAVEASCII(X,XFILE) saves the matrix X in the file XFILE (string) with   
%   the default format '% 8.7e' (or '%c' if X is text) and the default   
%   delimiter '\t' for each column (or '' nothing if X is text). If  
%   XFILE=[], prints the matrix string on the Command Window (convert it to   
%   numbers via STR2NUM). The data may be retrieved with LOAD: 
%   X = LOAD(XFILE). The options are:  
%  
%   SAVEASCII(X,XFILE,XFORMAT) saves the matrix with the specified ascii  
%   format. Default '% 8.7e' or '%c' if X is text.  
%  
%   SAVEASCII(X,XFILE,XFORMATN) saves the N columns of the matrix with the   
%   specified ascii format of each one. Default '%8.7e\t%8.7e\t ...
%   %8.7e\t%8.7e', i.e. N-times '% 8.7e' or '%c' if X is text. Other way
%   could be '%-1.0f %3.1f  ... %+8.7E %4.0E'.   
%  
%   SAVEASCII(X,XFILE,XF1,...,XFN) saves each of the N columns with his  
%   specified format. Same as before, but the format of each column is  
%   specified separately.  
%  
%   SAVEASCII(X,XFILE,XDECIMALS) where XDECIMALS is a 1xN vector of
%   integers, saves each of the columns in floating-point format with the  
%   specified number of decimals for each column. If XDECIMALS is only one  
%   number, the whole matrix is saved with the same format. This is useful  
%   when the user:  
%      1. Wants something easier than the last two options.  
%      2. Doesn't know about formats.  
%      3. Doesn't know the number of digits to the dot's left.  
%    and the matrix is a numeric array. Note: if decimals are negatives the
%   columns are rounded to the left of the point.  
%  
%   SAVEASCII(X,XFILE,'a') appends the matrix to the XFILE. Others modes
%   for open the file are 'w', 'at', 'wt'. Windows works better with 't',
%   and Linux doesn't care so it is always added. Default 'wt' overwrites!,
%   CAREFUL because in each run the XFILE its cleared!  
%  
%   SAVEASCII(X,XFILE,XDELIMITER) saves the matrix with the specified 
%   string delimiter. Space and comma for example: ', '. Default tab '\t'   
%   or nothing '' if X is text. Should not be a single 'a' or 'w', if
%   needed use 'aa' or 'ww'.  
%  
%   SAVEASCII(X,XFILE,XD1,...,XDN-1) strings specifying the delimiter
%   between each column. Useful when writing dates: 2007/01/21 12:00:00.
%   Default tabs '\t' or nothing '' if X is text.  
%  
%   SAVEASCII(X,XFILE,...,'@S') saves the matrix with the specified string   
%   S at the begining of each line. Comment for example: '@%% '. Must
%   begin with '@'. Default none.  
%  
%   Y = SAVEASCII(X,...) output the saved matrix string into Y. Useful when
%   rounding each column in the specified format, but the user must use Y =
%   STR2NUM(Y) to get a non string matrix.  
%
%   Example:
%      x = [     1          2  -1234.5678  12345.6789 
%              6e7       6e-5        6e-6        -6e3  
%             .008  -987.3456     0.00045          pi  ];
%      save 'x.dat' x -ascii
%      saveascii('% Top, Matlab''s save ascii (can''t append)','x.dat','a')
%      saveascii(['                 '; '% Same as before:'],'x.dat','a')
%      saveascii(x,'x.dat',' ','@ ','a')    
%      saveascii('% Cleaner:','x.dat','a')
%      saveascii(x,'x.dat','%18.8f','a') 
%      saveascii('% Better?:','x.dat','a')
%      saveascii(x,'x.dat','%12.3f','%10.5f','%12.6f','%13.7f',' ','a')
%      saveascii('% Prints here!',[],'a')
%      saveascii(x,[],[3 5 6 7])
%      saveascii('% Easier:','x.dat','a')
%      y = saveascii(x,'x.dat',[3 5 6 7],',   ','a'), y = str2num(y)
%      saveascii('% Delimiters?','x.dat','a')
%      saveascii(x,'x.dat',3,5,6,7,':','N, ','aam ','a','@A: ')
%      saveascii('% Weird time and coordinates:','x.dat','a')
%      saveascii(x,'x.dat','%012.3f:%010.5f %12.6fN %13.7fW','a')
%      saveascii('% All equal:','x.dat','a')
%      saveascii(x,'x.dat',2,' ','a');
%      saveascii('% Little different:','x.dat','a')
%      saveascii(x,'x.dat',2,2,2,2,' ','a')
%
%   See also SAVE, FPRINTF, SPRINTF, DLMWRITE, CSVWRITE, FOPEN, STR2DOUBLE,
%   STR2NUM, NUM2STR

%   Written by
%   M.S. Carlos Adrian Vargas Aguilera
%   Physical Oceanography PhD candidate
%   CICESE 
%   Mexico, 2004-2006-2007
%
%   nubeobscura@hotmail.com

%   2004 - matrix format (only 3 lines!)
%   2006 - distinguish columns
%   2007 - decimals for floating-point, 'wt', output, string input

% No inputs?:
if nargin<1
 error('Saveascii:ArgumentsNumber',...
  'Number of arguments must be at least 1.')
end

% Defaults:
X.mode       = 'wt';     % "t"ext better por Windows. Linux doesn't care.
X.delimiter  = '\t';     % Tab. Try ' '.
X.begin      = '';       % Empty. 
X.format     = '% 8.7e'; % Ugly, but matlab seems to like it, do you?
X.decimals   = [];       % Empty. Try 7 (X.format is ignored, good idea?).
X.specifier  = 'f';      % Floating-point. Works when decimals are used.
if ischar(x)
 X.delimiter = '';       % If just text, nothing between chars.
 X.format    = '%c';     % Text format.
end

% Read matrix:
X.x = x;
if (ndims(X.x) > 2)
 error('Saveascii:ArgumentType','Input matrix must be 2-D.')
end
clear x

% Read file:
if nargin>1 
 if ischar(xfile) % Output in a file?
  X.file = xfile;
 elseif isempty(xfile)
  X.file = [];
 else
  error('Saveascii:ArgumentType','The output file must be a string.')
 end
end
clear xfile

% Read and check options:
X.opt = varargin;
clear varargin
X = check_entries(X);

% Saving:
if ~isempty(X.file) 
 archivo = fopen(X.file,X.mode);
 fprintf(archivo,X.format, X.x.');
 fclose(archivo);
end

% Printing:
if nargout
 % Output string matrix:
 Nr = size(X.x,1);
 s = sprintf(X.format,X.x.');
 s = reshape(s,numel(s)/Nr,Nr);
 s = s(1:end-1,:)';
 varargout{1} = s;
 clear s
elseif isempty(X.file)
 Nr = size(X.x,1);
 s = sprintf(X.format,X.x.');
 s = reshape(s,numel(s)/Nr,Nr);
 s = s(1:end-1,:)';
 disp(s)
 clear s
end


%##########################################################################


function X = check_entries(X)
% Reads the options.

% Number of columns:
Nc = size(X.x,2);

% Default with decimals?
if ~isempty(X.decimals) && isnumeric(X.x)
 X.decimals = repmat(X.decimals(1),1,Nc);
 X.chars = get_digits(X.x,X.decimals);
end

% Number of options:
No = length(X.opt);

% DECIMALS:
Notemp = No;
if No>0 && ~iscellstr(X.opt)
 
 %Get decimals input:
 inum = zeros(1,No);
 for k = 1:No
  inum(k) = isnumeric(X.opt{k});
 end
 inum = logical(inum);
 nN = sum(inum); nD = 0;
 Notemp = No-nN;
 if nN == 1
  nD = numel(cell2mat(X.opt(inum)));
  if nD == 1
   X.decimals = repmat(X.opt{inum},1,Nc);
  elseif nD == Nc
   X.decimals = X.opt{inum};
  else
   error('Saveascii:ArgumentSize',...
    ['You give ' int2str(nD) ' decimals and have ' int2str(Nc) ' columns.'])
  end
 elseif nN == Nc
  X.decimals = cell2mat(X.opt(inum));
  mN = numel(X.decimals);
  if mN~=Nc
   error('Saveascii:ArgumentSize',...
    ['You give ' int2str(mN) ' decimals and have ' int2str(Nc) ' columns.'])
  end
 else
  error('Saveascii:ArgumentSize',...
    ['You give ' int2str(nN) ' decimals and have ' int2str(Nc) ' columns.'])
 end

 % Get number of digits of each row:
 X.chars = get_digits(X.x,X.decimals);
 if nD==1 % Only one number => the columns are equally formated:
  X.chars = repmat(max(X.chars),size(X.chars));
 end
 
end

% Clear decimal inputs:
if No ~= Notemp
 No = Notemp;
 X.opt(inum) = [];
end

% FORMATS, DELIMITERS, BEGINER and MODE:
X.delimitercell = [];
X.formatcell = [];
Nf = 0;
if No>0
 m = strmatch('a',X.opt);              % mode append or write?
 n = strmatch('w',X.opt); if n, m=n; end
 b = strmatch('@',X.opt);              % begin?
 f = strmatch('%',X.opt);              % format?
 d = setdiff(1:No,[f(:); m(:); b(:)]); % delimiters?
 if ~isempty(m) % mode:
  itemp = [];
  for i = 1:length(m) % force modes: 'a','w','at','wt','a+','w+'
   if (length(X.opt{m(i)})>1) && ((length(X.opt{m(i)})>2) || ...
     (~strcmpi(X.opt{m(i)}(2),'+') && ~strcmpi(X.opt{m(i)}(2),'t')))
    itemp = [itemp i];
    d = union(d,m(i));
    X.opt{m(i)}(1) = [];
   end
  end
  m(itemp) = [];
  if ~isempty(m) && length(m)~=1 
   error('Saveascii:ArgumentSize',...
    ['You give ' int2str(length(m)) ' MODES and must be just one.'])
  elseif ~isempty(m)
   X.mode = X.opt{m};
   if length(X.mode)==1
    X.mode = [X.mode 't']; % For Windows, Linux doesn't care.
   end
  end
 end
 if ~isempty(b) % begin:
  if length(b)~=1 
   error('Saveascii:ArgumentSize',...
    ['You give ' int2str(length(b)) ' BEGINERS ''@'' and must be just one.'])
  end
  X.begin = X.opt{b}(2:end); 
 end
 if ~isempty(d) % delimiters between columns:
  if length(d)==1
   X.delimiter = X.opt{d};
  elseif length(d)==Nc-1
   X.delimitercell = X.opt(d); 
  else
   error('Saveascii:ArgumentSize',...
    ['You give ' int2str(length(d)) ' DELIMITERS and must be 1 or ' int2str(Nc-1) '.'])
  end
 end
 if ~isempty(f) && isempty(X.decimals) % formats of each column:
  if (length(f)==1) && (numel(strfind(X.opt{f},'%'))==1)
   X.format = X.opt{f};
  elseif length(f)==Nc 
   X.formatcell = X.opt(f);
  elseif (length(f)~=1)
   error('Saveascii:ArgumentSize',...
    ['You give ' int2str(length(f)) ' FORMATS ''%%...'' and must be 1 or ' int2str(Nc) '.'])
  end
  Nf = length(f);
 end
end

% FORMAT CONSTRUCTION:
if ~isempty(X.decimals) % from decimals:
 % Make sure input is an integer:
 if any(~isnatural(X.decimals(:)))
  error('Saveascii:FormatType','Decimal(s) must be integer(s).')
 end 
 neg = find(X.decimals(:)<0);
 if ~isempty(neg)
  A = 10.^X.decimals(neg);
  A = repmat(A(:)',size(X.x,1),1);
  X.x(:,neg) = round(X.x(:,neg).*A)./A;
  X.decimals(neg) = 0;
  X.chars(neg) = get_digits(X.x(:,neg),X.decimals(neg));
 end
 X.format = ['%' int2str(X.chars(1)) '.' int2str(X.decimals(1)) X.specifier];
 if ~isempty(X.delimitercell) % Diferent delimiters:
  for i = 1:Nc-1
   X.format = [X.format X.delimitercell{i} '%' int2str(X.chars(i+1)) '.' ...
    int2str(X.decimals(i+1)) X.specifier];
  end
 else % Single delimiter:
  for i = 2:Nc
   X.format = [X.format X.delimiter '%' int2str(X.chars(i)) '.' ...
    int2str(X.decimals(i)) X.specifier];
  end
 end
elseif Nf==1 && (numel(strfind(X.opt{f},'%'))==Nc) % Super format:
 X.format = X.opt{f};
 if ~isempty(d)
  warning('Saveascii:FormatType','Ignored specified delimiter(s).')
 end
elseif ~isempty(X.delimitercell) % Diferent delimiters:
 if ~isempty(X.formatcell) % Diferent formats:
  X.format = X.formatcell{1};
  for i=1:Nc-1
   X.format = [X.format X.delimitercell{i} X.formatcell{i+1}];
  end
 else % Single format:
  for i=1:Nc-1
   X.format = [X.format X.delimitercell{i} X.format];
  end
 end
 elseif ~isempty(X.formatcell) % Single delimiter, diferent formats:
  X.format = X.formatcell{1};
  for i=1:Nc-1
   X.format = [X.format X.delimiter X.formatcell{i+1}];
  end
else % Single delimiter and format:
 X.format = [X.format repmat([X.delimiter X.format],1,Nc-1)];
end

% Adds begginer and carret char:
X.format = [X.begin X.format '\n'];


function chars = get_digits(x,decimals)
% Get the digits of each column for the floating-point format:

if ~isnumeric(x)
 error('Saveascii:ArgumentType',...
  'You give decimals but not a numeric array.')
end
temp = warning('off','MATLAB:log:logOfZero');
M = floor(log10(abs(x)))+1; % order(10eM) + 1
warning(temp.state,'MATLAB:log:logOfZero')
chars = max(M,[],1); chars(~isfinite(chars)) = 1;
for i = 1:length(chars)
 Mi = (M(:,i)==chars(i));
 % Add sign if negative, and decimals plus dot:
 chars(i) = chars(i) + any(x(Mi,i)<0) + (decimals(i)+1)*(decimals(i)>0); 
end

function yes = isnatural(n)
%ISNATURAL   Checks if an array has natural numbers.
%   Y = ARENATURAL(X) returns an array of the same size as X with ones in
%   the elements of X that are natural numbers (...-2,-1,0,1,2,...), and 
%   zeros where not.

%   Written by
%   M.S. Carlos Adrián Vargas Aguilera
%   Physical Oceanography PhD candidate
%   CICESE 
%   Mexico, november 2006
% 
%   nubeobscura@hotmail.com

yes = (n==floor(n)).*(isreal(n));

% Carlos Adrian Vargas Aguilera. nubeobscura@hotmail.com
