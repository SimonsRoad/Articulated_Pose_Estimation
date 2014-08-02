function chog = extractCHOG( varargin )
%EXTRACTCHOG 此处显示有关此函数的摘要
%   此处显示详细说明
[Image, rows, cols, NRid, Ntheta, Center, ClassIn, Bin] = parse_inputs(varargin{:});

stepx = ceil(rows/Bin);
stepy = ceil(cols/Bin);
rows = stepx*Bin;
cols = stepy*Bin;

Image = padarray(Image,[rows cols]);

sizeZ = 3 * floor(2*pi/Ntheta+0.5) + 1;
chog = zeros(stepx, stepy, sizeZ*9);

for i = 1:stepx
    for j = 1:stepy
        chog(i,j,:) = extractRGT(Image, Bin, Bin, NRid, Ntheta, [Bin/2+(i-1)*Bin Bin/2+(j-1)*Bin]);
    end
end

end

