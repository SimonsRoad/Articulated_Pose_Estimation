testImage = dir('*.jpg');

for i = 1:length(testImage)
    imFFT(testImage(i).name, i);
end