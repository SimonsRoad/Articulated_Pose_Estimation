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