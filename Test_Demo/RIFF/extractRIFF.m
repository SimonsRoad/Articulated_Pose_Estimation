function riff = extractRIFF(im, Radius, Theta)

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
hx = [-1, 0, 1];
hy = -hx';
grad_x_ = imfilter((im),hx);
grad_y_ = imfilter((im),hy);
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

%%{
%% for each pixel to compute RGT
for i = 1 : maxSize
    for j = 1 : maxSize       
        % normal RGT        
        radial = [maxSize-i+1 - Center(1); j - Center(2)] ./ ((maxSize-i+1 - Center(1))^2 + (j - Center(2))^2)^.5;
        % approximate RGT
        %radial = chooseARGT(maxSize-i+1, j, Center);

        tangential = [-radial(2); radial(1)];        
        
        %gradient = [angles(i, j); 1] .* magnit(i,j) ./ sqrt(angles(i, j)^2 + 1);    
        gradient = [grad_y(i, j); grad_x(i,j)];
        rgtx(i, j) = gradient' * radial;
        rgty(i, j) = gradient' * tangential;  
    end
end

newangles = atan2(rgty, rgtx);
newmagnit = ((rgty.^2)+(rgtx.^2)).^.5;  

%{
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
%   testannulis == 1  inCircle    else   inArea
TESTANNULIS = 1;
if TESTANNULIS
    cont = 0;
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
else
    cont = 0;
    numTheta = (2*pi)/Theta;
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
                v_angles(k, 1) = newangles(mask(k, 1), mask(k, 2));
                v_magnit(k, 1) = newmagnit(mask(k, 1), mask(k, 2));
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

 riff = H;
end