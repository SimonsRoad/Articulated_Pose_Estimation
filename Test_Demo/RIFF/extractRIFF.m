function [riff, rgtx, rgty] = extractRIFF(im, Radius, Theta)

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
padIm = padarray(im, [maxSize - L, maxSize - C]);

Center = [maxSize/2, maxSize/2];

numRids = maxSize / (2 * Radius);
B = 9;
H = zeros(numRids * B, 1);
hx = [-1, 0, 1];
hy = -hx';
grad_x_ = imfilter((padIm),hx);
grad_y_ = imfilter((padIm),hy);
magnit_ = ((grad_y_.^2)+(grad_x_.^2)).^.5;   

for i = 1:L
    for j = 1:C
        gotindex = find(magnit_(i,j,:) == max(magnit_(i,j,:)));
        grad_x(i,j) = grad_x_(i,j,gotindex(1));
        grad_y(i,j) = grad_y_(i,j,gotindex(1));
    end
end

angles = atan2(grad_y, grad_x);
magnit = ((grad_y.^2)+(grad_x.^2)).^.5;  

%%{
%% for each pixel to compute RGT
for i = 1 : L
    for j = 1 : C         
        % normal RGT        
        %radial = [L-i+1 - Center(1); j - Center(2)] ./ ((L-i+1 - Center(1))^2 + (j - Center(2))^2)^.5;
        % approximate RGT
        radial = chooseARGT(L-i+1, j, Center);

        tangential = [-radial(2); radial(1)];        
        
        %gradient = [angles(i, j); 1] .* magnit(i,j) ./ sqrt(angles(i, j)^2 + 1);    
        gradient = [grad_y(i, j); grad_x(i,j)];
        rgtx(i, j) = gradient' * radial;
        rgty(i, j) = gradient' * tangential;  
    end
end

newangles = atan2(rgty, rgtx);
newmagnit = ((rgty.^2)+(rgtx.^2)).^.5;  
cont = 0;
for i = 1 : numRids
    cont = cont + 1;
    mask = inCircle(Center, Radius, i);
    %{ 
    % show circle
    mat = zeros(64,64);
    for j = 1:length(mask)
        mat(mask(j,1), mask(j,2)) = 1;
    end
    imshow(mat, [-1 1]);
    %}

    for j = 1:length(mask)
        v_angles(j, 1) = newangles(mask(j, 1), mask(j, 2));
        v_magnit(j, 1) = newmagnit(mask(j, 1), mask(j, 2));
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
    H((cont-1)*B+1:cont*B,1)=H2;
end          
%}
%{
%   testannulis == 1  inCircle    else   inArea
TESTANNULIS = 0;
if TESTANNULIS
    cont = 0;
    for i = 1 : numRids
        cont = cont + 1;
        mask = inCircle(Center, Radius, i);
        %{ 
        % show circle
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
        H((cont-1)*B+1:cont*B,1)=H2;
    end    
else
    cont = 0;
    numTheta = (2*pi)/Theta;
    for i = 0 : numRids - 1
        for j = 0 : numTheta - 1
            cont = cont + 1;
            mask = inArea(Center, Radius, Theta, i, j);
             
            % show circle
            mat = zeros(64,64);
            for j = 1:length(mask)
                mat(mask(j,1), mask(j,2)) = 1;
            end
            imshow(mat, [-1 1]);
            
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
            H((cont-1)*B+1:cont*B,1)=H2;
            
            if i == 0
                break;
            end
            
        end
    end        
end
%}
 riff = H;
end

function radial = chooseARGT(x, y, Center)
    angle = [-pi : 2*pi/9 : pi];
   answer = [-8*pi/9 : 2*pi/9 : 8*pi/9];
   
    yy = x - Center(1);
    xx = y - Center(2);
    theta = atan(yy/xx);
    
    if yy > 0 && xx < 0    % 2 -> 1
        theta = theta + pi;
    elseif yy < 0 && xx < 0   % 3 -> 2
        theta = theta + pi;
    elseif yy < 0 && xx > 0   % 4  -> 3
        theta = theta + 2*pi;
    %elseif y > 0 && x > 0
    %    theta = theta;
    end    
    
    for i = 1: 9
        if theta > angle(i) && theta <= angle(i+1)
            theta = answer(i);
        end
    end
    
    radial = [sin(theta); cos(theta)];
end

function mask = inArea(Center, Radius, Theta, i, j)
    cnt = 0;
    mask = [];
    if i == 0
        for m = -Radius + Center(1) + 1 : Center(1) + Radius
            for n = -Radius + Center(2) + 1 : Center(2) + Radius
                if (m-Center(1))*(m-Center(1)) + (n-Center(2))*(n-Center(2)) < Radius*Radius
                    cnt = cnt + 1;
                    mask(cnt,1) = m;
                    mask(cnt,2) = n;
                end
            end
        end
    else
        R1 = i*Radius;
        R2 = (i+1)*Radius;
        Theta1 = -Theta/2 + j * Theta;
        Theta2 = Theta/2 + j * Theta;
        for m = -R2 + Center(1) : Center(1) + R2
            for n = -R2 + Center(2) : Center(2) + R2
                if ((m-Center(1))*(m-Center(1)) + (n-Center(2))*(n-Center(2)) < R2*R2) && ((m-Center(1))*(m-Center(1)) + (n-Center(2))*(n-Center(2)) >= R1*R1) && isContain(Center, m, n, Theta1, Theta2, Theta)
                    cnt = cnt + 1;
                    mask(cnt,1) = m;
                    mask(cnt,2) = n;
                end
            end
        end
    end

    mask = int8(mask);
end

function flag = isContain( Center, m, n, Theta1, Theta2, Theta)
flag = 0;

m = Center(1) + Center(2) - m + 1;


y = m - Center(1);
x = n - Center(2);

if y == 0
    if (Theta2 < Theta/2+0.01 && Theta1 > -Theta/2-0.01) && x > 0
        flag = 1;
    elseif (Theta1 > pi - Theta/2 -0.01 && Theta2 < pi + Theta/2 + 0.01) && x < 0
        flag = 1;
    end
elseif x == 0
    if (Theta1 > 3*pi/2 - Theta/2 - 0.01 && Theta2 < 3*pi/2 + Theta/2 + 0.01) && y < 0
        flag = 1;
    elseif (Theta1 > pi/2 - Theta/2 - 0.01 && Theta2 < pi/2 + Theta/2 + 0.01) && y > 0
        flag = 1;
    end
else
    theta = atan(y/x);

    if y > 0 && x < 0    % 2 -> 1
        theta = theta + pi;
    elseif y < 0 && x < 0   % 3 -> 2
        theta = theta + pi;
    elseif y < 0 && x > 0   % 4  -> 3
        theta = theta + 2*pi;
    %elseif y > 0 && x > 0
    %    theta = theta;
    end

    if theta < Theta2 && theta > Theta1 && Theta1 > 0
        flag = 1;
    elseif Theta1 < 0
        Theta1 = Theta1 + pi*2;
        if theta > Theta1 && theta < 2*pi
            flag = 1;
        elseif theta > 0 && theta < Theta2
            flag = 1;
        end
    
        %{
    elseif Theta1 < 0 && theta < 0 && theta > Theta1
        flag = 1;
    elseif Theta1 < 0 && theta > 0 && theta < Theta2
        flag = 1;
        %}
    end
end

end

function mask = inCircle(Center, Radius, index)
    cnt = 0;
    mask = 0;
    for m = -Radius*index + Center(1) + 1 : Radius*index + Center(1)
        for n = -Radius*index + Center(2) + 1 : Radius*index + Center(2)
            if (m-Center(1))*(m-Center(1)) + (n-Center(2))*(n-Center(2)) < Radius*Radius*index*index &&  (m-Center(1))*(m-Center(1)) + (n-Center(2))*(n-Center(2)) >= Radius*Radius*(index-1)*(index-1)
                cnt = cnt + 1;
                mask(cnt, 1) = m;
                mask(cnt, 2) = n;
            end
        end
    end
    mask = int8(mask);
end
