%{
提高上一级解码的重要系数的重构精度
@param cAllDecode 解码矩阵系数对应值
@param recvalue 已知的重要系数值
@param qrNum 当前进行到quantiflag的第几个数
@param antiQuantiMat 逆量化器
@param rIlist 行向量 当前的quantiFlag每个值所对应的具体量化等级（一共有level^2-1个等级）
%}
function [cAllDecode, recvalue, qrNum] = updateRecvalue(cAllDecode, recvalue, qrNum, quantiflag, antiQuantiMat, rIlist)
    if ~isempty(recvalue)
        [rvRow, rvCol] = size(recvalue);
        for i = 1 : rvRow
            if quantiflag(qrNum) == 1
                qValue = antiQuantiMat(rIlist(qrNum), 2);
                if recvalue(i) < 0
                    qValue = -qValue;
                end
                recvalue(i,1)=qValue;
                % recvalue矩阵的第2、3列储存的是对应于DecodeMat中的行、列号（r,c）
                cAllDecode(recvalue(i,2),recvalue(i,3))=qValue;  
                qrNum = qrNum + 1;
            else %quantiflag(qrNum) == 0
                qValue = antiQuantiMat(rIlist(qrNum), 1);
                if recvalue(i)<0
                    qValue=-qValue;
                end
                recvalue(i,1)=qValue;
                cAllDecode(recvalue(i,2),recvalue(i,3))=qValue;
                qrNum=qrNum+1;
            end
        end
    end
end