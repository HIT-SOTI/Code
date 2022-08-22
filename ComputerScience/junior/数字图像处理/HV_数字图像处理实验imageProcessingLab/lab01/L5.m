a = imread('4.JPG');
a=imresize(a,[512,512]);
% imshow(a);
b = rgb2gray(a);
[wid,hei]=size(b);
%4 倍减采样
quartimg1 = zeros(wid/2+1,hei/2+1);
i1 = 1;
j1 = 1;
for i=1:2:wid
    for j=1:2:hei
        quartimg1(i1,j1) = b(i,j);
        j1 = j1 + 1;
    end
    i1 = i1 + 1;
    j1 = 1;
end
%16 倍减采样
quartimg2 = zeros(wid/4+1,hei/4+1);
i1 = 1;
j1 = 1;
for i=1:4:wid
    for j=1:4:hei
        quartimg2(i1,j1) = b(i,j);
        j1 = j1 + 1;
    end
    i1 = i1 + 1;
    j1 = 1;
end
%64 倍减采样
quartimg3 = zeros(wid/8+1,hei/8+1);
i1 = 1;
j1 = 1;
for i=1:8:wid
    for j=1:8:hei
        quartimg3(i1,j1) = b(i,j);
        j1 = j1 + 1;
    end
    i1 = i1 + 1;
    j1 = 1;
end
figure
subplot(1,3,1),imshow(uint8(quartimg1))
subplot(1,3,2),imshow(uint8(quartimg2))
subplot(1,3,3),imshow(uint8(quartimg3))
