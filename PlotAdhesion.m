% Required m-files for PlotAdhesion.m:
%     Z:\Ben Yeoman\Matlab\custom\fancyPlot.m
%     Z:\Ben Yeoman\Matlab\custom\natsortfiles\natsort.m
%     Z:\Ben Yeoman\Matlab\custom\natsortfiles\natsortfiles.m
% Required MATLAB Toolboxes for PlotAdhesion.m:
%     Curve Fitting Toolbox

clear all

%Path to data folder\\169.228.232.5\EnglerLabStorage\Madison Kane\Collagen\MCF10AT
FilePath = 'D:\original collagen dppfc data in paper-with new plot adhesion code\Collagen dPPFC Data for Nature Paper with Adjusted MaxTau Variable on Matlab\MDAMB468\Data';

%R^2 threshold for plots
R2 = 0.5;

%Pull out data files
a=dir([FilePath '\Slide_*']);
slide = natsortfiles({a.name});

%Setup figure window
figure
hold on
set(gcf,'position',[100 100 800 600])

% Load and plot individual slide data
n=1;
for i=1:numel(a)
    clear posPre posPost
    FP = [FilePath '\' slide{i}];
    load(FP)

    [f,g,pTemp] = plotAdhesion(shear,Post./Pre,i,1,R2); %#ok<*SAGROW> 
    if isa(pTemp,'matlab.graphics.chart.primitive.Line')
        P(n) = pTemp;
        
        disp(i)

        nCells(n,1) = sum(Pre);
        t50(n,1) = f.m*(-log(0.5))^(1/f.b);
        sig(n,1) = f.b;
        try
            pop(n,1) = f.p;
        catch
            pop(n,1) = NaN;
        end
        R(n,1) = g.adjrsquare;
        legName{n} = sprintf('Slide %d, t_5_0 = %0.1f',n,t50(n));
        n=n+1;
    end
    

end
idx=strfind(FilePath,'\');
FilePath(strfind(FilePath,'_')) = '-';
l=legend(P(1:end),legName,'Location','best');
l.EdgeColor = [1,1,1];
l.FontSize = 18;
set(l,'EdgeColor','none');
set(l,'color','none');


%% 
function [f,gof,P] = plotAdhesion(shear,y1,i,fitType,R)

    %Two cell line fit
    if fitType == 2
        eqn = 'p*exp(-(x/m)^b)+(1-p)*exp(-(x/810.4)^1.4154)';
        ft = fittype( eqn, 'independent', 'x', 'dependent', 'y' );
        opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
        opts.Display = 'Off';
        opts.Lower = [0.1 0 0];
        opts.StartPoint = [1 50 rand];
        opts.Upper = [15 564.9/2 1];

    %Single cell line fit
    elseif fitType == 1
        eqn = 'exp(-(x/m)^b)';
        ft = fittype( eqn, 'independent', 'x', 'dependent', 'y' );
        opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
        opts.Display = 'Off';
        opts.Lower = [0 0];
        opts.StartPoint = [1 1];
        opts.Upper = [Inf 800];
    end

    
    cl = get(groot,'defaultAxesColorOrder');
    y1(y1>1) = 1;
    
    [xData, yData] = prepareCurveData( shear(~isnan(y1)), y1(~isnan(y1)));


    [f, gof] = fit( xData, yData, ft, opts );
    p1 = f(shear);

    disp(gof.adjrsquare)
    if gof.adjrsquare > R
        scatter(shear,y1,10,cl(mod(i-1,7)+1,:),'filled')
        P = fancyPlot({shear},{p1},{'xlabel','Shear Stess (dynes/cm^2)'},...
            {'ylabel','Survival Fraction'},{'lineStyle','-'},{'ylim',[0,1.2]},...
            {'spline'},{'lineWidth',2},{'fontSize',18},{'color',cl(mod(i-1,7)+1,:)});
        set(gca, 'XScale', 'log')
    else
        P = NaN;
    end

    
end
