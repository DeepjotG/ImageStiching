image = im2double(rgb2gray(imread('S1-im1.png')));
image2 = im2double(rgb2gray(imread('S1-im2.png')));
image3 = im2double(rgb2gray(imread('S2-im1.png')));
image4 = im2double(rgb2gray(imread('S2-im2.png')));
image5 = im2double(rgb2gray(imread('S3-im1.png')));
image6 = im2double(rgb2gray(imread('S3-im2.png')));
image7 = im2double(rgb2gray(imread('S4-im2.png')));
image8 = im2double(rgb2gray(imread('S4-im1.png')));


%Image Set 1
tic
[cornerMatrix_One, VscoreMatrix_One] = fast_detector(image);
[cornerMatrix_Two, VscoreMatrix_Two] = fast_detector(image2);
elapsed_time = toc;
disp('Image set 1 Fast')
disp(elapsed_time);

[x1, y1] = find(cornerMatrix_One);
imshow(image);
    hold on;
    plot(y1, x1, 'r.'); % Plot corners in red '+'
    hold off;
f = getframe(gca);
overlayedImage = frame2im(f);
imwrite(overlayedImage, 'S1-fast.png');

[x, y] = find(cornerMatrix_Two);
imshow(image2);
    hold on;
    plot(y, x, 'r.'); % Plot corners in red '+'
    hold off;
f = getframe(gca);
overlayedImage = frame2im(f);
imwrite(overlayedImage, 'S2-fast.png');



%IMAGE SET 2 FAST
tic
[cornerMatrix_One_Three, VscoreMatrix_One_Three] = fast_detector(image3);
[cornerMatrix_Two_Four, VscoreMatrix_Two_Four] = fast_detector(image4);
elapsed_time = toc;
disp('Image set 2 Fast')
disp(elapsed_time);


%IMAGE SET 3 FAST
tic
[cornerMatrix_One_Five, VscoreMatrix_One_Five] = fast_detector(image5);
[cornerMatrix_Two_Six, VscoreMatrix_Two_Six] = fast_detector(image6);
elapsed_time = toc;
disp('Image set 3 Fast')
disp(elapsed_time);

%IMAGE SET 4 FAST
tic
[cornerMatrix_One_Seven, VscoreMatrix_One_Seven] = fast_detector(image7);
[cornerMatrix_Two_Eight, VscoreMatrix_Two_Eight] = fast_detector(image8);
elapsed_time = toc;
disp('Image set 4 Fast')
disp(elapsed_time);

%Fastr Points for image 1
tic
fastr1 = fastr_detector(image,cornerMatrix_One,VscoreMatrix_One);
fastr2 = fastr_detector(image2,cornerMatrix_Two,VscoreMatrix_Two);
elapsed_time = toc;
disp('Image set 1 fastr')
disp(elapsed_time);

corvis = image;
corvis(fastr1 > 0) = 1;
imshow(corvis);
hold on;
[x, y] = find(fastr1 > 0);
plot(y, x, 'r.','MarkerSize', 4.5); 
hold off;
f = getframe(gca);
overlayedImage = frame2im(f);
imwrite(overlayedImage, 'S1-fastR.png');


corvis = image2;
corvis(fastr2 > 0) = 1;
imshow(corvis);
hold on;
[x, y] = find(fastr2 > 0);
plot(y, x, 'r.','MarkerSize', 4.5); 
hold off;
f = getframe(gca);
overlayedImage = frame2im(f);
imwrite(overlayedImage, 'S2-fastR.png');


%Fastr Points for Image set 2
tic
fastr3 = fastr_detector(image3,cornerMatrix_One_Three,VscoreMatrix_One_Three);
fastr4 = fastr_detector(image3,cornerMatrix_Two_Four,VscoreMatrix_Two_Four);
elapsed_time = toc;
disp('Image set 2 Fastr')
disp(elapsed_time);


%Fastr Points for Image set 3
tic
fastr5 = fastr_detector(image5,cornerMatrix_One_Five,VscoreMatrix_One_Five);
fastr6 = fastr_detector(image6,cornerMatrix_Two_Six,VscoreMatrix_Two_Six);
elapsed_time = toc;
disp('Image set 3 Fastr')
disp(elapsed_time);

%Fastr Points for Image set 4
tic
fastr7 = fastr_detector(image7,cornerMatrix_One_Seven,VscoreMatrix_One_Seven);
fastr8 = fastr_detector(image8,cornerMatrix_Two_Eight,VscoreMatrix_Two_Eight);
elapsed_time = toc;
disp('Image set 4 Fastr')
disp(elapsed_time);

%part 3
[featurematch_img12_fast,MP1_fast,MP11_fast] = featuredetector(image,image2,cornerMatrix_One,cornerMatrix_Two);
ax = gca;
exportgraphics(ax,'S1-fastMatch.png');

[featurematch_img12_fastr,MP1_fastr,MP11_fastr] = featuredetector(image,image2,fastr1,fastr2);
ax = gca;
exportgraphics(ax,'S1-fastRMatch.png')


%Part3 For Image set 2
[featurematch_img34_fast,MP3_fast,MP4_fast] = featuredetector( ...
    image3,image4,cornerMatrix_One_Three,cornerMatrix_Two_Four);
ax = gca;
exportgraphics(ax,'S2-fastMatch.png')
[featurematch_img34_fastr,MP3_fastr,MP4_fastr] = featuredetector( ...
    image3,image4,fastr3,fastr4);
ax = gca;
exportgraphics(ax,'S2-fastRMatch.png')

%PART 3 FOR IMAGE SET 3
[featurematch_img56_fast,MP5_fast,MP6_fast] = featuredetector( ...
    image5,image6,cornerMatrix_One_Five,cornerMatrix_Two_Six);

[featurematch_img56_fastr,MP5_fastr,MP6_fastr] = featuredetector( ...
    image5,image6,fastr5,fastr6);

%PART 3 FOR IMAGE SET 4
[featurematch_img78_fast,MP7_fast,MP8_fast] = featuredetector( ...
    image7,image8,cornerMatrix_One_Seven,cornerMatrix_Two_Eight);

[featurematch_img78_fastr,MP7_fastr,MP8_fastr] = featuredetector( ...
    image7,image8,fastr7,fastr8);


%part 4 

para = checking('S1-im1.png','S1-im2.png',fastr1,fastr2);
imwrite(para,'S1-panorama.png');

para2 = checking('S2-im1.png','S2-im2.png',fastr3,fastr4);
imwrite(para2,'S2-panorama.png')

para3 = checking('S3-im1.png','S3-im2.png',fastr5,fastr6);
imwrite(para3,'S3-panorama.png')

para4 = checking('S4-im2.png','S4-im1.png',fastr7,fastr8);
imwrite(para4,'S4-panorama.png')
