RGB=imread('1.jpg');
I=rgb2gray(RGB);
subplot(1,2,1),subimage(RGB) %subimage 实现在一个图形窗口中显示多幅图像
subplot(1,2,2),subimage(I)
