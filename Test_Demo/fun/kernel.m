function K = kernel( ker, x, y )
%KERNEL Summary of this function goes here
%   Detailed explanation goes here
switch ker.type
    case 'linear'
        K = x*y';
    case 'ploy'
        d = ker.degree;
        c = ker.offset;
        K = (x*y'+c).^d;
    case 'gauss'
        s = ker.width;
        rows = size(x,1);
        cols = size(y,1);
        temp = zeros(rows, cols);
        for i =1:rows
            for i = 1:cols
                temp(i,j) = norm(x(i,:)-y(j,:));
            end
        end
        K = exp(-0.5*(temp/s).^2);
    case 'tanh'
        g = ker.gamma;
        c = ker.offset;
        K = tanh(g*x*y'+c);
    otherwise
        K = 0;
end

