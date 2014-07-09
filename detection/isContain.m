function flag = isContain( Center, m, n, Theta1, Theta2 )
%ISCONTAIN 此处显示有关此函数的摘要
%   此处显示详细说明

flag = 0;

y = m - Center(1);
x = n - Center(2);

%{
m1 = [sin(Theta1) cos(Theta1)];
m2 = [sin(Theta2) cos(Theta2)];

if (m1(1)*y - m1(2)*y) > 0  && (m2(1)*x - m2(2)*y) > 0  && 
    flag = 1;
else
    flag = 0;
end
%}

%%{
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

if  Theta1 < 0
    if (theta > 0) && (theta < Theta2)
        flag = 1;
    elseif (theta > 3*pi/2) && ((theta - 2*pi) > Theta1)
        flag = 1;
    else
        flag = 0;
    end
else
    if theta > Theta1 && theta < Theta2
        flag = 1;
    else
        flag = 0;
    end
end
%}
end

