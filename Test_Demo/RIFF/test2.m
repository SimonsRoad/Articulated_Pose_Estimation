im =    [0  2  3  4  0;
         9 10 11 12 13;
        17 18 19 20 21;
        25 26 27 28 29;
         0 34 35 36  0];
    

[L, C] = size(im);

im = imrotate(im, 90);
im = chooseSize(im, [5, 5]);

padL = 1;
while (padL < L-1)
    padL = padL * 2;
end
padL = padL + 1;
padC = 1;
while (padC < C-1)
    padC = padC * 2;
end
padC = padC + 1;
maxSize = max(padL, padC);
im = padarray(im, [maxSize - L, maxSize - C]);

Center = [(maxSize+1)/2, (maxSize+1)/2]+1;

Radius = 8;
numRids = maxSize / (2 * Radius);
dy = [-1 -1 -1 0  0  1 1 1];
dx = [-1  0  1 -1 1 -1 0 1];
filterIm = padarray(im, [1, 1]);
Len = maxSize + 2;
for i = 2 : Len-1
    for j = 2 : Len-1
            yy = Len - i + 1;
            xx = j;
            gx = xx - Center(2);
            gy = yy - Center(1);
            gtheta1 = atan2(gy, gx);
            gtheta2 = atan2(-gx, gy);
            for kk = 1 : 8
                yyy = yy + dy(kk) - Center(1);
                xxx = xx + dx(kk) - Center(2);
                gthetay(kk) = abs(atan2(yyy, xxx) - gtheta1);
                gthetax(kk) = abs(atan2(dy(kk), dx(kk)) - gtheta2);
            end    
            [mm, nn] = sort(gthetay);
            if ( (dx(nn(1))^2 - 2 * Center(2) * dx(nn(1)) + dy(nn(1))^2 - 2 * Center(1) * dy(nn(1))) > (dx(nn(2))^2 - 2 * Center(2) * dx(nn(2)) + dy(nn(2))^2 - 2 * Center(1) * dy(nn(2))) )
                gy_1 = nn(1);
                gy_2 = nn(2);
            else
                gy_1 = nn(2);
                gy_2 = nn(1);
            end
            [mm, nn] = sort(gthetax);
            if ( (dx(nn(1))^2 - 2 * Center(2) * dx(nn(1)) + dy(nn(1))^2 - 2 * Center(1) * dy(nn(1))) > (dx(nn(2))^2 - 2 * Center(2) * dx(nn(2)) + dy(nn(2))^2 - 2 * Center(1) * dy(nn(2))) )
                gx_1 = nn(1);
                gx_2 = nn(2);
            else
                gx_1 = nn(2);
                gx_2 = nn(1);
            end      
            grad_y_(i-1, j-1) = filterIm(i+dy(gy_1), j+dx(gy_1)) - filterIm(i+dy(gy_2), j+dx(gy_2));
            grad_x_(i-1, j-1) = filterIm(i+dy(gx_1), j+dx(gx_1)) - filterIm(i+dy(gy_2), j+dx(gy_2));     
    end
end

angles = atan2(grad_y_, grad_x_);
magnit = ((grad_y_.^2)+(grad_x_.^2)).^.5;   