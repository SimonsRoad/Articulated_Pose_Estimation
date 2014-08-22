im =    [1  2  3  4  5  6  7  8;
         9 10 11 12 13 14 15 16;
        17 18 19 20 21 22 23 24;
        25 26 27 28 29 30 31 32;
        33 34 35 36 37 38 39 40;
        41 42 43 44 45 46 47 48;
        49 50 51 52 53 54 55 56;
        57 58 59 60 61 62 63 64];
    

[L, C] = size(im);

im = imrotate(im, 90);
im = chooseSize(im, [8, 8]);

padL = 1;
while (padL < L)
    padL = padL * 2;
end
padC = 1;
while (padC < C)
    padC = padC * 2;
end
maxSize = max(padL, padC);
im = padarray(im, [maxSize - L, maxSize - C]);

Center = [maxSize/2, maxSize/2];

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




magnit_ = ((grad_y_.^2)+(grad_x_.^2)).^.5;   