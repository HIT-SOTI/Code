RGB=imread('1.jpg');
I=rgb2gray(RGB);
subplot(1,2,1),subimage(RGB) %subimage ʵ����һ��ͼ�δ�������ʾ���ͼ��
subplot(1,2,2),subimage(I)
