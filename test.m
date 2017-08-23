%改小波基的名称，dbN，symN和coifN是正交小波基，是有尺度函数的，只更改N就行，如
[phi,psi,x] = wavefun('haar',10);%建议使用10次以上迭代计算，比较精确
subplot(221),plot(x,psi);
title('haar小波函数');

[phi,psi,x] = wavefun('db4',10);
subplot(222),plot(x,psi);
title('db4小波函数');

[phi,psi,x] = wavefun('sym6',10);
subplot(223),plot(x,psi);
title('sym6小波函数');

[phi,psi,x] = wavefun('coif2',10);
subplot(224),plot(x,psi);
title('coif2小波函数');