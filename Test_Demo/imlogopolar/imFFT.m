function imFFT( imageName, i )
%IMFFT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

I = imread(imageName);
J = imlogpolar(I,64,64,'bilinear');figure(i);imshow(J);
F=fft2(J);%���FFT�任
FC=fftshift(F);%ʵ�־���
figure(i+4);
imshow(uint8(FC));
%imshow(uint8(F));
end

