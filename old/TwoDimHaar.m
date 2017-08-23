function OutPic=TwoDimHaar(InPic,J) %对输入序列In做j尺度的一维离散小波变换
%判断输入序列in是否为一维序列，不是则不执行
[m,n]=size(InPic);
InPic=double(InPic);
%下面是一位小波变换的判断语句可以注释掉o(∩_∩)o...
% if(m~=1)
%     disp('请输入一维序列！');
% end
%判断输入参数数量，若只有一个，则j值默认为1
if nargin==1
    J= 1;
end;
OutPic=InPic;
%进行J—尺度哈尔小波变换
N=n/2;
M=m/2;
for k=1:J
    %哈尔小波行变换
    for i=1:m
        for j=1:N
            OutPic(i,j)=[InPic(i,2*j-1)+InPic(i,2*j)]/1.414;
            OutPic(i,N+j)=[InPic(i,2*j-1)-InPic(i,2*j)]/1.414;
        end
    end
    figure,imshow(OutPic),title('行变换后');

    %判断是否剩一个像素
    if(N==1)
        disp('经过变换此时只剩一个像素');
    end
    InPic=OutPic;
    %哈尔列变换
    for j=1:n
        for i=1:M
            OutPic(i,j)=[InPic(2*i-1,j)+InPic(2*i,j)]/1.414;
            OutPic(M+i,j)=[InPic(2*i-1,j)-InPic(2*i,j)]/1.414;
        end
    end


    %判断是否剩一个像素
    if(M==1)
        disp('经过变换此时只剩一个像素');
    end
    M=M/2;
    N=N/2;
    m=m/2;
    n=n/2;
    InPic=OutPic;
    figure,imshow(OutPic),title('列变换后');
end
OutPic=uint8(OutPic);
%显示出变换后的图像，因为变换后图像过暗，故每个像素加100，增加其亮度
figure,imshow(abs(OutPic)+100),title('变换后图'),imwrite(OutPic,'变换.jpg');
