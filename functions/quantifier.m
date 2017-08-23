%{
%构造量化器
@param T1 int 初始阈值
@param level int 第n次扫描

@return quantifierMat 每层的量化值n行两列
@return threshold 当前阈值
%}
function [quantifierMat, threshold] = quantifier(T1, level)
    quantifierMat = [];
    maxInterValue = 2 * T1;
    threshold = T1 / 2 ^ (level - 1);%第level次扫描的阈值
    intervalNum = maxInterValue / threshold - 1;%量化器数目，起始点不是0所以减1
    for i = 1 : intervalNum
        quantifierMat = [quantifierMat ; threshold * (i + 0.25) threshold * (i + 0.75)];
    end
end