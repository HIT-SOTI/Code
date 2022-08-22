% J=imread('1.jpg');
% %X1=imresize(J,2); %对图像进行缩放
% %figure,imshow(J);
% info=imfinfo('1.jpg');
% w=info.Width;
% h=info.Height;
% 
% X2=imresize(J,[20,50]);
% figure,imshow(X2);

% I=imread('2.jpg');
% J=imrotate(I,45,'bilinear'); %对图像进行旋转
% subplot(1,2,1),imshow(I);
% subplot(1,2,2),imshow(J);

% I=imread('2.jpg');
% imwrite(I,'4.jpg');%拷贝副本供后续实验
% I2=imcrop(I,[75 68 130 112]); %对图像进行剪切
% subplot(1,2,1),imshow(I);
% subplot(1,2,2),imshow(I2);

a=imread('2.jpg');
I=rgb2gray(a);
BW=roicolor(I,128,225); %按灰度值选择的区域
BW2=roicolor(I,64,255);
BW3=roicolor(I,64,192);
subplot(2,2,1),imshow(I);
subplot(2,2,2),imshow(BW);
subplot(2,2,3),imshow(BW2);
subplot(2,2,4),imshow(BW3);

