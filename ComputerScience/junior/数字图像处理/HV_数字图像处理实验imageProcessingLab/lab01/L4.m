% A=imread('4.jpg'); %读入图像
% B=rgb2gray(A); %把RGB 图像转化成灰度图像
% subplot(2,2,1),imshow(B); %显示灰度图像
% subplot(2,2,2),imhist(B); %显示灰度图像的直方图
% 
% C=histeq(B); %对图像B 进行均衡化
% subplot(2,2,3),imshow(C); %显示图像
% subplot(2,2,4),imhist(C); %得到均衡化后的灰度直方图


% I=imread('4.jpg');
% figure;
% subplot(1,3,1);
% imshow(I);
% title('原图');
% J=imadjust(I,[0.3;0.6],[0.1;0.9]); 
% %设置输入/输出变换的灰度级范围，a=0.3, b=0.6, c=0.1, d=0.9。
% subplot(1,3,2);
% imshow(J);
% title('线性映射');
% I1=double(I); 
% I2=I1/255; 
% C=2;% 设置非线性映射函数的参数c=2。
% K=C*log(1+I2); %求图像的对数变换
% subplot(1,3,3);
% imshow(K);
% title('非线性映射');
% M=255-I; %将此图像取反
% figure;
% subplot(1,3,1);
% imshow(M);
% title('灰度倒置');
% N1=im2bw(I,0.4); %将此图像二值化，阈值为0.4
% N2=im2bw(I,0.7); %将此图像二值化，阈值为0.7
% subplot(1,3,2);
% imshow(N1);
% title('二值化阈值0.4');
% subplot(1,3,3);
% imshow(N2);
% title('二值化阈值0.7');


% a=imread('4.jpg');
% I=rgb2gray(a);
% imshow(I);
% % P1=imnoise(I,'gaussian',0.02);
% P1=imnoise(I,'salt & pepper',0.09);
% K1=filter2(fspecial('average',3),P1)/255; %3×3 的均值滤波
% K2=filter2(fspecial('average',5),P1)/255; %5×5 的均值滤波
% K3=filter2(fspecial('average',7),P1)/255; %7×7 的均值滤波
% figure,imshow(K1);
% figure,imshow(K2);
% figure,imshow(K3);


% a=imread('4.jpg');
% I=rgb2gray(a);
% imshow(I);
% % P1=imnoise(I,'gaussian',0.02);
% P1=imnoise(I,'salt & pepper',0.09);
% K1=medfilt2(P1,[3,3]); %3×3 中值滤波
% K2=medfilt2(P1,[5,5]); %5×5 中值滤波
% K3=medfilt2(P1,[7,7]); %7×7 中值滤波
% figure,imshow(K1);
% figure,imshow(K2);
% figure,imshow(K3);

% 
% f=zeros(100,100);
% f(20:70,40:60)=1;
% imshow(f);
% F=fft2(f); 
% F2=log(abs(F)); %对幅值取对数
% imshow(F2),colorbar


% f=zeros(100,100);
% f(20:70,40:60)=1;
% imshow(f);
% F=fft2(f,256,256);
% F2=fftshift(F); %实现补零操作
% imshow(log(abs(F2)));



I=imread('cameraman.tif'); 
%I=rgb2gray(I);
subplot(1,6,1),imshow(I),title("原图");
BW1=edge(I,'prewitt'); 
subplot(1,6,2),imshow(BW1,[]),title("Prewitt");
BW2=edge(I,'canny'); 
subplot(1,6,3),imshow(BW2,[]),title("Canny");
BW3=edge(I,'sobel'); 
subplot(1,6,4),imshow(BW3,[]),title("Sobel");
BW4=edge(I,'roberts'); 
subplot(1,6,5),imshow(BW4,[]),title("Roberts");
BW5=edge(I,'log'); 
subplot(1,6,6),imshow(BW5,[]),title("Log");
