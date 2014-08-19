function imout = chooseSize( im, imsize )
% cut image into some size

[L, C, K] = size(im);

im = double(im);

if L > imsize(1) && C > imsize(2)
    imout = zeros(imsize(1), imsize(2), K);
    Center = int32([L/2 C/2]);
    for i = Center(1) - imsize(1)/2 : Center(1) + imsize(1)/2-1
        for j = Center(2) - imsize(2)/2 : Center(2) + imsize(2)/2-1
            imout(i-Center(1)+imsize(1)/2+1, j-Center(2)+imsize(2)/2+1, :) = im(i,j,:);
        end
    end    
else
    imout = im;
end

end

