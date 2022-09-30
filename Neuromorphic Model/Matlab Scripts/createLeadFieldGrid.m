%this function is used to create a uniform grid of points in which to
%sample a COMSOL FEM solution in order to make a Lead Field
%meshFileName = file name of an ASCII UCD mesh file from Amira
%domainsOfInterest = array of integers referring to the subdomain indexes in
%which you want the grid to be created
%dist will be the distance between sample points (isotropic in all directions)
%dist is a sensitive parameter, decreasing it a little will result in many,
%many more points (which will increase processing time geometrically)
%Returns a matrix of points (3xnumPoints) that may be fed into
%sampleLeadFieldGrid.m
%NOTE: this uses Java functions, make sure the javaclasspath is set

function y = createLeadFieldGrid(MeshFileName, domainsOfInterest, dist)
    %import the ASCII UCD mesh from file, note that your static java path
    %needs to be set properly for this to work
    disp(['Attempting to convert ASCII UCD file: ' MeshFileName])
    try
        g = UCDconverter(MeshFileName);
    catch
        disp('???????????????????????ERROR TRACE?????????????????????????')
        disp('UCDconverter error.  Make sure the Static Java Path is set correctly.')
        rethrow(lasterror)
    end
    disp(['UCD file converted Successfully.  Finished with: ' MeshFileName])
    %vMatrix = g{1}, tMatrix = g{2}, dMatrix = g{3}
    disp('Beginning to create the 3D grid of points.')
    %assemble the tMatrix with domains corresponding to those in domainsOfInterest
    iterator = 1;
    tMatrix = g{2}(:,find(g{3}==domainsOfInterest(1))); %initialize
    amount = size(domainsOfInterest,2);
    if (amount < size(domainsOfInterest,1))
        amount = size(domainsOfInterest,1);
    end
    for i = 2:1:amount
        tMatrix = [tMatrix g{2}(:,find(g{3}==domainsOfInterest(i)))]; %initialize
        iterator = iterator + 1;
    end
    disp(['Generating points within ' num2str(iterator) ' subdomain(s).'])
    
    tMatrix = tMatrix-1;    %convert to Java array indexing convention
    
    %create the list of points using MeshRework Java class
    myMeshRework = MeshRework();
    points = myMeshRework.gridSampleComsol(dist, g{1}, tMatrix);
    
    y = points;
        
