function ImStack=imstackreadRGB(FileName)
ImInfo=imfinfo(FileName);
N=length(ImInfo);
ImSize=[ImInfo(1).Height,ImInfo(1).Width,3,length(ImInfo)];
ImStack=uint8(zeros(ImSize));
for ii=1:N
    ImStack(:,:,:,ii)=imread(FileName,'Index',ii,'Info',ImInfo);
end