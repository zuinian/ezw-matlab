%{
判断某节点是否为重要系数
@param Mat 系数矩阵
@param chRows int 行号
@param chCols   int 列号
@param threshold int 阈值

@return chImt int 1/0
@return chMat 子孙节点矩阵，n行3列，行、列、值
%}
function  [chImt, chMat] = childImportant(Mat, chRows, chCols, threshold)
    chMat = childMat(Mat,chRows,chCols);
    if max(abs(chMat(:, 3))) >= threshold %chMat第三列即为系数值
        chImt = 1;
    else
        chImt = 0;
    end
end