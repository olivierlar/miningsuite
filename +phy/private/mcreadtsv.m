function d = mcreadtsv(fn);

ifp = fopen(fn);
if ifp<0
    disp(['Could not open file ' fn]);
    return;
end

d.type = 'MoCap data';
d.filename = fn;

s=fscanf(ifp,'%s',1);
if strcmp('NO_OF_FRAMES', s) == 0 
    disp('No header information found. Please use the export option Include TSV header in QTM.');
    return
end
s=fscanf(ifp,'%s',1); d.nFrames = str2num(s);
s=fscanf(ifp,'%s',1);
s=fscanf(ifp,'%s',1); d.nCameras = str2num(s);
s=fscanf(ifp,'%s',1);
s=fscanf(ifp,'%s',1); d.nMarkers = str2num(s);
s=fscanf(ifp,'%s',1);
s=fscanf(ifp,'%s',1); d.freq = str2num(s);
s=fscanf(ifp,'%s',1);
s=fscanf(ifp,'%s',1); d.nAnalog = str2num(s);
s=fscanf(ifp,'%s',1);
s=fscanf(ifp,'%s',1); d.anaFreq = str2num(s);

d.timederOrder = 0;

fgetl(ifp);
s=fgetl(ifp); other.descr=s;
s=fgetl(ifp); other.timeStamp=s;
s=fscanf(ifp,'%s',1);
s=fscanf(ifp,'%s',1); other.dataIncluded = s;

s=fscanf(ifp,'%s',1); % 20080811 fixed bug that prevented reading non-annotated tsv files
tmp=fgetl(ifp); % 'MARKER_NAMES'
d.markerName=cell(d.nMarkers,1);
if length(tmp)>1 % if marker names given %BB Fix 20110420: not 14, but 1...
    s=sscanf(tmp,'%s',1);
    d.markerName = strread(tmp,'%[^\n\r\t]');
end
% end 20080811 fix


%BB: QTM export option "column headers" - 20100201 fix
tmp=fgetl(ifp); % read next line - either Column headers or first line of mocap data
if isletter(tmp(1))==1; %is first character is letter?
    tmp=textscan(ifp,'%f','delimiter','\t'); %yes: skip that line and read in data
    tmp=tmp{1};
else %no -> line is already data
    tmp1=textscan(ifp,'%f','delimiter','\t'); %read in rest of data
    tmp1=tmp1{1};
    tmp=str2num(tmp);
    tmp=[tmp tmp1']; %concatenate first line of data (tmp) and rest
    tmp=tmp';
end
%BB end


%BB: QTM export option "export time data for every frame" - 20100201 fix
%Data is on the vector tmp. Length is EITHER nFrames * 3*nMarkers OR nFrames *  3*nMarkers + nFrames*2
if strcmp(other.dataIncluded, '3D') || strcmp(other.dataIncluded, '')
    if length(tmp) > d.nFrames*3*d.nMarkers %test if exported with time and frame
        
        if length(tmp)~=d.nFrames*3*d.nMarkers+2*d.nFrames %BBFIX 20120112, for not exported gaps
            disp([10,'Warning: Data inconsistent with amount of markers. Please export complete data. Data set to NaN',10])
            d.data=0;
            return
        end
        
        d.data=NaN*ones(d.nFrames, 3*d.nMarkers+2); %yes. So data array with two more fields for frame and time
        tmp(find(tmp==0)) = NaN; % change potential zeros to NaN's
        d.data = reshape(tmp', 3*d.nMarkers+2, d.nFrames)';
        d.data(:,[1 2]) = []; %delete first two columns (frame and time)
    else %no time and frame exported
        
        if length(tmp)~=d.nFrames*3*d.nMarkers %BBFIX 20120112, for not exported gaps
            disp([10,'Warning: Data inconsistent with amount of markers. Please export complete data. Data set to NaN',10])
            d.data=0;
            return
        end
        
        d.data = NaN*ones(d.nFrames, 3*d.nMarkers);
        tmp(find(tmp==0)) = NaN;
        d.data = reshape(tmp',3*d.nMarkers,d.nFrames)';
    end
% elseif strcmp(other.dataIncluded, '6D') %%Fix BB20110114 to read in 6-dof data - dirty fix if you need the read in 6d data without doing much
% further analysis, since marker structure gets damaged...
%         d.data = NaN*ones(d.nFrames, 16*d.nMarkers);
%         tmp(find(tmp==0)) = NaN;
%         d.data = reshape(tmp',16*d.nMarkers,d.nFrames)';
%         d.data(:,7:end) = []; %delete first two columns (frame and time)
end



fclose(ifp);

d.analogdata = [];
d.other = other;