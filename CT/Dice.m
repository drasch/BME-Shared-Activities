%% CT - Dice Sinograms:

clear; clc; close all;

load('Dice.mat');

angles = linspace(0,180, size(SinoOne,2));

figure(1); clf;
subplot 261
imshow(ImageOne./max(ImageOne(:)))
axis equal

subplot 267
imagesc(1:367, angles, SinoOne'./max(SinoOne(:)));
axis image
colormap gray
yticks(angles(1:180:end));
%yticklabels({'0','45','90', '135', '180'});

subplot 262
imshow(ImageTwo./max(ImageTwo(:)))
axis equal

subplot 268
imshow(SinoTwo'./max(SinoTwo(:)));
axis equal

subplot 263
imshow(ImageThree./max(ImageThree(:)))
axis equal

subplot 269
imshow(SinoThree'./max(SinoThree(:)));
axis equal

subplot 264
imshow(ImageFour./max(ImageFour(:)))
axis equal

subplot(2,6,10)
imshow(SinoFour'./max(SinoFour(:)));
axis equal

subplot 265
imshow(ImageFive./max(ImageFive(:)))
axis equal

subplot(2,6,11)
imshow(SinoFive'./max(SinoFive(:)));
axis equal

subplot 266
imshow(ImageSix./max(ImageSix(:)))
axis equal

subplot(2,6,12)
imshow(SinoSix'./max(SinoSix(:)));
axis equal

p = randperm(6,3)

Num1 = p(1);
Num2 = p(2);
Num3 = p(3);

if Num1 == 1
    Im1 = ImageOne;
    Sino1 = SinoOne;
elseif Num1 == 2
    Im1 = ImageTwo;
    Sino1 = SinoTwo;
elseif Num1 == 3
    Im1 = ImageThree;
    Sino1 = SinoThree;
elseif Num1 == 4
    Im1 = ImageFour;
    Sino1 = SinoFour;
elseif Num1 == 5
    Im1 = ImageFive;
    Sino1 = SinoFive;    
elseif Num1 == 6
    Im1 = ImageSix;
    Sino1 = SinoSix;  
end
    
if Num2 == 1
    Im2 = ImageOne;
    Sino2 = SinoOne;
elseif Num2 == 2
    Im2 = ImageTwo;
    Sino2 = SinoTwo;
elseif Num2 == 3
    Im2 = ImageThree;
    Sino2 = SinoThree;
elseif Num2 == 4
    Im2 = ImageFour;
    Sino2 = SinoFour;
elseif Num2 == 5
    Im2 = ImageFive;
    Sino2 = SinoFive;    
elseif Num2 == 6
    Im2 = ImageSix;
    Sino2 = SinoSix;
end
  
if Num3 == 1
    Im3 = ImageOne;
    Sino3 = SinoOne;
elseif Num3 == 2
    Im3 = ImageTwo;
    Sino3 = SinoTwo;
elseif Num3 == 3
    Im3 = ImageThree;
    Sino3 = SinoThree;
elseif Num3 == 4
    Im3 = ImageFour;
    Sino3 = SinoFour;
elseif Num3 == 5
    Im3 = ImageFive;
    Sino3 = SinoFive;    
elseif Num3 == 6
    Im3 = ImageSix;
    Sino3 = SinoSix; 
end

% figure(2); clf;
% subplot 231
% imshow(Im1./max(Im1(:)));
% axis equal
% 
% subplot 234
% imshow(Sino1'./max(Sino1(:)));
% axis equal
% 
% subplot 232
% imshow(Im2./max(Im2(:)));
% axis equal
% 
% subplot 235
% imshow(Sino2'./max(Sino2(:)));
% axis equal
% 
% subplot 233
% imshow(Im3./max(Im3(:)));
% axis equal
% 
% subplot 236
% imshow(Sino3'./max(Sino3(:)));
% axis equal

figure(3); clf;
subplot 131
imshow(Sino1'./max(Sino1(:)));
axis equal

subplot 132
imshow(Sino2'./max(Sino2(:)));
axis equal

subplot 133
imshow(Sino3'./max(Sino3(:)));
axis equal

