%%%%%%

close all;
clear all;
clc;
tiny = 1e-8;

%% Load the image. 
rgbImage=double(imread("a18.jpg"))/255;figure;imshow(rgbImage);

%%SSR

sigma = 25;
SSR = zeros(size(rgbImage));

for c = 1:3
    SSR(:,:,c) = log(rgbImage(:,:,c) + tiny) - ...
                 log(imgaussfilt(rgbImage(:,:,c), sigma) + tiny);
end

SSR = mat2gray(SSR);

figure; imshow(SSR); title('SSR Output');
imwrite(SSR,'SSR Output.png');

%%% Laplacian Decomposition 
lap = pyramiddec(SSR, 2);
figure;imshow(mat2gray(lap{1}));
figure;imshow(lap{2});

%% image sharpening
sigma = 0.3;
Igauss = lap{1};
N = 5;
for iter=1: N
   Igauss =  imgaussfilt(Igauss,sigma);
   Igauss = min(lap{1}, Igauss);
end

gain = 0.1; 
Norm = (lap{1}-gain*Igauss);
%Norm
for n = 1:3
   Norm(:,:,n) = histeq(Norm(:,:,n)); 
end
Isharp = (lap{1} + Norm)/2;

 figure('name', 'image sharpening');
 imshow(Isharp)


%% Gradient-based weight calculation (REPLACEMENT)
base_resized = imresize(lap{2}, size(Isharp(:,:,1)));

%% weight - WLE metrix
% Compute WLE weights from grayscale versions
E1 = WLE(double(rgb2gray(base_resized)));
E2 = WLE(double(rgb2gray(Isharp)));
% Normalize weights
W1 = E1 ./ (E1 + E2 + eps);
W2 = E2 ./ (E1 + E2 + eps);
figure;imshow(W1);
figure;imshow(W2);
%% Naive fusion
en_detail = W2.*Isharp;
en_base = W1.*base_resized;
R = en_detail + en_base; 
figure('name', 'Naive Fusion');
imshow(R);
imwrite(R,"FinalA18.png");
ref = im2double(imread("ref.jpg"));
ps=psnr(R,ref);
 disp(['PSNR: ', num2str(ps), ' dB']);
 sm=ssim(R,ref);
 disp(['ssim: ', num2str(sm)]);