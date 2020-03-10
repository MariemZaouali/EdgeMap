% Mariem ZAOUALI, PhD Student
% LIMTIC 2017, Tunisia
% This is the main test of the Edge Map guidance Joint Sparse
% Representation
close all;clear;clc;
%Step1: Load data
%Load Indian Pines image
% [parentdir,~,~]=fileparts(pwd);

 load ('rstPCApavia98.mat');
%Step2: Generated Edge Map 
%MGD scale (number of shearlet's scales)
MGD=4;

map=real(generate_edge_map_sh(double(rstPCApavia98), MGD));%
map=imresize(map,[size(rstPCApavia98,1) size(rstPCApavia98,2)]);

%Display of the detected edges
imshow3D(map);
cmp_fus=zeros(size(map,1),size(map,2));
%Amplitude Fusion
for i=1:size(map,1)
    for j=1:size(map,2)
        for k=1:size(map,3)
            cmp_fus(i,j)= cmp_fus(i,j)+map(i,j,k)^2;       
        end
        cmp_fus(i,j)=sqrt(cmp_fus(i,j));
    end
end
imshow(cmp_fus);
%Normalization
cmp_fus = mat2gray(cmp_fus);
%OTSU thres
level = graythresh(cmp_fus);
cmp_fus1=cmp_fus>level;
%Mathematical Morphology ( To custimize)
cmp_fus1=bwmorph(cmp_fus1,'dilate');
cmp_fus1=bwmorph(cmp_fus1,'clean');
cmp_fus1=bwmorph(cmp_fus1,'erode');
%Labelization 
L=bwlabel(cmp_fus1,4);
imagesc(L);