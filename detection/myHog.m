function feat = myHog( simage, sbin )
%MYHOG Summary of this function goes here
%   Detailed explanation goes here

% change feature must change " nw * nh * nf " the in initmodel.m
% 

%% use r-hog 
%{
% r-hog 36 dims
featBefore = vl_hog(single(simage), sbin, 'verbose', 'variant','dalaltriggs');
% pca-hog 31 dims
%featBefore = vl_hog(single(simage), sbin, 'verbose', 'variant','uoctti');
[M,N,K] = size(featBefore);
feat = double(featBefore(2:M-1,2:N-1,:));
%}

%% use c-hog
%{
B = 9; % set the number of histogram bins
[L,C,KK]=size(simage);
stepx = floor(C/(sbin));
stepy = floor(L/(sbin));
featBefore = zeros(stepx,stepy,5*B);
H = zeros(5*B,1);
cont = 0;
hx = [-1, 0, 1];
hy = -hx';
grad_xrBe = imfilter(double(simage), hx);
grad_yuBe = imfilter(double(simage), hy);
mangitsBe = ((grad_yuBe.^2)+(grad_xrBe.^2)).^.5;

%{
flag = 1;
sum1 = sum(mangitsBe(:,:,1));
for k = 2:KK
    if sum(mangitsBe(:,:,k) > sum1)
        flag = k;
    end
end
grad_xr(:,:) = grad_xrBe(:,:,flag);
grad_yu(:,:) = grad_yuBe(:,:,flag);   % for color image
%}

for i = 1:L
    for j = 1:C
        grad2 = mangitsBe(i,j,1);
        grad_xr(i,j) = grad_xrBe(i,j,1);
        grad_yu(i,j) = grad_yuBe(i,j,1);
        for k = 2:KK
            if( mangitsBe(i,j,k) > grad2)
                grad2 = mangitsBe(i,j,k);
                grad_xr(i,j) = grad_xrBe(i,j,k);
                grad_yu(i,j) = grad_yuBe(i,j,k);
            end
        end
    end
end

angles = atan2(grad_yu, grad_xr);
mangits = ((grad_yu.^2)+(grad_xr.^2)).^.5;

for n = 0:stepy-1
    for m = 0:stepx-1
        for kk = 1:5
            cont = cont + 1;
            if(kk == 1)
                % center  sbin = 4
                angles2 = angles(n*sbin+(sbin/4+1):n*sbin+(3*sbin/4),m*sbin+(sbin/4+1):m*sbin+(3*sbin/4));
                mangits2 = mangits(n*sbin+(sbin/4+1):n*sbin+(3*sbin/4),m*sbin+(sbin/4+1):m*sbin+(3*sbin/4));
            elseif(kk == 2)
                angles2 = angles(n*sbin+1:n*sbin+sbin/4,m*sbin+1:m*sbin+sbin/2);
                mangits2 = mangits(n*sbin+1:n*sbin+sbin/4,m*sbin+1:m*sbin+sbin/2);
                angles2 = [angles2 angles(n*sbin+(sbin/4+1):n*sbin+(sbin/2),m*sbin+1:m*sbin+sbin/4)];
                mangits2 = [mangits2 mangits(n*sbin+(sbin/4+1):n*sbin+(sbin/2),m*sbin+1:m*sbin+sbin/4)];
            elseif(kk == 3)
                angles2 = angles(n*sbin+1:n*sbin+sbin/4,m*sbin+sbin/2+1:m*sbin+sbin);
                mangits2 = mangits(n*sbin+1:n*sbin+sbin/4,m*sbin+sbin/2+1:m*sbin+sbin);
                angles2 = [angles2 angles(n*sbin+sbin/4+1:n*sbin+sbin/2,m*sbin+3*sbin/4+1:m*sbin+sbin)];    
                mangits2 = [mangits2 mangits(n*sbin+sbin/4+1:n*sbin+sbin/2,m*sbin+3*sbin/4+1:m*sbin+sbin)];
            elseif(kk == 4)
                angles2 = angles(n*sbin+3*sbin/4+1:n*sbin+sbin,m*sbin+sbin/2+1:m*sbin+sbin);
                mangits2 = mangits(n*sbin+3*sbin/4+1:n*sbin+sbin,m*sbin+sbin/2+1:m*sbin+sbin);
                angles2 = [angles2 angles(n*sbin+sbin/2+1:n*sbin+3*sbin/4,m*sbin+3*sbin/4+1:m*sbin+sbin)];       
                mangits2 = [mangits2 mangits(n*sbin+sbin/2+1:n*sbin+3*sbin/4,m*sbin+3*sbin/4+1:m*sbin+sbin)];
            else
                angles2 = angles(n*sbin+3*sbin/4+1:n*sbin+sbin,m*sbin+1:m*sbin+sbin/2);
                mangits2 = mangits(n*sbin+3*sbin/4+1:n*sbin+sbin,m*sbin+1:m*sbin+sbin/2);
                angles2 = [angles2 angles(n*sbin+sbin/2+1:n*sbin+3*sbin/4,m*sbin+1:m*sbin+sbin/4)];  
                mangits2 = [mangits2 mangits(n*sbin+sbin/2+1:n*sbin+3*sbin/4,m*sbin+1:m*sbin+sbin/4)];
            end

            v_angles = angles2(:);
            v_mangits = mangits2(:);
            K = max(size(v_angles));
            bin = 0;
            H2 = zeros(B,1);
            for ang_lim = -pi+2*pi/B:2*pi/B:pi
                bin = bin+1;
                for k = 1:K
                    if v_angles(k) < ang_lim
                        v_angles(k) = 100;
                        H2(bin) = H2(bin) + v_mangits(k);
                    end
                end
            end
            H2 = H2/(norm(H2)+0.01);
            %feat((cont-1)*B+1:cont*B,1) = H2;
            H(9*(kk-1)+1:9*kk) = H2;
        end
        featBefore(n+1,m+1,:) = H;
    end
end
[M,N,K] = size(featBefore);
feat = double(featBefore(2:M-1,2:N-1,:));
%}

%% RGT
%{
rows = size(simage,1);
cols = size(simage,2);
NRid = 8;
Ntheta = pi/4;
Center = [(rows+1)/2 (cols+1)/2];
Center = floor(Center);
feat = extractRGT(simage, rows, cols, NRid, Ntheta, Center);
%}

%% basic polar image
%{
[L,C,KK]=size(simage);
polorIm = imlogpolar(simage,L,C,'bilinear');
%feat = (abs(fft2(polorIm)));
%featBefore = vl_hog(single(feat), sbin, 'verbose', 'variant','uoctti');
featBefore = vl_hog(single(polorIm), sbin, 'verbose', 'variant','uoctti');
[M,N,K] = size(featBefore);
feat = double(featBefore(2:M-1,2:N-1,:));
%}

%% RIFF

end

