
%Path to where all experiment folders are located
FilePath = 'D:\original collagen dppfc data in paper-with new plot adhesion code\Collagen dPPFC Data for Nature Paper with Adjusted MaxTau Variable on Matlab\SUM1315';

%Path to where all slide_*.mat files will be stored
DataPath = [FilePath '\Data\'];

%Create folder it if does not exist
if ~exist(DataPath,'dir')
   mkdir(DataPath)
end


%Copies slide_*.mat files to data folder and numbers them sequentially
a = dir(FilePath);      
Fldr = {a.name}';
n=1;
for i=1:numel(Fldr)
    if contains(Fldr{i},'202')
        FP = [FilePath '\' Fldr{i} '\'];
        for j=1:4
            try
                copyfile([FP 'Slide_' num2str(j) '.mat'],[DataPath 'Slide_' num2str(n) '.mat'])
                n=n+1;
            catch e
                fprintf(1,'\n%s',e.message);
            end
        end
    end
end

