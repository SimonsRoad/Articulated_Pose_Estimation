clear;
testImage = dir('*.jpg');
for i = 1:length(testImage)
    im = imread(testImage(i).name);
    polorIm = imlogpolar(im,64,64,'bilinear');
    polorHog = vl_hog(single(polorIm), sbin, 'verbose', 'variant', )
    FeatFFT(i).feat = (abs(fft2(polorIm)));
end

bound = 10.0;

for i = 1:64
    for j = 1:64
        for ii = 1:length(testImage)
            flag = 0;
            for jj = 1:length(testImage)
                if ii == jj
                    continue;     
                end
                if flag == 1
                    break;
                end
                for k = 1:3
                    if abs(FeatFFT(ii).feat(i,j,k) - FeatFFT(jj).feat(i,j,k)) < bound
                        flag = 1;
                        break;
                    end     
                end
            end
            if flag == 1
                FeatFFT(ii).mask(i,j) = 0;
            else
                FeatFFT(ii).mask(i,j) = 1;
            end
        end
    end
end


for i = 1:length(testImage)
    count = sum(sum(FeatFFT(i).mask));
    x = sprintf('the %d image has %f', i, count/4096);
    disp(x);
    figure(i);
    imshow(FeatFFT(i).mask);
end