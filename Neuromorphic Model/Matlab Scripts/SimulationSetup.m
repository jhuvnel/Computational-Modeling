%this function uses two seperate files (a mesh file and simulation
%parameter file) to setup a comsol simulation.  Note that this function
%uses UCDConverter, which is a Java derived script (meaning you need your
%Java Static class set correctly)
%Please review the Parameter_File_Tutorial file for details on how to create a
%novel parameter file
%Author: Russell Hayden, 2007 -- russhayden@hotmail.com

function y = SimulationSetup(MeshFileName, ParameterFileName)
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
    disp('Trying to create a valid COMSOL mesh structure...')
    try
        el = cell(1,0);
        el{1} = struct('type','tet','elem',g{2},'dom',g{3});
        m = femmesh(g{1},el);
        m = meshenrich(m, 'faceparam','off');   %faceparam fails for complicated meshes
        fem.mesh=m;
        clear g;                %save memory!, these mesh files are very large
        clear m;
        clear e1;
    catch
        disp('???????????????????????ERROR TRACE?????????????????????????')
        disp(['Error while trying to create femmesh structure from UCD file: ' MeshFileName])
        rethrow(lasterror)
    end
    disp(['UCD file converted Successfully.  Finished with: ' MeshFileName])
    %end mesh importing, Start Simulation setup
    
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
    i = i + 1;          %now indexing the start of the first material definition
    while (not(strcmpi(parameters{i}, 'Boundary Group Assignment')) && i ~= 250)
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
            else
                error('There was a problem while parsing material info.  Check against the template file.  Case matters when specifying subdomain type.  Only iso and aniso types are supported')
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
    
    %pull in Boundary Group Assignments
    disp('Subdomains parsed.  Beginning to pars Boundary Group Assignments.')
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
            disp(['Error near the Boundary Group Assignments section of parameter file: ' ParameterFileName])
            rethrow(lasterror)
        end             
        i = i + 1;
    end
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
        for j = 1:1:(numMaterials+1)
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
        disp('Error while reading Boundary Group Matrix.  Make sure there is an Exterior group.')
        rethrow(lasterror);
    end
    disp(['Finished parsing parameter file: ' ParameterFileName])
    clear parameters;
    %
    %
    %END parsing Parameter file

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
        if (indexA == 0)                    %first index is 'Exterior'
            indexA = size(boundaryAssignments, 1);   %apply the correct number in the matrix (exterior is last)
        elseif (indexB == 0)                %second index is 'Exterior'
            indexB = size(boundaryAssignments, 1);
        end
        ind(p) = boundaryAssignments(indexA, indexB);
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
    equ.ind = [1:numMaterials];             %assign subdomains to subdomain names and properties
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