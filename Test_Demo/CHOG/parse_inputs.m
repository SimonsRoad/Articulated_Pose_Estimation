function [ A, Ar, Ac, Arid, Atheta, Center, Class, Bin ] = parse_inputs( varargin )
%PARSE_INPUTS 此处显示有关此函数的摘要
%   此处显示详细说明

error(nargchk(3,6,nargin));

A = varargin{1};

Ar = size(A,1);
Ac = size(A,2);
Class = class(A);

Arid = varargin{2};
Atheta = varargin{3};

if nargin < 4
    Center = [];
else
    Center = varargin{4};
end
if isempty(Center)
    Center = [(Ac+1)/2 (Ar+1)/2];
    Center = floor(Center);
end
if nargin < 5
    Bin = 8;
else
    Bin = varargin{5};
end
if isempty(Bin)
    Bin = 8;
end

if isa(A, 'uint8')
    if islogical(A)
        A = double(A);
    else
        A = double(A)/255;
    end
end

end

