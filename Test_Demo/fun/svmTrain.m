function svm = svmTrain (svmType, X, Y, ker, p1, p2)
%SVMTRAIN Summary of this function goes here
%   Detailed explanation goes here

options = optimset('LargeScale', 'off', 'display', 'off');

switch svmType
    case 'svc_c',
        C = p1;
        n = length(Y);
        H = (Y*Y').*kernel(ker,X,X);
        f = -ones(1,n);
        A = [];
        b = [];
        Aeq = Y';
        beq = 0;
        lb = zeros(n,1);
        ub = C*zeros(n,1);
        a0 = zeros(n,1);
        [a, fval, eXitflag, output, lambda] = quadprog(H, f, A, b, Aeq, beq, lb, ub, a0, options);
    case 'svr_epsilon',
        C = p1;
        e = p2;
        n = length(Y);
        Q = kernel(ker, X, X);
        H = [Q, -Q; -Q, Q];
        f = [e*ones(n,1)-Y; e*ones(n,1)+Y];
        A = [];
        b = [];
        Aeq = [ones(1,n), -ones(1,n)];
        beq = 0;
        lb = zeros(2*n, 1);
        ub = C*ones(2*n, 1);
        a0 = zeros(2*n, 1);
        [a, fval, eXitflag, output, lambda] = quadprog(H, f, A, b, Aeq, beq, lb, ub, a0, options);
        a = a(1:n) - a(n+1:end);
    otherwise,
end

eXitflag;
svm.type = svmType;
svm.ker = ker;
svm.x = X;
svm.y = Y;
svm.a = a;

