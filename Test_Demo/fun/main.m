clear all;
clc;

C = 0.1719;
ker = struct('type', 'linear');

n = 50;
randn('state', 2);
x1 = randn(n,2);
y1 = ones(n,1);
x2 = 4 + randn(n, 2);
y2 = -ones(n,1);
X = [x1;x2];
Y = [y1;y2];

figure(1);
plot(x1(:,1), x1(:,2), 'r.', x2(:,1),x2(:,2),'b.');

hold on;
x3 = randn(n,2);
x4 = 5 + randn(n,2);
Xd = [x3;x4];
plot(x3(:,1),x3(:,2), 'g.',x4(:,1), x4(:,2),'m.');

hold on;
svm = svmTrain('svc_c',X,Y,ker,C);

a = svm.a;
epsilon = 1e-10;
i_sv = find(abs(a)>epsilon);
plot(X(i_sv,1),X(i_sv,2),'y+');

[x1,x2] = meshgrid(-5:0.05:6,-5:0.05:6);
[rows,cols] = size(x1);
nt = rows*cols;
Xt =[reshape(x1,1,nt);reshape(x2,1,nt)]';
Yt = svmSim(svm, Xt);
Yt = reshape(Yt, rows, cols);
contour(x1,x2,Yt,[0,0],'m');
hold on;
Yd = svmSim(svm,Xd);           % 测试输出 

 

 plot(x3(:,1),x3(:,2),'kx') 
hold on;  
 
 plot(X(i_sv,1),X(i_sv,2),'ro'); 
hold on; 
 contour(x1,x2,Yt,[0 0],'m');   