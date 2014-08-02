function imFFT( imageName, i )
%IMFFT 此处显示有关此函数的摘要
%   此处显示详细说明

I = imread(imageName);
J = imlogpolar(I,64,64,'bilinear');figure(i);imshow(J);
F=fft2(J);%完成FFT变换
FC=fftshift(F);%实现居中
figure(i+4);
imshow(uint8(FC));
%imshow(uint8(F));
end

