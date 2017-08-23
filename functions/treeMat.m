%{
获取指定点的子孙列表——这个函数是一个递归函数
@param r int 行数 
@param c int 列数
@return cP 矩阵 n行2列 格式如:[r1 c1; r2 c2; r3 c3...]
%}
function cP = treeMat(r, c)    
    global row col dim;        % dim是小波分解级数 
    HLL = row/2^dim;  WLL=col/2^dim;  
    if (r <= HLL)&&(c <= WLL)      
        tp1 = [r, c + WLL ; r + HLL, c ; r + HLL, c + WLL];      
        cP = [tp1 ; treeMat(r, c + WLL) ; treeMat(r + HLL, c) ; treeMat(r + HLL, c + WLL)]; 
    elseif (r > row / 2) || (c > col / 2)     
        cP = []; 
    else
        tp = [ 2 * r - 1, 2 * c - 1; 2 * r - 1, 2 * c; 2 * r, 2 * c - 1; 2 * r, 2 * c];
        tm1 = [];
        tm2 = [];
        tm3 = [];
        tm4 = [];
        if (tp(4, 1) <= row / 2) && (tp(4, 2) <= col / 2)         
            t1 = treeMat(tp(1, 1), tp(1, 2));          
            tm1 = [tm1;t1];           
            t2 = treeMat(tp(2, 1), tp(2, 2));        
            tm2 = [tm2;t2];          
            t3 = treeMat(tp(3, 1), tp(3, 2));          
            tm3 = [tm3 ; t3];           
            t4 = treeMat(tp(4, 1), tp(4, 2));        
            tm4 = [tm4 ; t4];      
        end
        cP = [tp ; tm1 ; tm2 ; tm3 ; tm4];  
    end
end
