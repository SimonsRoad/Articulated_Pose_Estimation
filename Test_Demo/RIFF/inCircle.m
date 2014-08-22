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
