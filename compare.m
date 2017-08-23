X = imread('D:\matlab\images\lena-128.bmp');
fileName = 'lena.png';
imwrite(X, fileName);
Y = imread(fileName);
ssimV = ssim(X, Y);
psnrV = psnr(X, Y);