function rout = extractRIFF( varargin )
%EXTRACTRIFF 此处显示有关此函数的摘要
%   此处显示详细说明

[Image, rows, cols, NRid, Ntheta, Center, ClassIn] = parse_inputs(varargin{:});

threeD = (ndims(Image==3));

if threeD
    Imr = Image(:,:,1);
    Img = Image(:,:,2);
    Imb = Image(:,:,3);
    r = extractRGT(Imr, rows, cols, NRid, Ntheta, Center);
    g = extractRGT(Img, rows, cols, NRid, Ntheta, Center);
    b = extractRGT(Imb, rows, cols, NRid, Ntheta, Center);
 
    if strcmp(ClassIn, 'uint8')
        rout = uint8(round(r*255));
        g = uint8(round(g*255));
        b = uint8(round(b*255));
        figure(1);
        imshow(rout);
        figure(2);
        imshow(g);      
        figure(3);
        imshow(b);
    else
        rout = r;
    end
else
    r = extractRGT(Image, rows, cols, NRid, Ntheta, Center);
    if nargout == 0
        imshow(r);
        return;
    end
end

if strcmp(ClassIn,'uint8')
    if islogical(Image)
        r = im2uint8(logical(round(r))); 
    else
        r = im2uint8(r); 
    end
end
rout = r;
end