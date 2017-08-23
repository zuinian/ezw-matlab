%{
%辅扫描
@param imptValue 重要系数矩阵：n行3列 值、行、列
@param level int 第n次扫描
@param T1 初始阈值
@return quantiList 量化矩阵 n行5列：重要系数值、量化标志（1或0）、量化值、行、列
%}
function [quantiList, quantiFlag, recvalue, quantifierMat] = assistScan(imptValue, level, T1)
    %初始化
    quantiList = [];
    quantiFlag = [];
    recvalue = [];
    
    %获取量化器
    [quantifierMat, threshold] = quantifier(T1, level);

    [imRow, imCol] = size(imptValue);
    for j=1 : imRow
        rI = floor(imptValue(j) / threshold);%先找出在哪个区间
        flag01 = imptValue(j) - rI*threshold;
        if flag01 < threshold / 2
            quantiFlag = [quantiFlag ; 0];
            recvalue = [recvalue ; quantifierMat(rI, 1)];
        else
            quantiFlag = [quantiFlag ; 1];
            recvalue = [recvalue ; quantifierMat(rI , 2)];
        end
    end
    quantiList = [imptValue(:, 1), quantiFlag, recvalue, imptValue(:, 2), imptValue(:, 3)];
end