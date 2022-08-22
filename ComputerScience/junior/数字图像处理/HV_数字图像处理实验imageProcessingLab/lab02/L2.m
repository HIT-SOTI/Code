I = imread('Cameraman.tif');%读文件Cameraman.tif
figure(1)%建立一个新窗口Figure1
imshow(I)%在Figure1中显示图像I
J = dct2(I);%dct2 函数实现离散余弦变换
figure(2)%建立一个新窗口Figure2
imshow(log(abs(J)),[])%显示J，将J的最大值和最小值分别对应纯白(255)和纯黑(0)，中间值按比例映射
figure(3);%建立一个新窗口Figure3
J(abs(J) < 10) = 0;%离散余弦变换后丢弃绝对值小于10的值（置0）
K = idct2(J)/255;%进行图像的二维逆离散余弦变换
imshow(K)%在Figure1中显示图像K
figure(4);
for i=1:1:6
    %将矩阵J中的小于10*j的值置0
    J(abs(J) < 10*i) = 0;
    %图像的二维逆离散余弦变换
    K = idct2(J)/255;
subplot(2,3,i),imshow(K),title(10*i);
end
