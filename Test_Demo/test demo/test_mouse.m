figure(2);
I = imread('p001_001.jpg');
imshow(I); hold on
set(gcf,'WindowButtonDownFcn',@ButtonDownFcn);
set(gcf,'WindowButtonUpFcn',@ButtonUpFcn);

