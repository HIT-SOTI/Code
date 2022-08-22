%原图
G1=imread("licensePlate1.jpg");
subplot(4,4,1),imshow(G1),title("原图");
%灰度化
G2=rgb2gray(G1);
subplot(4,4,2),imshow(G2),title("灰度图");
%直方图
subplot(4,4,3),imhist(G2),title("灰度图的直方图");
%二值化
G3=im2bw(G2,0.4);
subplot(4,4,4),imshow(G3),title("二值化 阈值0.4");
%旋转图像
G4=imrotate(G3,2,'bilinear','crop');%2是试出来的
subplot(4,4,5),imshow(G4),title("旋转图像");

se1=strel('disk',1);
se2=strel('line',2,90);
se3=strel('cube',4);
%腐蚀
G5=imerode(G4,se1);
subplot(4,4,6),imshow(G5),title('二值图像腐蚀后');
%闭运算
G6 =imclose(G5,se2);
subplot(4,4,7),imshow(G6),title('二值图像闭运算后');
%把与图像边界相连接的像素全部清除（可以不做G5 G6步，直接做这一步，去除车牌边框）
G7=imclearborder(G6);
subplot(4,4,8),imshow(G7),title('把与图像边界相连接的像素全部清除');
%膨胀
G8=imdilate(G7,se3);
subplot(4,4,9),imshow(G8),title('膨胀1次后的图像');
G8=imdilate(G8,se3);
subplot(4,4,10),imshow(G8),title('膨胀2次后的图像');
%删除小于400后的图像
G9=bwareaopen(G8,400);
subplot(4,4,11),imshow(G9),title('删除小于400后的图像');

%切割
G10=cutG(G9);
subplot(4,4,12),imshow(G10),title('切割后图片');

histcol=sum(G10); %计算垂直投影
histrow=sum(G10'); %计算水平投影
subplot(4,4,13),bar(histcol);title('垂直投影（旋转后）');
subplot(4,4,14),bar(histrow);title('水平投影（旋转后）');

H=hProject(G10);
[Hh,Hw]=size(H);
disp([Hh,Hw]);
start = 0;
h_start= [];
h_end =[];
position = [];

for i=1:Hw
    if H(1,i)>0 && start==0
        h_start=[h_start i];
        start=1;
    end
    if H(1,i)==0 && start==1
        h_end=[h_end i];
        start=0;
    end
end

disp(h_end);

wstart = 0;
wend=0;
w_start= 0;
w_end =0;
stattLen=size(start);
for i=1:stattLen
    cImg=imcrop(G10,[h_end(i),Hw,h_end(i)-h_start(i),Hw]);
%     cImg=G10(h_start(i):h_end(i),0:Hw);
    if i==0
        figure,imshow(cImg);
        imwrite(cImg,"cImg.jpg");
    end
    ww=wProject(cImg);
    for j=1:ww
        if ww(1,j)>0 && wstart==0
            w_start=j;
            wstart=1;
            wend=0;
        end
        if ww(1,j)==0 && wstart==1
            w_end=j;
            wstart=0;
            wend=1;
        end

        %确认起点和终点后保存坐标
        if wend==1
            position=[position [w_start,h_start(i),w_end,h_end(j)]];
            wend=0;
        end
    end
end

disp(position);

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


function ha=hProject(b)
[h,w]=size(b);
disp([h,w]);
ha=false(1,h);
for i=1:h
    for j=1:w
        if b(i,j)==0
            ha(1,j)=1;
        end
    end
end
end

function wa=wProject(b)
[h,w]=size(b);
disp([h,w]);
wa=false(1,w);
for i=1:w
    for j=1:h
        if b(j,i)==0
            wa(1,i)=1;
        end
    end
end
end