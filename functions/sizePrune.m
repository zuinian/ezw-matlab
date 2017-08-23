

%{
对输入图像X进行修剪，使得其长宽都能被2^dim整除
%}
function X = sizePrune(X, dim)
    %对X进行修剪，使其能被2^dim整除
    divide = 2 ^ dim;
    sizeX = size(X);
    for i = sizeX(1)  : -1 : 1
        if  isequal(mod(sizeX(1), divide), 0)
            break;
        end
        sizeX(1) = sizeX(1) - 1;
    end
    for i = sizeX(2) : -1 : 1
        if isequal(mod(sizeX(2), divide), 0)
            break;
        end
        sizeX(2) = sizeX(2) - 1;
    end
    X = wkeep(X, sizeX, 'c');
end