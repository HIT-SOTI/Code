% A=imread('4.jpg'); %����ͼ��
% B=rgb2gray(A); %��RGB ͼ��ת���ɻҶ�ͼ��
% subplot(2,2,1),imshow(B); %��ʾ�Ҷ�ͼ��
% subplot(2,2,2),imhist(B); %��ʾ�Ҷ�ͼ���ֱ��ͼ
% 
% C=histeq(B); %��ͼ��B ���о��⻯
% subplot(2,2,3),imshow(C); %��ʾͼ��
% subplot(2,2,4),imhist(C); %�õ����⻯��ĻҶ�ֱ��ͼ


% I=imread('4.jpg');
% figure;
% subplot(1,3,1);
% imshow(I);
% title('ԭͼ');
% J=imadjust(I,[0.3;0.6],[0.1;0.9]); 
% %��������/����任�ĻҶȼ���Χ��a=0.3, b=0.6, c=0.1, d=0.9��
% subplot(1,3,2);
% imshow(J);
% title('����ӳ��');
% I1=double(I); 
% I2=I1/255; 
% C=2;% ���÷�����ӳ�亯���Ĳ���c=2��
% K=C*log(1+I2); %��ͼ��Ķ����任
% subplot(1,3,3);
% imshow(K);
% title('������ӳ��');
% M=255-I; %����ͼ��ȡ��
% figure;
% subplot(1,3,1);
% imshow(M);
% title('�Ҷȵ���');
% N1=im2bw(I,0.4); %����ͼ���ֵ������ֵΪ0.4
% N2=im2bw(I,0.7); %����ͼ���ֵ������ֵΪ0.7
% subplot(1,3,2);
% imshow(N1);
% title('��ֵ����ֵ0.4');
% subplot(1,3,3);
% imshow(N2);
% title('��ֵ����ֵ0.7');


% a=imread('4.jpg');
% I=rgb2gray(a);
% imshow(I);
% % P1=imnoise(I,'gaussian',0.02);
% P1=imnoise(I,'salt & pepper',0.09);
% K1=filter2(fspecial('average',3),P1)/255; %3��3 �ľ�ֵ�˲�
% K2=filter2(fspecial('average',5),P1)/255; %5��5 �ľ�ֵ�˲�
% K3=filter2(fspecial('average',7),P1)/255; %7��7 �ľ�ֵ�˲�
% figure,imshow(K1);
% figure,imshow(K2);
% figure,imshow(K3);


% a=imread('4.jpg');
% I=rgb2gray(a);
% imshow(I);
% % P1=imnoise(I,'gaussian',0.02);
% P1=imnoise(I,'salt & pepper',0.09);
% K1=medfilt2(P1,[3,3]); %3��3 ��ֵ�˲�
% K2=medfilt2(P1,[5,5]); %5��5 ��ֵ�˲�
% K3=medfilt2(P1,[7,7]); %7��7 ��ֵ�˲�
% figure,imshow(K1);
% figure,imshow(K2);
% figure,imshow(K3);

% 
% f=zeros(100,100);
% f(20:70,40:60)=1;
% imshow(f);
% F=fft2(f); 
% F2=log(abs(F)); %�Է�ֵȡ����
% imshow(F2),colorbar


% f=zeros(100,100);
% f(20:70,40:60)=1;
% imshow(f);
% F=fft2(f,256,256);
% F2=fftshift(F); %ʵ�ֲ������
% imshow(log(abs(F2)));



I=imread('cameraman.tif'); 
%I=rgb2gray(I);
subplot(1,6,1),imshow(I),title("ԭͼ");
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
