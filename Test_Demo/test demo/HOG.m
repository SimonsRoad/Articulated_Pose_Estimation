% Extract HOG Feature

function H = HOG(Im)
nwin_x = 4;%set here the number of HOG windows per bound box
nwin_y = 4;
B = 9;%set here the number of histogram bins
[L, C, K] = size(Im); % L num of lines ; C num of columns

Im = im2double(Im);
step_x = ceil(C/(nwin_x)) - 1;
step_y = ceil(L/(nwin_y)) - 1;
H = zeros(step_x*step_y*B, 1); % column vector with zeros

if K ~= 1
    [DX, DY, ~] = gradient(Im);
    mag = DX .^ 2 + DY .^ 2;
    [~,channel] = max(mag,[],3);
    grad_x = DX(:,:, 1) .* (channel == 1) + DX(:,:, 2) .* (channel == 2) + DX(:,:, 3) .* (channel == 3);
    grad_y = DY(:,:, 1) .* (channel == 1) + DY(:,:, 2) .* (channel == 2) + DY(:,:, 3) .* (channel == 3);
    complex_g = complex(grad_x,grad_y);    
else
    [grad_x,grad_y] = gradient(im);
    complex_g = complex(grad_x,grad_y);    
end

angles = angle(complex_g);
magnit = abs(complex_g);
cont = 0;

for n = 0 : step_y-2
    for m = 0 : step_x-2
        cont = cont+1;
        angles2 = angles(n*nwin_y+1:(n+2)*nwin_y,m*nwin_x+1:(m+2)*nwin_x); 
        magnit2 = magnit(n*nwin_y+1:(n+2)*nwin_y,m*nwin_x+1:(m+2)*nwin_x);
        v_angles = angles2(:);    
        v_magnit = magnit2(:);
        K = max(size(v_angles));
        bin = 0;
        H2=zeros(B,1);
        for ang_lim = -pi+2*pi/B : 2*pi/B : pi
            bin = bin+1;
            for k = 1:K
                if v_angles(k) < ang_lim
                    v_angles(k) = 100;
                    H2(bin) = H2(bin) + v_magnit(k);
                end
            end
        end
                
        H2 = H2/(norm(H2)+0.01);        
        H((cont-1)*B+1:cont*B, 1) = H2;
    end
end
