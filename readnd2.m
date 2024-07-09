% clear all
% file = 'Z:\Madison Kane\Collagen\BT549\2022-05-05\Post.nd2';

function img = readnd2(file)
fid = fopen(file, 'r');
filedata = fread(fid,'*uint8')';

sigbyte = [218, 206, 190, 10];
dataPos = strfind(filedata, sigbyte);
Name = cell(numel(dataPos),1);
NameLength = zeros(numel(dataPos),1);
DataLength = zeros(numel(dataPos),1);
dataStartPos = zeros(numel(dataPos),1);

for i=1:numel(dataPos)
    fseek(fid, dataPos(i)+3, 'bof');
    NameLength(i,1) = fread(fid, 1, 'uint32');
    DataLength(i,1) = fread(fid, 1, 'uint64');
    tmpName = fread(fid, NameLength(i,1), '*char')';
    dataStartPos(i) = ftell(fid);
    endName = strfind(tmpName,'!')-1;
    Name{i} = tmpName(1:endName);
end


%Get image sequence positions
imgPos = dataStartPos(contains(Name,'ImageDataSeq'));

%Get image size
idx = find(contains(Name,'ImageAttributesLV'),1);
fseek(fid, dataStartPos(idx) + 70, 'bof');
imWidth = fread(fid, 1, '*uint32');
fseek(fid, dataStartPos(idx) + 126, 'bof');
imHeight = fread(fid, 1, '*uint32');

%Get number of channels
idx = find(contains(Name,'ImageMetadataSeqLV'),1);
fseek(fid, dataStartPos(idx), 'bof');
img_metadata = fread(fid, DataLength(idx), '*char')';
pos = strfind(img_metadata, insert0('ChannelIsActive'));
channels = length(pos);

% idx = find(contains(Name,'ImageMetadataLV'),1);
% fseek(fid, dataStartPos(idx), 'bof');
% img_metadata = fread(fid, DataLength(idx), '*char')';
% idx = strfind(img_metadata, insert0('PosName')) + length(insert0('PosName'));





img = uint16(zeros(imHeight, imWidth, numel(imgPos), channels));
for h=1:channels
    for i=1:numel(imgPos)
        fseek(fid, imgPos(i) , 'bof');
        rawImg = fread(fid, [channels*imWidth imHeight], '*uint16');
        img(:,:,i,h) = rawImg(h:channels:end,:)';
    end
end


% ND2 file has text sequence with 0 between characters.
function out = insert0(in)
num = in + 0;
out = char([reshape(cat(1, num, zeros(size(num))), [1, length(num)*2]), 0]);
end

% function strloc( fid, startPos, text, str )
% idx = strfind(text, insert0(str)) + length(insert0(str));
% fseek(fid, startPos + idx(1), 'bof');
% end


end