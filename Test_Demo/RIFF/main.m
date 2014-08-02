angle = [0 90 180 270];

for i = 1:length(angle)
    im = imread('11.jpg');
    im = imrotate(im, angle(1, i));
    figure(i);
    imshow(im);
    
    riff(:,i) = extractRIFF(im, 8, pi/4);
    riff(:,i) = sort(riff(:,i));
    figure(i+4);
    bar(riff(:,i)');
end
