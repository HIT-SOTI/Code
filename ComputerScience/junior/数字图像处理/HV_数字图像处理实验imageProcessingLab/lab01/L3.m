% I=imread('3.jpg');
% J=imadd(I,100); %给图像增加亮度
% K=imadd(J,100);
% L=imadd(I,-100);
% subplot(3,2,1),imshow(I);
% subplot(3,2,2),imshow(J);
% subplot(3,2,3),imshow(K);
% subplot(3,2,4),imshow(L);
% 
% M=imadd(I,L);
% N=imadd(I,J);
% subplot(3,2,5),imshow(M);
% subplot(3,2,6),imshow(N);

% I=imread('1.jpg');
% J=imsubtract(I,100); %给图像减少亮度
% K=imsubtract(J,100);
% L=imsubtract(I,-100);
% subplot(3,2,1),imshow(I);
% subplot(3,2,2),imshow(J);
% subplot(3,2,3),imshow(K);
% subplot(3,2,4),imshow(L);
% M=imadd(I,L);
% N=imadd(I,J);
% subplot(3,2,5),imshow(M);
% subplot(3,2,6),imshow(N);

% I=imread('1.jpg');
% J=immultiply(I,100); 
% K=immultiply(J,100);
% L=immultiply(I,-100);
% subplot(3,2,1),imshow(I);
% subplot(3,2,2),imshow(J);
% subplot(3,2,3),imshow(K);
% subplot(3,2,4),imshow(L);
% M=immultiply(I,L);
% N=immultiply(I,J);
% subplot(3,2,5),imshow(M);
% subplot(3,2,6),imshow(N);

I=imread('1.jpg');
J=imdivide(I,100); 
K=imdivide(J,100);
L=imdivide(I,-100);
subplot(3,2,1),imshow(I);
subplot(3,2,2),imshow(J);
subplot(3,2,3),imshow(K);
subplot(3,2,4),imshow(L);
M=imdivide(I,L);
N=imdivide(I,J);
subplot(3,2,5),imshow(M);
subplot(3,2,6),imshow(N);