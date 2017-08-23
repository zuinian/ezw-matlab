%{
获取逆量化器矩阵函数
@param T1 int 初始阈值
@param level int 当前扫描层数
@param rIlist 行向量 当前的quantiFlag每个值所对应的具体量化等级（一共有level^2-1个等级）
@param quantiFlag 行向量 量化标志列表
@param quantiFlagOld 上一次循环的quantiFlag
@return antiQuantiMat 逆量化矩阵，保存的是每一个量化等级（阈值）对应的两个量化值
@return rIlist 如上，处理后值与长度增加了
@return quantiFlagOld 与传进来的quantiFlag值相等
%}

function [antiQuantiMat, rIlist, quantiFlagOld] = antiquantifier(T1, level, rIlist, quantiFlag, quantiFlagOld)
    antiQuantiMat = [];
    maxInterValue = 2 * T1;
    threshold = T1 / 2 ^ (level - 1);
    intervalNum = maxInterValue / threshold - 1;
    for i = 1 : intervalNum
        antiQuantiMat = [antiQuantiMat ; threshold * (i + 0.25) threshold * (i + 0.75)];
    end

    %获取R列表，第一次出现的都置1
    rIlen = length(rIlist);
    flaglen = length(quantiFlag);
    for r = 1 : rIlen
        rIlist(r) = 2 * rIlist(r) + quantiFlagOld(r);
    end
    for f = rIlen + 1 : flaglen
        rIlist(f) = 1;
    end
    quantiFlagOld = quantiFlag;
end