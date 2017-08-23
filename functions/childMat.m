%{
获取指定点的子孙列表以及对应值——这个是对上一个函数treeMat的封装
@param Mat 系数矩阵
@param chRows int 行数 
@param chRows int 列数
@return chMat 矩阵 n行3列 格式如:[r1 c1 v1; r2 c2 v2; r3 c3 v3...]
%}
 function chMat = childMat(Mat, chRows, chCols)
     chPoint = treeMat(chRows, chCols); 
     chMat = [];  
     [mRows, mCols] = size(chPoint);  
     for iRows = 1 : mRows     
         chMat = [chMat ; chPoint(iRows, 1), chPoint(iRows, 2), Mat(chPoint(iRows, 1), chPoint(iRows, 2))]; 
     end
 end
 