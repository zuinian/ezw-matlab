 %{
获取指定矩阵的scanList
@param Mat 系数矩阵
@return scanList 
%}
  function scanList = morton(Mat)
    global row col   
    matlist = mat2list(Mat);   
    scanorder = listOrder(row,col,1,1);  
    scanList = [];  
    %{
    %10万条以下用这个——数据量上10万就特别慢
    
    for i = 1 : row * col       
        scanList = [scanList; i scanorder(i,:) matlist(i)];  
    end
    %}
    %10万条以上用这个
    id = [1 : row * col];
    id = id';
    scanList = [id scanorder matlist];
    
  end 
  