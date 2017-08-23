%{
二维dwt
@param X 二维矩阵
@param lpd 低通滤波
@param hpd 高通滤波

@return ca ch cv cd四个部分的系数
%}
function [ca, ch, cv, cd] = myDwt2(X, lpd, hpd)
    
    %行变换
    [row, col] = size(X);
    cRow = [];
    for i = 1 : row
        perRow = X(i, :);
        [cai, cdi] = myDwt(perRow, lpd, hpd);
        % perRow 长度为ro，滤波器长度为 lf
        % 则 [cai, cdi] 的总长为 2*floor(( row + lf -1 )/2)
        cRow(i, :) = [cai cdi];
    end
    
    %列变换
    [row, col] = size(cRow);
    cAll = [];
    for j = 1 : col
        perCol = cRow(:, j)';%注意转置
        [cai, cdi] = myDwt(perCol, lpd, hpd);
        cAll(:, j) = [cai cdi]';%注意转置
    end
    
    [row, col] = size(cAll);
    ca = cAll(1 : floor(row / 2),           1 : floor(col / 2));              % ca是矩阵cAll的左上角部分
    ch = cAll(floor(row / 2) + 1 : row, 1 : floor(col / 2));             % ch是矩阵cAll的左下角部分
    cv = cAll(1 : floor(row / 2),            floor(col / 2) + 1 : col);    % cv是矩阵cAll的右上角部分
    cd = cAll(floor(row / 2) + 1 : row, floor(col / 2) + 1 : col);    % cd是矩阵cAll的右下角部分
end