%{
将矩阵内容按morton扫描顺序将对应值输出——该函数为递归函数  
@param Mat 系数矩阵
@return mls 矩阵 n行1列 每个数据为对应Mat的值
%}
function mls = mat2list(Mat)      
    [r, c]= size(Mat);
    if (r == 2) && (c == 2)%如果不是2*2矩阵那么继续分块
        mls = [Mat(1,1); Mat(1,2); Mat(2,1); Mat(2,2)];
    else
        M1 = Mat(1 : r / 2, 1 : c/2);
        M2 = Mat(1 : r / 2, c / 2 + 1 : c);
        M3 = Mat(r / 2 + 1 : r, 1 : c / 2);
        M4 = Mat(r / 2 + 1 : r, c / 2 + 1: c);
        lt1 = mat2list(M1);
        lt2 = mat2list(M2);
        lt3 = mat2list(M3);
        lt4 = mat2list(M4);
        mls = [lt1; lt2; lt3; lt4];
    end
end
