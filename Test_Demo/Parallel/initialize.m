CoreNum = 2;
if matlabpool('size') <= 0
    matlabpool('open', 'local', CoreNum);
else
    disp('Already initialized');
end