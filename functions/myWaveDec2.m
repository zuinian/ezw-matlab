function [cAll, sAll] = myWaveDec2(X, dim, waveName)
    [lpd, hpd] = wfilters('haar', 'd');
    lf = length(lpd);
    tmpX = double(X);
    [row, col] = size(X);
    cAll = [];%存放系数集合，后面会变成胞元
    sAll = [row, col];%存放每层的系数矩阵大小
    for i = 1 : dim
        [ca, ch, cv, cd] = myDwt2(tmpX, lpd, hpd);
        tmpX = ca;
        cTmp = {ch ; cv ; cd};
        cAll = [cTmp ; cAll];
        sAll = [size(cv) ; sAll];
    end
    cAll = [ca ; cAll];
    sAll = [size(ca) ; sAll];
end