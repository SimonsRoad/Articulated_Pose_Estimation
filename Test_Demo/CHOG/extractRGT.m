function H = extractRGT( Image, rows, cols, NRid, Ntheta, Center )
%EXTRACTRGT 此处显示有关此函数的摘要
%   此处显示详细说明

threeD = (length(size(Image)) == 3);

Image = double(Image);
B = 9;
numRids = min(rows, cols)/(2*NRid);
if mod(numRids,2) ~=0
    numRids = numRids - 1;
end
numTheta = (2*pi)/Ntheta;
% test circle
H = zeros(numRids * B, 1);
%H = zeros((1+(numRids - 1)*numTheta*B),1);
hx = [-1, 0, 1];
hy = hx';
grad_x_ = imfilter((Image),hx);
grad_y_ = imfilter((Image),hy);
angles_ = atan2(grad_y_, grad_x_);
magnit_ = ((grad_y_.^2)+(grad_x_.^2)).^.5;   

%  three dimensional RGB image
if threeD   
    [sizea sizeb sizek] = size(magnit_);
    for i = 1:sizea
        for j = 1:sizeb
            gotindex = find(magnit_(i,j,:) == max(magnit_(i,j,:)));
            grad_x(i,j) = grad_x_(i,j,gotindex(1));
            grad_y(i,j) = grad_y_(i,j,gotindex(1));
        end
    end
    angles = atan2(grad_y, grad_x);
    magnit = ((grad_y.^2)+(grad_x.^2)).^.5;   
else  %  gray image  
    grad_x = grad_x_;
    grad_y = grad_y_;
    angles = angles_;
    magnit = magnit_;
end

%{
cont = 0;
i = 0; j = 0;
for i = 0:numRids-1
    for j = 0:numTheta-1
        cont = cont + 1;
        mask = inArea(Center, NRid, Ntheta, i, j);
        angles2 = angles(mask(:,1),mask(:,2));
        magnit2 = magnit(mask(:,1),mask(:,2));
        v_angles = angles2(:);
        v_magnit = magnit2(:);
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
%}

cont = 0;
for i = 1 : numRids
    cont = cont + 1;
    mask = inCircle(Center, NRid, i);
    angles2 = angles(mask(:,1), mask(:,2));
    magnit2 = magnit(mask(:,1), mask(:,2));
    v_angles = angles2(:);
    v_magnit = magnit2(:);
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

%H = reshape(H, [9 25]);
H = H';

