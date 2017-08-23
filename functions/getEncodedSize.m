
%{
@param perScanNums 记录每次扫描的scanCode个数与quantiFlag个数,
@param dim 分解级数
%}
function fileSizeOut = getEncodedSize(perScanNums, scanTimes)
    fileSizeOut = 0;
    for i = 1 : scanTimes
        %四种字符，所以每个字符2比特
        fileSizeOut = perScanNums(i, 1) * 2 + perScanNums(i, 2);
        fileSizeOut = fileSizeOut / 8 / 1024;
    end
end