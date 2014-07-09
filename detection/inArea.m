function  mask = inArea( Center, NRid, Ntheta, i, j )
%INAREA 此处显示有关此函数的摘要
%   此处显示详细说明

cnt = 0;
mask = [];
if i == 0
    for m = -NRid + Center(1) : Center(1) + NRid
        for n = -NRid + Center(2) : Center(2) + NRid
            if (m-Center(1))*(m-Center(1)) + (n-Center(2))*(n-Center(2)) < NRid*NRid
                cnt = cnt + 1;
                mask(cnt,1) = m;
                mask(cnt,2) = n;
            end
        end
    end
else
    R1 = i*NRid;
    R2 = (i+1)*NRid;
    Theta1 = -Ntheta/2 + j * Ntheta;
    Theta2 = Ntheta/2 + j * Ntheta;
    for m = -R2 + Center(1) : Center(1) + R2
        for n = -R2 + Center(2) : Center(2) + R2
            if ((m-Center(1))*(m-Center(1)) + (n-Center(2))*(n-Center(2)) < R2*R2) && ((m-Center(1))*(m-Center(1)) + (n-Center(2))*(n-Center(2)) > R1*R1) && isContain(Center, m, n, Theta1, Theta2)
                cnt = cnt + 1;
                mask(cnt,1) = m;
                mask(cnt,2) = n;
            end
        end
    end
end

mask = int8(mask);

end

