%原图
G1=imread("licensePlate1.jpg");
subplot(3,4,1),imshow(G1),title("原图");
%灰度化
G2=rgb2gray(G1);
subplot(3,4,2),imshow(G2),title("灰度图");
%直方图
subplot(3,4,3),imhist(G2),title("灰度图的直方图");
%二值化
G3=im2bw(G2,0.4);
subplot(3,4,4),imshow(G3),title("二值化 阈值0.4");
%旋转图像
G4=imrotate(G3,2,'bilinear','crop');%2是试出来的
subplot(3,4,5),imshow(G4),title("旋转图像");

% histcol=sum(G4); %计算垂直投影
% histrow=sum(G4'); %计算水平投影
% subplot(3,4,6),bar(histcol);title('垂直投影（旋转后）');
% subplot(3,4,7),bar(histrow);title('水平投影（旋转后）');

se1=strel('disk',1);
se2=strel('line',2,90);
se3=strel('cube',4);
%腐蚀
G5=imerode(G4,se1);
subplot(3,4,6),imshow(G5),title('二值图像腐蚀后');
%闭运算
G6 =imclose(G5,se2);
subplot(3,4,7),imshow(G6),title('二值图像闭运算后');
%把与图像边界相连接的像素全部清除（可以不做G5 G6步，直接做这一步，去除车牌边框）
G7=imclearborder(G6);
subplot(3,4,8),imshow(G7),title('把与图像边界相连接的像素全部清除');
%膨胀
G8=imdilate(G7,se3);
subplot(3,4,9),imshow(G8),title('膨胀1次后的图像');
G8=imdilate(G8,se3);
subplot(3,4,10),imshow(G8),title('膨胀2次后的图像');
%删除小于400后的图像
G9=bwareaopen(G8,400);
subplot(3,4,11),imshow(G9),title('删除小于400后的图像');

G10=cutG(G9);
subplot(3,4,12),imshow(G10),title('切割后图片');
[word1,G10]=getword(G10);% 分割出第二个字符
[word2,G10]=getword(G10);% 分割出第二个字符
[word3,G10]=getword(G10);% 分割出第三个字符
[word4,G10]=getword(G10);% 分割出第四个字符
[word5,G10]=getword(G10);% 分割出第五个字符
[word6,G10]=getword(G10);% 分割出第六个字符
[word7,G10]=getword(G10);% 分割出第七个字符
[word8,G10]=getword(G10);% 分割出第八个字符

figure;
histcol=sum(G9); %计算垂直投影
histrow=sum(G9'); %计算水平投影
subplot(2,1,1),bar(histcol);title('垂直投影（旋转后）');
subplot(2,1,2),bar(histrow);title('水平投影（旋转后）');

figure;
subplot(2,4,1),imshow(word1);
subplot(2,4,2),imshow(word2);
subplot(2,4,3),imshow(word3);
subplot(2,4,4),imshow(word4);
subplot(2,4,5),imshow(word5);
subplot(2,4,6),imshow(word6);
subplot(2,4,7),imshow(word7);
subplot(2,4,8),imshow(word8);

word1=imresize(word1,[150,100]);
word2=imresize(word2,[150,100]);
word3=imresize(word3,[150,100]);
word4=imresize(word4,[150,100]);
word5=imresize(word5,[150,100]);
word6=imresize(word6,[150,100]);
word7=imresize(word7,[150,100]);
word8=imresize(word8,[150,100]);

figure;
subplot(2,4,1),imshow(word1);
subplot(2,4,2),imshow(word2);
subplot(2,4,3),imshow(word3);
subplot(2,4,4),imshow(word4);
subplot(2,4,5),imshow(word5);
subplot(2,4,6),imshow(word6);
subplot(2,4,7),imshow(word7);
subplot(2,4,8),imshow(word8);


bm=256;
hG=100;
wG=150;
F=[];
black=zeros(bm,bm);
figure,imshow(black),title("构建黑色背景");
figure;
black((bm-wG)/2:(bm-wG)/2+wG-1,(bm-hG)/2:(bm-hG)/2+hG-1)=word1;
subplot(2,8,1),imshow(black),title("1");
subplot(2,8,1+8),imshow(log(abs(fftshift(fft2(black,256,256)))),[]),title("1");
black((bm-wG)/2:(bm-wG)/2+wG-1,(bm-hG)/2:(bm-hG)/2+hG-1)=word2;
subplot(2,8,2),imshow(black),title("2");
subplot(2,8,2+8),imshow(log(abs(fftshift(fft2(black,256,256)))),[]),title("2");
black((bm-wG)/2:(bm-wG)/2+wG-1,(bm-hG)/2:(bm-hG)/2+hG-1)=word3;
subplot(2,8,3),imshow(black),title("3");
subplot(2,8,3+8),imshow(log(abs(fftshift(fft2(black,256,256)))),[]),title("3");
black((bm-wG)/2:(bm-wG)/2+wG-1,(bm-hG)/2:(bm-hG)/2+hG-1)=word4;
subplot(2,8,4),imshow(black),title("4");
subplot(2,8,4+8),imshow(log(abs(fftshift(fft2(black,256,256)))),[]),title("4");
black((bm-wG)/2:(bm-wG)/2+wG-1,(bm-hG)/2:(bm-hG)/2+hG-1)=word5;
subplot(2,8,5),imshow(black),title("5");
subplot(2,8,5+8),imshow(log(abs(fftshift(fft2(black,256,256)))),[]),title("5");
black((bm-wG)/2:(bm-wG)/2+wG-1,(bm-hG)/2:(bm-hG)/2+hG-1)=word6;
subplot(2,8,6),imshow(black),title("6");
subplot(2,8,6+8),imshow(log(abs(fftshift(fft2(black,256,256)))),[]),title("6");
black((bm-wG)/2:(bm-wG)/2+wG-1,(bm-hG)/2:(bm-hG)/2+hG-1)=word7;
subplot(2,8,7),imshow(black),title("7");
subplot(2,8,7+8),imshow(log(abs(fftshift(fft2(black,256,256)))),[]),title("7");
black((bm-wG)/2:(bm-wG)/2+wG-1,(bm-hG)/2:(bm-hG)/2+hG-1)=word8;
subplot(2,8,8),imshow(black),title("8");
subplot(2,8,8+8),imshow(log(abs(fftshift(fft2(black,256,256)))),[]),title("8");


figure;
subplot(2,5,1),imshow(black),title("原图");
subplot(2,5,1+5),imshow(log(abs(fftshift(fft2(black,256,256)))),[]),title("原图");
black2=zeros(bm,bm);
black2((bm-wG)/2-30:(bm-wG)/2+wG-1-30,(bm-hG)/2:(bm-hG)/2+hG-1)=word8;
subplot(2,5,2),imshow(black2),title("平移");
subplot(2,5,2+5),imshow(log(abs(fftshift(fft2(black,256,256)))),[]),title("平移");
black3=imrotate(black2,45,'bilinear');%90
subplot(2,5,3),imshow(black3),title("旋转");
subplot(2,5,3+5),imshow(log(abs(fftshift(fft2(black3,256,256)))),[]),title("旋转");
black4=zeros(bm,bm);
nh=226;
nw=150;
word9=imresize(word8,[nh,nw]);
black4((bm-nh)/2:(bm-nh)/2+nh-1,(bm-nw)/2:(bm-nw)/2+nw-1)=word9;
subplot(2,5,4),imshow(black4),title("放大");
subplot(2,5,4+5),imshow(log(abs(fftshift(fft2(black4,256,256)))),[]),title("放大");
black5=~black;
subplot(2,5,5),imshow(black5),title("取反");
subplot(2,5,5+5),imshow(log(abs(fftshift(fft2(black5,256,256)))),[]),title("取反");



function [word,result]=getword(d)
word=[];
flag=0;
y1=8;
y2=0.5;
while flag==0
    [m,n]=size(d); % 求行列
    wide=0;
    while sum(d(:,wide+1))~=0 && wide<=n-2  %有白色加1知道没有白色，也就是找出一个白色区域
        wide=wide+1;
    end
    temp=cutG(imcrop(d,[1 1 wide m])); %切出第一个字符
    [m1,n1]=size(temp);
    if wide<y1 && n1/m1>y2  %像素小于  或 切割字体大小 列除以行
        d(:,[1:wide])=0;  % 第一个涂黑
        if sum(sum(d))~=0
            d=cutG(d);  % 切割出最小范围
        else
            word=[];flag=1;
        end
    else
        word=cutG(imcrop(d,[1 1 wide m]));
        d(:,[1:wide])=0;
        if sum(sum(d))~=0
            d=cutG(d);flag=1;
        else
            d=[];
        end
    end
end
result=d;
end

%切割
function e=cutG(d)
[m,n]=size(d);
top=1;bottom=m;left=1;right=n;   % init
while sum(d(top,:))==0 && top<=m     %切割出白色区域（横切）
    top=top+1;
end
while sum(d(bottom,:))==0 && bottom>1   %同上
    bottom=bottom-1;
end
while sum(d(:,left))==0 && left<n        %切割出白区域（纵切）
    left=left+1;
end
while sum(d(:,right))==0 && right>=1
    right=right-1;
end
dd=right-left;
hh=bottom-top;
e=imcrop(d,[left top dd hh]);
end
