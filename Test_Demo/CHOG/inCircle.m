function mask = inCircle( Center, NRid, i )
%INCIRCLE 此处显示有关此函数的摘要
%   此处显示详细说明
cnt = 0;
mask = 0;
for m = -NRid*i + Center(1) + 1 : NRid*i + Center(1)
    for n = -NRid*i + Center(2) + 1 : NRid*i + Center(2)
        if (m-Center(1))*(m-Center(1)) + (n-Center(2))*(n-Center(2)) < NRid*NRid*i*i &&  (m-Center(1))*(m-Center(1)) + (n-Center(2))*(n-Center(2)) > NRid*NRid*(i-1)*(i-1)
            cnt = cnt + 1;
            mask(cnt, 1) = m;
            mask(cnt, 2) = m;
        end
    end
end
mask = int8(mask);
end

