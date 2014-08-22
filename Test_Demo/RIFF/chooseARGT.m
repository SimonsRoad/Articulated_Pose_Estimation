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