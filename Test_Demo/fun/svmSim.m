function Yd = svmSim( svm, Xt )
%SVMSIM Summary of this function goes here
%   Detailed explanation goes here
type = svm.type;
ker = svm.ker;
X = svm.x;
Y = svm.y;
a = svm.a;

epsilon = 1e-6;
i_sv = find(abs(a)>epsilon);
switch type
    case 'svc_c'
        tmp = ((a(i_sv,:).*Y(i_sv,:))'*kernel(ker,X(i_sv,:),X(i_sv,:)))';
        b = 1./Y(i_sv)-tmp;
        b = mean(b);
        tmp = ((a.*Y)'*kernel(ker,X,Xt))';
        Yd = sign(tmp + b);
    case 'svc_epxilon',
        tmp = (a(i_sv)'*kernel(ker,X(i_sv,:),X(i_sv,:)))';
        b = Y(i_sv) - tmp;
        if length(b)~=0
            b = mean(b);
        else
            b = 0;
        end
        tmp = (a'*kernel(ker,X,Xt))';
        Yd = tmp + b;
    otherwise

end

