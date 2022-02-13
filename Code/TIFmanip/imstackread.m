function ImStack=imstackread(FileName)
ImInfo=imfinfo(FileName);
N=length(ImInfo);
ImSize=[ImInfo(1).Height,ImInfo(1).Width,length(ImInfo)];
ImStack=uint16(zeros(ImSize));
for ii=1:N
    ImStack(:,:,ii)=imread(FileName,'Index',ii,'Info',ImInfo);
end