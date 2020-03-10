function [map,idx]=generate_edge_map_sh(image,MGD)

map=[];
idx=[];
r=1;
%alpha=4000;
%Step1: Proceed the image, band-by-band, by MGD
m=512;n=512;
image=imresize(image ,[m n]);%
for i=1:size(image,3)
    %disp('spectral band=');i
    %image=TVCorrection(double(image(:,:,i)),0.4);
    %img=TVCorrection(double(image(:,:,i)),0.7);
    %forward shearlet transform
    shear =shearing_filters_Myer([30 30 36 36],[3 3 3 4],size(image,1));%([80 80 120 120],[3 3 3 4],1024);%([68 80 80 80],[3 3 3 4],512);%%([30 30 36 36],[3 3 4 4],256);%%([68 80 80 80],[3 3 3 4],512);%([80 100 120 120],[3 3 3 4],2048);%([68 80 80 80],[3 3 3 4],512);%
    B=(shear_trans(image(:,:,i),'maxflat',shear));
    
   
    for s=1:length(B)
        disp('scale=');s
        %for w=1:length(B{s})
        if ((any(MGD(:) == s) ))% && not(s==3))%||not(s==scale2))
            B{s} = B{s} .* 0;
        end
        %else
            %y=[];
            %[D idx] = select_coeff_kmeans(B{s},size(B{s},1)*size(B{s},2));
            %thresholding using OTSU
            [D th n] = select_coeff(B{s},ceil(size(B{s},1)*size(B{s},2)));
            %for z=1:2
               %flag=(idx==z); 
               %y =[y; B{s}.*flag];
            %end
            B{s}=D;
        %end

    end
    
    %Step3: MGD inverse and return a 2D-Image
    map(:,:,i)= inverse_shear(B,'maxflat',shear);%ifdct_wrapping(B,1);


end
end
%end
function y = TVCorrection(x,gamma)
% Total variation implemented using the approximate (exact in 1D) equivalence between the TV norm and the l_1 norm of the Haar (heaviside) coefficients.

%qmf = MakeONFilter('Haar');
%[ll,wc] = mrdwt(x,qmf,1);
wc = swt2(x,1,'haar');
wc = SoftThresh(wc,gamma);
y = iswt2(wc,'haar');
end