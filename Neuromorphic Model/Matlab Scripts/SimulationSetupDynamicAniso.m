%this function uses two seperate files (a mesh file and simulation
%parameter file) to setup a comsol simulation.  Note that this function
%uses UCDConverter, which is a Java derived script (meaning you need your
%Java Static class set correctly)
%Please review the Parameter_File_Tutorial file for details on how to create a novel parameter file
%unlike SimulationSetup, this file dynamically assigns anisotropy to nerves
%based off of user defined contour lines through the nerves
%maxContourDist is used to screen out contour segments far away from a given tet (trial and error)
%IT USES A DIFFERENT FORMAT FOR THE PARAMETER FILE
%Author: Russell Hayden, 2007 -- russellhayden@gmail.com

function y = SimulationSetupDynamicAniso(MeshFileName, ParameterFileName, maxContourDist)
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
    %end mesh importing, Start Simulation setup
    %fem mesh will be created below
    
    %Pars parameter file for required information
    %
    %you may use matlab style comments in param files
    disp(['Opening Parameter File: ' ParameterFileName])
    parametersTemp = textread(ParameterFileName, '%s', 'commentstyle','matlab', 'delimiter', '\t');
    parameters = cell(0);
    z = 1;
    for i = 1:1:size(parametersTemp,1)
        if (not(strcmpi(parametersTemp{i}, '')))        %remove empty terms
            parameters{z} = parametersTemp{i};
            z = z + 1;
        end
    end
    clear z;
    clear i;
    clear parametersTemp;
    
    %pull in material names with their ID#, along with subdomain parameters
    disp('Parameter File open, starting to pars Material Name Index (Subdomains).')
    i = 1;
    numMaterials = 0;
    materialVector = cell(0, 0);
    while (not(strcmpi(parameters{i}, 'Subdomain Parameter(s)')) && i~= 250)
        i = i + 1;
    end
    if (i == 250)
        error('Cannot find the term "Subdomain Parameter(s)"')
    end
    dynamicList = [0];  %keep track of which materials are to be dynamically defined
    i = i + 1;          %now indexing the start of the first material definition
    while (not(strcmpi(parameters{i}, 'd_aniso Conductivities (long trans)')) && i ~= 250)
        try
            numMaterials = numMaterials + 1;
            materialIndex = str2num(parameters{i});
            i = i+1;
            materialVector{materialIndex, 1} = parameters{i}; %specify name
            i = i+1;
            materialVector{materialIndex, 2} = parameters{i}; %specify subdomain type
            if (strcmp(parameters{i}, 'aniso'))         %case matters here
                materialVector{materialIndex, 3} = 0;   %place holder
                i = i+1;
                a11 = parameters{i};
                i = i+1;
                a12 = parameters{i};
                i = i+1;
                a13 = parameters{i};
                i = i+1;
                a21 = parameters{i};
                i = i+1;
                a22 = parameters{i};
                i = i+1;
                a23 = parameters{i};
                i = i+1;
                a31 = parameters{i};
                i = i+1;
                a32 = parameters{i};
                i = i+1;
                a33 = parameters{i};
                materialVector{materialIndex, 4} = {a11, a12, a13; a21, a22, a23; a31, a32, a33};
            elseif (strcmp(parameters{i}, 'iso'))
                i = i+1;
                materialVector{materialIndex, 3} = parameters{i};
                materialVector{materialIndex, 4} = {0,0,0;0,0,0;0,0,0};    %place holder
            elseif (strcmp(parameters{i}, 'd_aniso'))
                i = i+1;
                dynamicList = [dynamicList materialIndex];      %remember which ones need further processing
                materialVector{materialIndex, 2} = 'iso';       %default to isotropic
                materialVector{materialIndex, 3} = parameters{i};   %pull in the default isotropic value
                materialVector{materialIndex, 4} = {0,0,0;0,0,0;0,0,0};    %place holder
            else
                error('There was a problem while parsing material info.  Check against the template file.  Case matters when specifying subdomain type.  Only "iso", "aniso", and "d_aniso" types are supported')
            end
        catch
            disp('???????????????????????ERROR TRACE?????????????????????????')
            disp(['Error near the Material Info section of parameter file: ' ParameterFileName])
            rethrow(lasterror)
        end 
        i = i + 1;
    end
    disp([num2str(numMaterials)  ' Materials Found.'])
    if (numMaterials == 0 || i == 250)
        error('Incorrect Parameter File.  Check the Parameter File Template. Error in material definitions.')
    end
    
    dynamicList = dynamicList(2:size(dynamicList,2));   %get rid of that initial zero

   %pull information for dynamic aniso definitions, starting with the
   %longitudinal and transverse conductivity values
    disp('Subdomains parsed.  Beginning to process dynamic aniso defintions.')
    while (not(strcmpi(parameters{i}, 'd_aniso Conductivities (long trans)')) && i ~= 1000)
        i = i + 1;
    end    
    if (i == 1000)
        error('Cannot find the term "d_aniso Conductivities (long trans)"')
    end
    try
        i = i + 1;
        longConductivity = str2num(parameters{i});       %pull in the conductivities of the dynamic aniso 
        i = i + 1;
        tranConductivity = str2num(parameters{i});
    catch
        disp('???????????????????????ERROR TRACE?????????????????????????')
        disp(['Error near the d_aniso Conductivities section of parameter file: ' ParameterFileName])
        rethrow(lasterror)
    end 

    %now pull in the contour defintion file names
    while (not(strcmpi(parameters{i}, 'd_aniso Contour Files')) && i ~= 1000)
        i = i + 1;
    end    
    if (i == 1000)
        error('Cannot find the term "d_aniso Contour Files"')
    end
    i = i + 1;  %should now be pointing to first contour file name
    contourFileNames = cell(0,0);
    numContourFiles = 0;
    %pull in each file name
    while (not(strcmpi(parameters{i}, 'Boundary Group Assignment')) && i ~= 1000)
        numContourFiles = numContourFiles + 1;
        contourFileNames{numContourFiles,1} = parameters{i};
        i = i + 1;
    end
    disp([num2str(numContourFiles)  ' Contour File(s) Found.  Starting domain assignment and aniso tensor computation.'])
    if (numContourFiles == 0 || i == 1000)
        error('Incorrect Parameter File.  Check the Parameter File Template.  Error in contour file names section.')
    end    
    %now finish the subdomain definitions by calculating and including the
    %dynamic aniso domains
    %load contour lists and stack them into one matrix
    try
        j = 1;
        contMatrix = load(contourFileNames{1,1});  
        for j = 2:1:numContourFiles
            contMatrix = [contMatrix load(contourFileNames{j,1})];
        end
    catch
        disp('???????????????????????ERROR TRACE?????????????????????????')
        disp(['Cannot find contour file named: ' contourFileNames{j,1}])
        rethrow(lasterror)
    end 
        
    %reassign the domains (each contour segment gets its own domain group)
    myMeshRework = MeshRework(g{1}, (g{2}-1), g{3}); %must subtract 1 from tet matrix because java starts at index 0
    myMeshRework.nerveAniso(contMatrix, dynamicList, maxContourDist);
    maxDomainNum = max(g{3});     %find the maximum domain number in the original domain matrix
    g{3} = double(myMeshRework.dMatrix);    %use the updated domain matrix, convert to double so its not int32
    d_anisoTensors = cell(0,0);         %will hold the aniso tensors not explicitly defined
    %compute the aniso tensors for each possible contour line
    j = 0;
    for j = 1:1:(size(contMatrix,2)-1)  %cycle through each contour segment
        anisoMatrix = AnisoRotationMatrix(contMatrix(:,j),contMatrix(:,j+1));
        d_anisoTensors{maxDomainNum+j, 1} = anisoMatrix*[longConductivity 0 0; 0 tranConductivity 0; 0 0 tranConductivity]*(anisoMatrix');
    end
    %now add these new groups to the materialVector cell
    j = 0;
    for j = 1:1:(size(contMatrix,2)-1)  %cycle through each contour segment
        materialVector{maxDomainNum+j,1} = ['d_aniso_' num2str(j)];   %specify name
        materialVector{maxDomainNum+j,2} = 'aniso';         %specify type
        materialVector{maxDomainNum+j,3} = 0;       %placeholder
        %input aniso tensor AS A CELL
        materialVector{maxDomainNum+j,4} = mat2cell(d_anisoTensors{maxDomainNum+j,1}, [1 1 1], [1 1 1]);     
    end
    %
    %done with the dynamic stuff, back to simple parsing
            
    %pull in Boundary Group Assignments
    disp('Dynamic definitions finished. Beginning to pars Boundary Group Assignments.')
    while (not(strcmpi(parameters{i}, 'Boundary Group Parameter(s)')) && i ~= 1000)
        i = i + 1;
    end    
    if (i == 1000)
        error('Cannot find the term "Boundary Group Parameter(s)"')
    end
    i = i + 1;
    numBoundGroups = 0;
    boundaryVector = cell(0, 0);
    while (not(strcmpi(parameters{i}, 'Boundary Group Matrix')) && i ~= 1000)
        try
            numBoundGroups = numBoundGroups + 1;
            boundaryIndex = str2num(parameters{i});
            i = i + 1;
            boundaryVector{boundaryIndex, 1} = parameters{i};       %group name
            i = i + 1;
            boundaryVector{boundaryIndex, 2} = parameters{i};       %boundary parameter
            if (strcmp(parameters{i}, 'nJ0'))         %case matters here
                %insulation
                boundaryVector{boundaryIndex, 3} = 0;               %place holder
            elseif (strcmp(parameters{i}, 'cont'))
                %continuity
                boundaryVector{boundaryIndex, 3} = 0;               %place holder
            elseif (strcmp(parameters{i}, 'V0'))
                %ground
                boundaryVector{boundaryIndex, 3} = 0;               %place holder
            elseif (strcmp(parameters{i}, 'V'))
                %electric potential
                i = i + 1;
                boundaryVector{boundaryIndex, 3} = parameters{i};
            elseif (strcmp(parameters{i}, 'dnJ'))
                %current source
                i = i + 1;
                boundaryVector{boundaryIndex, 3} = parameters{i};
                disp('Warning: It is preferred that isopotential surfaces be used.  COMSOL current source implementation may be error prone.')
            else
                error('There was a problem while parsing boundary group info.  Check against the template file.  Case matters when specifying boundary type.')
            end
        catch
            disp('???????????????????????ERROR TRACE?????????????????????????')
            disp(['Error near the Boundary Group Assignment section of parameter file: ' ParameterFileName])
            rethrow(lasterror)
        end 
        i = i + 1;
    end
    %finally, add one more boundary group for the case of a redefined
    %domain intersecting another redefined domain (i.e. redefined to fit the
    %contour), default is cont
    boundaryVector{numBoundGroups+1, 1} = 'd_lumped_selfIntersection';
    boundaryVector{numBoundGroups+1, 2} = 'cont';
    boundaryVector{numBoundGroups+1, 3} = 0;        %place holder
    disp([num2str(numBoundGroups)  ' Boundary Groups Found.'])
    if (numBoundGroups == 0 || i == 1000)
        error('Incorrect Parameter File.  Check the Parameter File Template.  Error in boundary group definitions.')
    end
    
    %pars individual boundary assignments
    disp('Boundary group assignments parsed.  Beginning to read Boundary Group Matrix.')
    try
        boundaryAssignments = zeros(numMaterials, numMaterials);
        while (not(strcmpi(parameters{i}, 'Exterior')) && i ~= 5000)
            i = i + 1;
        end  
        if (i == 5000)
            error('Cannot find Exterior group in Boundary Group Matrix.')
        end
        i = i + 1;
        j = 0;
        for j = 1:1:(numMaterials+2)    %need to add two here because we added 'd_lumped' and 'Exterior'
            i = i + 1;          %bypass the name
            if (j ~= 1)
                for q = 1:1:(j-1)
                    boundaryAssignments(j,q) = str2num(parameters{i});
                    boundaryAssignments(q,j) = str2num(parameters{i});
                    i = i + 1;
                end
            end
        end
        disp('Acquired assignments from Boundary Group Matrix.')
    catch
        disp('???????????????????????ERROR TRACE?????????????????????????')
        disp('Error while reading Boundary Group Matrix.  Make sure there is a d_Lumped group and an Exterior group.')
        rethrow(lasterror);
    end
    disp(['Finished parsing parameter file: ' ParameterFileName])
    disp('Attempting to construct a valid COMSOL mesh...')
    clear parameters;
    %
    %
    %END parsing Parameter file

    %now finish putting together the femmesh
    %
    %
    try
        el = cell(1,0);
        el{1} = struct('type','tet','elem',g{2},'dom',g{3});
        m = femmesh(g{1},el);
        m = meshenrich(m, 'faceparam','off');   %faceparam fails for complicated meshes
        fem.mesh=m;
    catch
        disp('???????????????????????ERROR TRACE?????????????????????????')
        disp('Error finalizing the femmesh object.')
        rethrow(lasterror)
    end
    clear m;        %save memory, these objects are large!
    clear e1;
    %determine the actual amount of subdomains that have resulted (some segments may have not been used)
    sortedG = sort(g{3});
    numSubDomains = max(sortedG(find(sortedG~=0)));     %used when defining equ for COMSOL  
    clear sortedG;
    clear g;
    clear myMeshRework;
    disp(['Femmesh object created successfully.  Finished with: ' MeshFileName])
    %
    %
    %END mesh generation


    %Boundary Condition Setting
    %
    %
    disp('Beginning to compile COMSOL definitions.')
    ud = flgeomud(fem.mesh);	            %get border info (subdomain to boundary relationship)
    %note that flgeomud is NOT documented, I got this from COMSOL support
    %Define Subdomain and Boundary Conditions and reset Multiphysics equations
    appl.mode.class = 'ConductiveMediaDC';  %select our mode
    appl.border = 'on';                     %internal boundaries are on
    appl.assignsuffix = '_dc';              %appends this for dc mode
    %boundary Setup
    bnd.V0 = boundaryVector(:,3);              %isopotential surfaces
    bnd.Jn = boundaryVector(:,3);              %current sources
    bnd.type = boundaryVector(:,2);
    bnd.name = boundaryVector(:,1);
    ind  = zeros(1, size(ud,2));
    for p = 1:1:size(ud,2)                  %assign boundaries to boundary groups according to Boundary Group Matrix
        indexA = ud(1,p);
        indexB = ud(2,p);
        flagInternalIntersection = 0;
        if (indexA > maxDomainNum && indexB > maxDomainNum) %d_lumped self intersection, use default
            ind(p) = numBoundGroups+1;      %set to the default one created (default = 'cont')
            flagInternalIntersection = 1;
        elseif (indexA > maxDomainNum)          %just one side has a d_lumped domain
            indexA = size(boundaryAssignments,1)-1; %set to 'd_Lumped' row (should be just before 'Exterior')
        elseif (indexB > maxDomainNum)
            indexB = size(boundaryAssignments,1)-1; %set to 'd_Lumped' column (should be just before 'Exterior')
        end
        %take care of exterior boundary case
        if (indexA == 0)                    %first index is 'Exterior'
            indexA = size(boundaryAssignments, 1);   %apply the correct number in the matrix (exterior is last)
        elseif (indexB == 0)                %second index is 'Exterior'
            indexB = size(boundaryAssignments, 1);
        end
        %assign to ind
        if (flagInternalIntersection == 0)
            ind(p) = boundaryAssignments(indexA,indexB);
        end
    end
    bnd.ind = ind;
    appl.bnd = bnd;
    clear ind;
    %
    %
    %End Boundary Setting
    
    %Subdomain Setup
    %
    %
    equ.sigma = materialVector(:,3);        %conductances for isotropic 
    equ.sigmatensor = materialVector(:,4);  %conductances for anisotropic
    equ.sigtype = materialVector(:,2);      %group types
    equ.name = materialVector(:,1);         %group names
    equ.ind = [1:numSubDomains];            %assign subdomains to subdomain names and properties
    appl.equ = equ;
    %
    %
    %End Subdomain Setup
    
    
    fem.appl{1} = appl;                     %using an application mode, so use an appl structure 
%should we specify that lagrange 1st order shape function be used here?, I
%think the default is 2nd order lagrange for conductive media mode
%I think this involves appl.shape for shape functions, and appl.sshape for
%preffered geometry order
%these two instructions sets elements to first order lagrange
%prop.elemdefault='Lag1';
%appl.prop = prop;
    disp('Attempting to complete model structure.')
    fem=multiphysics(fem);                      %update model equations
    disp('Success: model structure complete.')
    y = fem;                                    %return the complete model, ready to solve at this point