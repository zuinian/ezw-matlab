%{
 一维dwt
@param X 一维序列
@param lpd 低通滤波
@param hpd 高通滤波

@return ca 低频系数/近似系数
@return cd 高频系数/精确系数
%}
function [ca, cd] = myDwt(X, lpd, hpd)
    ca = X;
    cd = [];
    t = ca;
    %获取低频系数
    z = conv(t, lpd);
    last = floor(length(z));
    ca = z(2 : 2 : last);
    %获取高频系数
    z = conv(t, hpd);
    last = floor(length(z));
    cd = [cd z(2 : 2 : last)];
end