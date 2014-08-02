im = imread('44.jpg');
im = imlogpolar(im,64,64,'bilinear');
%f = extractHOGFeatures(im);
%f = reshape(f, 14,14,9);
im = im(:,:,1);
%for i = 1:14
%    for j= 1:14
        F = fft(im);
        %F = fftshift(F);
        F = abs(F);
       % F = reshape(F, 1, 64*64, 3);
       % F(1,:,1) = sort(F(1,:,1));
       % F(1,:,2) = sort(F(1,:,2));
       %         F(1,:,3) = sort(F(1,:,3));
%    end
%end

im2 = imread('22.jpg');
im2 = imlogpolar(im2,64,64,'bilinear');
%f2 = extractHOGFeatures(im2);
im2 = im2(:,:,1);

F2 = fft(im2);
%F2 = fftshift(F2);
F2 = abs(F2);
        %F2 = reshape(F2, 1, 64*64, 3);
        %F2(1,:,1) = sort(F2(1,:,1));
        %F2(1,:,2) = sort(F2(1,:,2));
        %        F2(1,:,3) = sort(F2(1,:,3));
                
  error = 0.0;
  for i = 1:64
      for j = 1:64
          error = error + (F(i,j) - F2(i,j));
      end
  end
  error
