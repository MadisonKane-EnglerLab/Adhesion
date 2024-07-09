%% Required m-files for ShearAnalysis_rev14.m:
%     fancyPlot.m
%     readnd2.m  %download comsol shears 
%% Required MATLAB Toolboxes for ShearAnalysis_rev14.m:
%     Image Processing Toolbox
%     Statistics and Machine Learning Toolbox
%     Curve Fitting Toolbox
%     Computer Vision Toolbox

%% Start of Script
close all
clearvars

%Set file path to nd2 files, maximum shear used, and number of cell lines cultured on same slide
folder = 'D:\Human Breast Cancer Sample Project\Patient 20 (surgery on 3-21-2024)\dPPFC\p.2\Grown at 21333 cells-cm2 (normal)\Cancer\Data';

maxTau = 800*5/6;   %Maximum shear used for device
cellLines = 1;  %1 for mono-culture, 2 for co-culture 




%% Load Nikon images for plate
imPre = readnd2([folder '\' 'Pre_crop.nd2']);
imPost = readnd2([folder '\' 'Post.nd2']);


%% Get Shear Values from Comsol and bin
res = size(imPre,2)/3;
ylen = length(imPre);
nL = floor(ylen/res);
Len = nL*res*1.6/1000;
load('C:\Users\Madison Kane\Desktop\Engler Lab\ComsolShears')
t=t./max(t)*maxTau;
L=linspace(0,Len,nL+1);
t(l>max(L))=[];
l(l>max(L))=[];

%% Analyze images automatically or load existing analyses and view adhesion profiles
figure
set(gcf,'position',[50 50 1300 900])
try 
    load([folder '\NumSlides.mat'])
    for i= [1:4]
        load([folder '\Slide_' num2str(i) '.mat']);
        subplot(2,2,i)
        [f,gof]=plotAdhesion(shear,Post./Pre,cellLines);
        tau50(i,1) = f.m*(-log(0.5))^(1/f.b);
        sig(i,1) = f.b;
    end
catch
for slide = [1:4]


Dpre = rescale(imPre(:,:,slide));
Dpost = rescale(imPost(:,:,slide));

flagc = 0;
flagd = 0;
cfinal = [];
dfinal = [];

% optimizing thresholding for each slide of human patient data
    for i = 0.01:0.01:0.2
       c1 = ProcessImage(Dpre,i);
       test = sum(c1, 'all');
       disp(test)
        if test <= 500000     %for all samples has been 500,000
            if flagc == 0
               cfinal = c1;
               disp('was here')
               flagc = 1;
            end
          
        end
    end

    c1 = cfinal;
    testc = sum(c1, 'all');
    
    for m = 0.01:0.01:0.2
       d1 = ProcessImage(Dpost,m);
       test = sum(d1, 'all');
       disp(test)
        if test <= 200000 %for all samples has been 200,000
            if flagd == 0
               dfinal = d1;
               flagd = 1;
               disp('waszzzz here')
            end
       end
    end
    
    d1 = dfinal;
   





    r1 = imdilate(c1,strel('disk',150,0));
    disp('step12')
    c2 = bwpropfilt(c1,'Area',[5 800]);
 
    d2 = bwpropfilt(d1,'Area',[5 800]);
    
    d2(~r1) = 0;
   
%     %remove cells on gasket
%     pos_triangle = [1  24900 1 29158 325 29158];
%     G = insertShape(zeros(size(b1)),'FilledPolygon',{pos_triangle});
%     G = G(:,:,1);
%     G(G>0)=1;
%     d2(G==1) = 0;
    
    %Get post shear positions 
    cen = vertcat(regionprops(d2,'Centroid').Centroid);
    x2=cen(:,1);
    y2=cen(:,2);
    disp('step13')
    r2 = insertShape(zeros(size(c2)),'FilledCircle',[x2 y2 40*ones(size(x2))]);
    r2 = r2(:,:,1);
    r2(r2>0)=1;
    c2(r2==1) = 0;
%     c2(G==1) = 0;
    
    %Get pre shear positions
    cen = vertcat(regionprops(c2,'Centroid').Centroid);
    x1=cen(:,1);
    y1=cen(:,2);
    disp('step14')
    %Get cell counts
    Ypre=1.6*[y1;y2]/1000;
    Ypost=1.6*y2/1000;
    Pre = sum(Ypre<=L(2:end)&Ypre>L(1:end-1))';
    Post = sum(Ypost<=L(2:end)&Ypost>L(1:end-1))';  
    

    shear=t(ceil(linspace(1,numel(l),nL)));
    save([folder '\Slide_' num2str(slide) '.mat'],'x1','x2','y1','y2','Pre','Post','shear')

    subplot(2,2,slide)
    [f,gof] = plotAdhesion(shear,Post./Pre,cellLines);
    tau50(slide,1) = f.m*(-log(0.5))^(1/f.b);
    sig(slide,1) = f.b;
end
save([folder '\NumSlides.mat'],'slide')
end




%% 
function I3 = ProcessImage(I,adjust)
    I2 = zeros(size(I));
    idx = (1:461:size(I,1))';

    for i=1:numel(idx)-1
        if i==numel(idx)-1
            J = I(idx(i):end,:);
            I2(idx(i):end,:) = imadjust(J,[0 adjust],[],2);
        else
            J = I(idx(i):idx(i+1),:);
            I2(idx(i):idx(i+1),:) = imadjust(J,[0 adjust],[],2);
        end
    end
    I3 = imbinarize(I2);

end


%% 
function [f,gof] = plotAdhesion(shear,y1,cLines)

 %Two Population Curve Fit
if cLines == 1
    eqn = 'exp(-(x/m)^b)';
    ft = fittype( eqn, 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.Lower = [0.1 0];
    opts.StartPoint = [1 1];
    opts.Upper = [15 Inf];

    %Single Population Curve Fit
elseif cLines == 2    
    eqn = 'p*exp(-(x/m)^b)+(1-p)*exp(-(x/810.4)^1.4154)';
    ft = fittype( eqn, 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.Lower = [0.5 0 0];
    opts.StartPoint = [2 100 0.5];
    opts.Upper = [15 810.4 1];
end


    hold on
    cl = get(groot,'defaultAxesColorOrder');
    y1(y1>1) = 1;
    scatter(shear,y1,10,cl(1,:),'filled')
    [xData, yData] = prepareCurveData( shear(~isnan(y1)), y1(~isnan(y1)));


    [f, gof] = fit( xData, yData, ft, opts );
    p1 = f(shear);

    fancyPlot({shear},{p1},{'xlabel','Shear Stess (dynes/cm^2)'},...
        {'ylabel','Survival Fraction'},{'lineStyle','-'},{'ylim',[0,1.2]},...
        {'spline'},{'lineWidth',2},{'fontSize',18},{'color',cl(1,:)});
    set(gca, 'XScale', 'log')
    
end
