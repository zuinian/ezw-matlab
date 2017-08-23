function OutPic=ITwoDimHaar(InPic,J)
[m,n]=size(InPic);
InPic=double(InPic);
OutPic=InPic;
%判断变换尺度
if (2^J>n)
    disp('尺度变换过大，请重新输入J！');
end
%判断输入维数可以注释掉
% if (m~=1)
%     disp('输入维数不合理，请输入一维数据！');
% end
N=n/(2^(J-1));
M=m/(2^(J-1));
% OutPic=InPic*1.414;
% M=n/2;
for k=1:J
    if ((M==1)||(N==1))
        break;
    else
        %进行列变换
        for j=1:N
            for i=1:M/2
                %                 OutPic(i,j)=OutPic(i,j)*1.414;
                %                 InPic=OutPic;
                %先乘以1.414再比上2，等于直接处以1.414
                OutPic(2*i-1,j)=(InPic(i,j)+InPic(M/2+i,j))/1.414;
                OutPic(2*i,j)=(InPic(i,j)-InPic(M/2+i,j))/1.414;
            end
        end
        InPic=OutPic;
        figure, imshow(OutPic),title('列变换后');
        %进行行变换
        for i=1:M
            for j=1:N/2
                %                 OutPic(i,j)=OutPic(i,j)*1.414;
                %                 InPic=OutPic;
                OutPic(i,2*j-1)=(InPic(i,j)+InPic(i,M/2+j))/1.414;
                OutPic(i,2*j)=(InPic(i,j)-InPic(i,M/2+j))/1.414;
            end
        end
        InPic=OutPic;
        figure, imshow(OutPic),title('行变换后');
    end
    N=2*N;
    M=2*M;
end
% OutPic=uint8(OutPic);
% figure,imshow(OutPic),title('变换后图'),imwrite(OutPic,'逆变换.jpg');