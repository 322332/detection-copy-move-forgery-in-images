
% Copy Move Image Forgery Detection

RGB = imread('\imgs\forged1.png');

img = rgb2gray(RGB);

[imgHeight,imgWidth] = size(img);

imgHeight=imgHeight-7;
imgWidth=imgWidth-7;
blockSize = imgHeight*imgWidth;


for i=1:imgHeight
   for j=1:imgWidth
        for h=0:7
            for w=0:7
             matris(h+1,w+1,(i-1)*imgWidth+j)=img(h+i,w+j);
            end
        end
        quantalanmisdct(:,:,(i-1)*imgWidth+j) = floor(dct2(matris(:,:,(i-1)*imgWidth+j))./6);
        zigzagvector((i-1)*imgWidth+j,:)= zigzag( quantalanmisdct(:,:,(i-1)*imgWidth+j ) ); 
        vector16((i-1)*imgWidth+j,[1:16]) = zigzagvector((i-1)*imgWidth+j,[1:16]);
        vector16((i-1)*imgWidth+j,17)=j;
        vector16((i-1)*imgWidth+j,18)=i;
   end
end



% sort lexographic
B=sortrows(vector16,1:16); 

p=1;
for i=1:(blockSize-20)
    for j=(i+1):(i+20)
    D  = sqrt(sum((B(i,1:16) - B(j,1:16)) .^ 2));
         if(D<3 & abs((B(i,17) - B(j,17)))>3 & abs((B(i,18) - B(j,18)))>3 )
        benzer(p,1)=D;
        benzer(p,2)=B(i,17);
        benzer(p,3)=B(i,18);
        benzer(p,4)=B(j,17);
        benzer(p,5)=B(j,18);
        benzer(p,6)=sqrt(sum((B(i,17) - B(j,17)) .^ 2+sum((B(i,18) - B(j,18)) .^ 2)));
        p=p+1;
         end
    end
end


M = mode(benzer(:,6))

for i=1:256
    for j=1:256
        img(i,j)=0;
    end
end

 [benzersize,v] = size(benzer);
for i=1:benzersize
        for h=0:7
            for w=0:7  
             if(benzer(i,6)==M)
              img(h+benzer(i,3),w+benzer(i,2))=255;
              img(h+benzer(i,5),w+benzer(i,4))=255;
              end
            end
        end
end



imshow(img);
rgbImage = cat(3, img, img, img);
imwrite(rgbImage,'res.png');
getFmeasure('res.png','\imgs\forged1_maske.png')

%clear M;
%clear benzer;
%clear benzersize;
%clear img;
%clear i;
%clear j;
%clear p;
%clear k;
%clear v;
%clear w;
%clear h;

