function ButtonMotionFcn(src,event)
    pt = get(gca,'CurrentPoint');
    x = pt(1,1);
    y = pt(1,2);
    plot(x,y,'*');
    fprintf('!!x=%f,y=%f\n',x,y);
end