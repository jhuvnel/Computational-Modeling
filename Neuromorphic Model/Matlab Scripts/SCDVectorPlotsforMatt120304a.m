%SCDVectorPlotsforMatt120304a.m


%SECOND plot Matt's data as they are now (need to back rotate, but just
%look at it as is now

%assumes you loaded 'xlr eye movement data.txt' an Nx3 array of larp ralp z
%data points

%plot his data just as they are now, e
%filename=input('enter filename with xyz veloc data in 3 columns:');
input ('make sure a file called data.txt in is current directory, then hit ENTER:');
xyz= load ('data.txt'); %Nx3 matrix
scale = input ('enter factor by which to scale data to fit unit sphere - try 0.08:  ');
XYZ=xyz.*scale;

%Now adjust for tilt off Reid's line
Reid_up_pitch = input ('Enter how many degrees nose-up Reid line was in Room 2 alignment: ');
a=Reid_up_pitch*pi/180;
rotY3_plusReidpitch= [cos(a)  0  sin(a);
                        0      1   0;
                     -sin(a) 0   cos(a)];
XYZfinal=(rotY3_plusReidpitch*XYZ')';

%now do cutrate quiver plot CDS120304========================
figure, plotCDS_SCC_MeanOrientations3D;
hold on;
for ii=1:size(XYZfinal,1)
    hand=plot3([0 XYZfinal(ii,1)], [0 XYZfinal(ii,2)], [0 XYZfinal(ii,3)], 'k');
end
set (hand, 'Linewidth', 1);

%now do fancy annoted quiver plot CDS120304========================
figure, plotCDS_SCC_MeanOrientations3D;
hold on

%find the points at which each data segment starts and ends
input('BUG 120304 this is specific to dataset from first expt... hit enter to cont');
startpts=find(XYZ(:,1) < -1.2); %***** this is specific to data set we're using today***
endpts=(find(XYZ(:,1) < -1.2))-1;
endpts=[endpts(2:end)' size(XYZfinal,1)]';
indices=[startpts endpts]; %5 x 2 matrix, row = start and end pt for each epoch
Ntrials=size(indices,1);
sss='rgbkmcy'
for jj=1:Ntrials,
    color=sss(jj)
    dataseg= [indices(jj,1):indices(jj,2)];%indeices of the data segment to plot
    plot3(XYZfinal(dataseg,1), XYZfinal(dataseg,2), XYZfinal(dataseg,3), color);
    for ii=indices(jj,1):indices(jj,2)
        switch ii
            case indices(jj,1)
                symbol='o';
            case indices(jj,2)
                symbol='x';
            otherwise
                symbol='.';
        end %switch
    hand=plot3([0 XYZfinal(ii,1)], [0 XYZfinal(ii,2)], [0 XYZfinal(ii,3)], [color symbol]);
    set (hand, 'Linewidth', 2);
    end %for
end

%Now plot comet epoch plots one at a time interactively
%now do fancy annoted quiver plot CDS120304========================
figure, plotCDS_SCC_MeanOrientations3D;
hold on

%find the points at which each data segment starts and ends
input('BUG 120304 this is specific to dataset from first expt... hit enter to cont');
startpts=find(XYZ(:,1) < -1.2); %***** this is specific to data set we're using today***
endpts=(find(XYZ(:,1) < -1.2))-1;
endpts=[endpts(2:end)' size(XYZfinal,1)]';
indices=[startpts endpts]; %5 x 2 matrix, row = start and end pt for each epoch
Ntrials=size(indices,1);
sss='rgbkmcy'
for jj=1:Ntrials,
    trash=input('hit enter to add next data segment to plot');
    color=sss(jj);
    dataseg= [indices(jj,1):indices(jj,2)];%indeices of the data segment to plot
    plot3(XYZfinal(dataseg,1), XYZfinal(dataseg,2), XYZfinal(dataseg,3), color);
    for ii=indices(jj,1):indices(jj,2)
        switch ii
            case indices(jj,1)
                symbol='o';
            case indices(jj,2)
                symbol='x';
            otherwise
                symbol='.';
        end %switch
    hand=plot3([0 XYZfinal(ii,1)], [0 XYZfinal(ii,2)], [0 XYZfinal(ii,3)], [color symbol]);
    set (hand, 'Linewidth', 2);
    end %for
end



%===============NORMALIZED VECTOR PLOTS ========================

%raw plot
figure, plotCDS_SCC_MeanOrientations3D;
hold on;
XYZfinalnorm=0.51*XYZfinal./repmat(sqrt(sum(XYZfinal.^2,2)),1,3); 
for ii=1:size(XYZfinalnorm,1)
    hand=plot3([0 XYZfinalnorm(ii,1)], [0 XYZfinalnorm(ii,2)], [0 XYZfinalnorm(ii,3)], 'k');
    set (hand, 'Linewidth', 1);
end

%UNSCALED    now do fancy annoted quiver plot CDS120304========================
figure, plotCDS_SCC_MeanOrientations3D;
hold on

%find the points at which each data segment starts and ends
for ii=1:size(XYZfinalnorm,1)
    hand=plot3([0 XYZfinalnorm(ii,1)], [0 XYZfinalnorm(ii,2)], [0 XYZfinalnorm(ii,3)], 'k');
    set (hand, 'Linewidth', 1);
end
input('BUG 120304 this is specific to dataset from first expt... hit enter to cont');
startpts=find(XYZ(:,1) < -1.2); %***** this is specific to data set we're using today***
endpts=(find(XYZ(:,1) < -1.2))-1;
endpts=[endpts(2:end)' size(XYZfinal,1)]';
indices=[startpts endpts]; %5 x 2 matrix, row = start and end pt for each epoch
Ntrials=size(indices,1);
sss='rgbkmcy'
for jj=1:Ntrials,
    color=sss(jj);
    dataseg= [indices(jj,1):indices(jj,2)];%indeices of the data segment to plot
    plot3(XYZfinalnorm(dataseg,1), XYZfinalnorm(dataseg,2), XYZfinalnorm(dataseg,3), color);
    for ii=indices(jj,1):indices(jj,2)
        switch ii
            case indices(jj,1)
                symbol='o';
            case indices(jj,2)
                symbol='x';
            otherwise
                symbol='.';
        end %switch
    hand=plot3([0 XYZfinalnorm(ii,1)], [0 XYZfinalnorm(ii,2)], [0 XYZfinalnorm(ii,3)], [color symbol]);
    set (hand, 'Linewidth', 2);
    end %for
end
