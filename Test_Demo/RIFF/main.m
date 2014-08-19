angle = [0 45 90 135 180 225 270 315];

for i = 1:length(angle)
    im = imread('11.jpg');
    im = imrotate(im, angle(1, i));
    im = chooseSize(im, [64, 64]);
    figure(i);
    imshow(uint8(im));
    
    [riff(:,i), rgtx, rgty] = extractRIFF(im, 8, pi/4);
    %riff(:,i) = sort(riff(:,i));
    figure(i+8);
    bar(riff(:,i)');
end

