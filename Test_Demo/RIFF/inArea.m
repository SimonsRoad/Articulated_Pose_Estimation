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