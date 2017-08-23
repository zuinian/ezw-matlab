i1=imread('lena.bmp');
%i1=rgb2gray(i1);
i1=imcrop(i1,[20 20 160 160]);
i=double(i1);
[m,n]=size(i);
p=zeros(m,n);
y=zeros(m,n);
y(1:m,1)=i(1:m,1);
p(1:m,1)=i(1:m,1);
y(1,1:n)=i(1,1:n);
p(1,1:n)=i(1,1:n);
y(1:m,n)=i(1:m,n);
p(1:m,n)=i(1:m,n);
p(m,1:n)=i(m,1:n);
y(m,1:n)=i(m,1:n);
for k=2:m-1;
for l=2:n-1;
y(k,l)=(i(k,l-1)/2+i(k-1,l)/4+i(k-1,l-1)/8+i(k-1,l+1)/8);
p(k,l)=round(i(k,l)-y(k,l));
end
end
p=round(p);
subplot(3,2,1),imshow(i1);title('原灰度图像');
subplot(3,2,2),imshow(y,[0 256]);title('利用三个相邻块线性预测后的图像');
subplot(3,2,3),imshow(abs(p),[0 1]);title('编码的绝对残差图像');

j=zeros(m,n);
j(1:m,1)=y(1:m,1);
j(1,1:n)=y(1,1:n);
j(1:m,n)=y(1:m,n);
j(m,1:n)=y(m,1:n);

for k=2:m-1;
for l=2:n-1;
j(k,l)=p(k,l)+y(k,l);
end
end

for r=1:m
for t=1:n
d(r,t)=round(i1(r,t)-j(r,t));
end
end

subplot(3,2,4),imshow(abs(p),[0 1]);title('解码用的残差图像');
subplot(3,2,5),imshow(j,[0 256]);title('使用残差和线性预测重建后的图像');
subplot(3,2,6),imshow(abs(d),[0 1]);title('解码重建后图像的误差');