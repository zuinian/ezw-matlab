
%{
将小波变换后的系数由矩阵格式转成默认格式---为c2mat的逆函数
@param cAllDecode 待转换系数矩阵
@param s 小波变换后的参数

@return c 小波变换后的参数，单行形式
%}
function c = mat2c(cAllDecode, s)
    c = [];
    %先转换低频系数
    for perColumn = 1 : s(1, 2)
        %先按列后按行排序的
            for perRow = 1 : s(1, 1)
                c = [c cAllDecode(perRow, perColumn)];
            end
    end
    
    for i = 2 : length(s) - 1
        %转换水平高频系数
        for perColumn = 1 : s(i, 2)
            for perRow = 1 : s(i, 1)
                c = [c cAllDecode(perRow , perColumn + sum(s(1 : i - 1,2)))];
            end
        end
        
        %转换垂直高频系数
        for perColumn = 1 : s(i, 2)
            for perRow = 1 : s(i, 1)
                c = [c cAllDecode(perRow + sum(s(1 : i - 1,1)), perColumn)];
            end
        end
        %转换斜角高频系数
        for perColumn = 1 : s(i, 2)
            for perRow = 1 : s(i, 1)
                c = [c cAllDecode(perRow + sum(s(1 : i - 1,1)), perColumn + sum(s(1 : i - 1,2)))];
            end
        end
    end
end