%{
主扫描
@param Mat 系数矩阵
@param scanList 扫描次序表n行4列，id 行号 列号 对应系数值
@param flagList 扫描标记表，大小与系数矩阵一样，记录的是每个系数的类型
@param imptValue 重要系数值列表，n行3列，值，行，列
@param imptFlag 重要系数标志，P或N组成的一行
@param threshold 本次扫描阈值

@return imptValue 同上
@return imptFlag 同上
@return scanCode 对本次扫描过的节点类型做的记录，四种类型P、N、Z、T
@return flagListBak 为刚扫描完的flagList的备份
@return flagList 将扫描后的值改成O或着Z两种（重要或者不重要），供下一次扫描使用
%}
function  [imptValue, imptFlag, scanCode, flagListBak, flagList] = mainScan(Mat, scanList, flagList, imptValue, imptFlag, threshold) 
    global row col ;
    scanCode=[];
    for i = 1 : row * col
        if flagList(scanList(i, 2), scanList(i, 3)) == 'O' %重要系数跳过，这个在第二次扫描时用到
            continue; 
        elseif abs(scanList(i, 4)) >= threshold %与阈值比较
            if scanList(i,4)>=0 %正重要系数
                flagList(scanList(i,2), scanList(i,3))='P';
                scanCode  = [scanCode 'P'];
                imptValue = [imptValue ; abs(scanList(i,4)), scanList(i,2), scanList(i,3)];
                imptFlag = [imptFlag 'P'];
            else %负重要系数
                flagList(scanList(i,2),scanList(i,3))='N';
                scanCode=[scanCode 'N']; 
                imptValue=[imptValue;abs(scanList(i,4)),scanList(i,2),scanList(i,3)];
                imptFlag=[imptFlag 'N'];
            end
        else %比阈值小的
            if flagList(scanList(i,2),scanList(i,3))=='X'  %零树的子孙直接跳过
                continue;
            elseif i > row*col/4 %处于第一分解级，没有子孙系数
                scanCode=[scanCode 'T'];
            else %判断子孙节点是否存在比阈值大的
                [chImt,chMat] = childImportant(Mat, scanList(i,2), scanList(i,3), threshold);
                if chImt %孤立零点
                    flagList(scanList(i,2),scanList(i,3))='Z';
                    scanCode=[scanCode 'Z'];
                else %零树
                    flagList(scanList(i,2),scanList(i,3))='T';
                    scanCode=[scanCode 'T'];
                    [rowch,colch]=size(chMat);
                    for r=1:rowch
                        if flagList(chMat(r,1), chMat(r,2)) ~= 'O'
                            flagList(chMat(r,1), chMat(r,2)) = 'X';
                        end
                    end
                end
            end
        end
    end
    flagListBak=flagList;
    for r=1:row
        for c=1:col
            switch flagList(r,c)
                case {'P','N'}
                    flagList(r,c)='O';
                case {'X','T'}
                    flagList(r,c)='Z';
            end
        end
    end
end

