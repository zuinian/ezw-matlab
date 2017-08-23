%{
嵌入式零数小波编码函数
@param scanTimes int 扫描次数
@param cAll 系数矩阵
@return scanCodes 每次主扫描内容集合
@return quantiFlags 每次辅扫描生成的重要系数标志集合（0/1序列集合）
@return perScanNums 记录每次扫描的scanCode个数与quantiFlag个数,
perScanNums（1,1）是扫描次数，perScanNums（1,2）是初始阈值，后面可以考虑去掉这行
接着每行2个值，记录canCode个数与quantiFlag个数
%}

function [scanCodes, quantiFlags, perScanNums] = ezwEncode(cAll, T, scanTimes, handles)
    global row col;
    %获取扫描次序表
    scanList = morton(cAll);

    %初始化
    flagList(1 : row, 1 : col) = 'Z';
    imptValue = [];
    imptFlag = [];
    scanCodes = '';%保存每次主扫描的scanCode
    quantiFlags = [];%保存每次辅扫描的quantiFlag
    perScanNums = [];
    
    for i = 1 : scanTimes
        set(handles.text6, 'string', ['进度条：正在进行第' num2str(i) '次编码']);
        pause(0.1);
        %主扫描
        [imptValue, imptFlag, scanCode, flagListBak, flagList] = mainScan(cAll, scanList, flagList, imptValue, imptFlag, T(i));
        scanCodes = [scanCodes scanCode];
        %辅扫描
        [quantiList, quantiFlag, recvalue, quantifierMat] = assistScan(imptValue, i, T(1));
        quantiFlags = [quantiFlags quantiFlag'];
        perScanNums = [perScanNums ; length(scanCode) length(quantiFlag)];
    end
    %编码输出

end