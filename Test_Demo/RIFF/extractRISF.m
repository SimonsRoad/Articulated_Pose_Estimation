function risf = extractRISF( im, Radius, Theta )

im = double(im);
[L, C, K] = size(im);
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

numRids = maxSize / (2 * Radius);
B = 9;
H = zeros(numRids * B, 1);
risf = zeros(201, 201);
hx = [-1, 0, 1];
hy = -hx';

%grad_x_ = imfilter((im),hx);
%grad_y_ = imfilter((im),hy);
%magnit_ = ((grad_y_.^2)+(grad_x_.^2)).^.5;   

% use circle then every circle to hog
% use patch then every patch to Hog

% filter   no edge piexl
dy = [-1 -1 -1 0  0  1 1 1];
dx = [-1  0  1 -1 1 -1 0 1];
filterIm = padarray(im, [1, 1]);
Len = maxSize + 2;
for i = 2 : Len-1
    for j = 2 : Len-1
        for k = 1 : K
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
            grad_y_(i-1, j-1, k) = filterIm(i+dy(gy_1), j+dx(gy_1), k) - filterIm(i+dy(gy_2), j+dx(gy_2), k);
            grad_x_(i-1, j-1 ,k) = filterIm(i+dy(gx_1), j+dx(gx_1), k) - filterIm(i+dy(gy_2), j+dx(gy_2), k);
        end
    end
end

magnit_ = ((grad_y_.^2)+(grad_x_.^2)).^.5;   


for i = 1:maxSize
    for j = 1:maxSize
        gotindex = find(magnit_(i,j,:) == max(magnit_(i,j,:)));
        grad_x(i,j) = grad_x_(i,j,gotindex(1));
        grad_y(i,j) = grad_y_(i,j,gotindex(1));
    end
end

angles = atan2(grad_y, grad_x);
magnit = ((grad_y.^2)+(grad_x.^2)).^.5;  

cont = 0;
numTheta = (2*pi)/Theta;

radial = [0 : Theta : 2*pi-Theta];
tangential = [pi/2 : Theta : 2*pi+Theta];
theta = [-16*pi/18 : 4*pi/18 : 16*pi/18];

oneindex = 1;
twoindex = 1;

%{
for i = 1 : numRids
    cont = cont + 1;
    mask = inCircle(Center, Radius, i);

    % show circle
    %{ 
    mat = zeros(64,64);
    for j = 1:length(mask)
        mat(mask(j,1), mask(j,2)) = 1;
    end
    imshow(mat, [-1 1]);
    %}

    for j = 1:length(mask)
        v_angles(j, 1) = angles(mask(j, 1), mask(j, 2));
        v_magnit(j, 1) = magnit(mask(j, 1), mask(j, 2));
    end

    K = max(size(v_angles));
    bin=0;
    H2=zeros(B,1);
    for ang_lim=-pi+2*pi/B:2*pi/B:pi
        bin=bin+1;
        for k=1:K
            if v_angles(k)<ang_lim
                v_angles(k)=100;
                H2(bin)=H2(bin)+v_magnit(k);
            end
        end
    end

    H2=H2/(norm(H2)+0.01);    
    %{
    H2 = H2 .* 100;
    
    if i == 0
        for k = 1:B
            oneindex = int8(H2(k))+101;
            twoindex = 101;
            risf(oneindex, twoindex) = risf(oneindex, twoindex) + H2(k);       
        end
    else
       for k = 1:B
            oneindex = int8([cos(theta(k)) sin(theta(k))] * [cos(radial(1)) sin(radial(1))]' *H2(k)) + 101;
            twoindex = int8([cos(theta(k)) sin(theta(k))] * [cos(tangential(1)) sin(tangential(1))]' *H2(k)) + 101;
            risf(oneindex, twoindex) = risf(oneindex, twoindex) + H2(k);
       end
    end
    %}
    
    H((cont-1)*B+1:cont*B,1)=H2;
end   
%}

for i = 0 : numRids - 1
    for j = 0 : numTheta - 1
        cont = cont + 1;
        mask = inArea(Center, Radius, Theta, i, j);

        % show area
        %{
        mat = zeros(64,64);
        for k = 1:length(mask)
            mat(mask(k,1), mask(k,2)) = 1;
        end
        imshow(mat, [-1 1]);
        %}

        for k = 1:length(mask)
            v_angles(k, 1) = angles(mask(k, 1), mask(k, 2));
            v_magnit(k, 1) = magnit(mask(k, 1), mask(k, 2));
        end

        K = max(size(v_angles));
        bin=0;
        H2=zeros(B,1);
        for ang_lim=-pi+2*pi/B:2*pi/B:pi
            bin=bin+1;
            for k=1:K
                if v_angles(k)<ang_lim
                    v_angles(k)=100;
                    H2(bin)=H2(bin)+v_magnit(k);
                end
            end
        end

        H2=H2/(norm(H2)+0.01);  
        
        %% my feature 
        H2 = H2 .* 100;
        if i == 0
            for k = 1:B
                oneindex = int8(H2(k))+101;
                twoindex = 101;
                risf(oneindex, twoindex) = risf(oneindex, twoindex) + H2(k);
                
                %one(oneindex) = int8(H2(k));
                %two(twoindex) = 0;
                %risf(one(oneindex) + 101, two(twoindex) + 101) = H2(k);
                %oneindex = oneindex + 1;
                %twoindex = twoindex + 1;           
            end
        else
           for k = 1:B
                oneindex = int8([cos(theta(k)) sin(theta(k))] * [cos(radial(j+1)) sin(radial(j+1))]' *H2(k)) + 101;
                twoindex = int8([cos(theta(k)) sin(theta(k))] * [cos(tangential(j+1)) sin(tangential(j+1))]' *H2(k)) + 101;
                risf(oneindex, twoindex) = risf(oneindex, twoindex) + H2(k);
                %risf(int8([cos(theta(k)) sin(theta(k))] * [cos(radial(j+1)) sin(radial(j+1))]' *H2(k)) + 101, int8([cos(theta(k)) sin(theta(k))] * [cos(tangential(j+1)) sin(tangential(j+1))]' *H2(k)) + 101) = H2(k);
                %one(oneindex) = int8([cos(theta(k)) sin(theta(k))] * [cos(radial(j+1)) sin(radial(j+1))]' *H2(k));
                %two(twoindex) = int8([cos(theta(k)) sin(theta(k))] * [cos(tangential(j+1)) sin(tangential(j+1))]' *H2(k));
                %risf(one(oneindex) + 101, two(twoindex) + 101) = H2(k);
                %oneindex = oneindex + 1;
                %twoindex = twoindex + 1;
           end
        end
       
        H((cont-1)*B+1:cont*B,1)=H2;

        if i == 0
            break;
        end
    end
    risf = risf/(norm(risf)+0.01);
end

end
