
clear all

%Set FP to each folder where the CellPostions*.mat files are stored for
%each sample
FP{1} = '\\169.228.232.5\englerlabstorage\Katie Birmingham\Microscope\Migration Studies\20220504_T47D_Migration_US_CPX_DOX\DOX';


%Labels will be taken from the folder name containing the .mat files.
labels{1} = '';

for fp=1:numel(FP)
    n=1;
    str=strfind(FP{fp},'\');
    labels{fp+1} = FP{fp}(str(end)+1:end);
    a = dir([FP{fp} '/CellPositions*']);
    ImgName = {a.name};
    ImgName = (natsortfiles(ImgName));
    for i=1:45
        try
            load([FP{fp} '/' ImgName{i}]);
            for j=1:size(CellPos,3)
                rw = CellPos(:,:,j); 
                [vel{fp}(n,1),dsp{fp}(n,1)] = speed(rw',15,1.6);
                n=n+1;
            end
        catch
        end
    end
    clear CellPos a rw
end

%%
for i=1:numel(vel)
   mVel(i) = mean(vel{i});
   sVel(i) = std(vel{i});
   mDis(i) = mean(dsp{i});
   sDis(i) = std(dsp{i});
end

cl = get(groot,'defaultAxesColorOrder');
figure
set(gcf,'position',[250   250   800   600])
hold on
for i = 1:length(mVel)
    h=bar(i,mVel(i));
    set(h,'FaceColor',cl(mod(i-1,7)+1,:));
end
ylabel('Cell Speed (um/hr)')
errorbar(mVel,sVel,'LineStyle','none','Color','k')
xtickangle(45)
xticklabels(labels)
ylim([0 80])
set(gca,'fontsize',24,'FontName', 'Arial')
box on

figure
set(gcf,'position',[250   250   800   600])
hold on
for i = 1:length(mDis)
    h=bar(i,mDis(i));
    set(h,'FaceColor',cl(mod(i-1,7)+1,:));
end
ylabel('Displacement (um)')
errorbar(mDis,sDis,'LineStyle','none','Color','k')
xtickangle(45)
xticklabels(labels)
ylim([0 200])
set(gca,'fontsize',24,'FontName', 'Arial')
box on

%%
function [avgVel,displ] = speed(rw,runTime,scale)

    
    dim = size(rw,1);
    dsp = vecnorm(rw(1:dim,2:end)-rw(1:dim,1:end-1));
    dst = sum(dsp)*scale;%............................Gets distance cell traveled 
    avgVel = dst/runTime;
    displ = norm(rw(1:dim,end)-rw(1:dim,1))*scale;
end