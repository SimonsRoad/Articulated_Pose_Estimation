angle = [0 45 90 135 180 225 270 315];

for i = 1:length(angle)
    im = imread('1.jpg');
    im = imrotate(im, angle(1, i));
    im = chooseSize(im, [64, 64]);
    figure(i);
    imshow(uint8(im));
    
    %riff = extractRIFF(im, 8, pi/4);
    risf = extractRISF(im, 8, pi/4);
    %riff(:,i) = sort(riff(:,i));
    figure(i+8);
    %bar(riff);
    %bar(risf);
    bar3h(risf);
end


