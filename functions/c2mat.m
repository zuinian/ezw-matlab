
%{
将小波变换后的系数格式转化成矩阵形式
@param cai 最里层低频系数
@param c 小波变换后的参数，单行形式
@param s 小波变换后的参数
@param dim 分解层数

@return cai 最后生成的总的系数矩阵
%}
function cai = c2mat(cai, c, s, dim) 
    %获取每层的高频系数
    for i = 1 : dim
        [chn, cvn, cdn] = detcoef2('all', c, s, dim + 1 - i);%水平方向   %垂直方向  %斜线方向 
        cai = [cai, chn; cvn, cdn];
    end
end