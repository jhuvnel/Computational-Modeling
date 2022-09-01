%this function imports a UCD format (ASCII, not Binary) mesh and converts
%the information for use with femmesh.m (UCD files have *.inp extensions)
%it uses a Java class to speed up the process, so set the Matlab Java Path appropriately
%Author: Russell Hayden, 2006


function y = UCDconverter(fileName)
    %create a UCDconvert instance
    JavaConverter = UCDConvert(fileName);
    %convert the file
    JavaConverter.convert;
    %pull out data
    vertexList = JavaConverter.vMatrix;
    tetraList = JavaConverter.tMatrix;
    domainList = JavaConverter.dMatrix;
    %close the file
    JavaConverter.closeFile;
    
    y = {vertexList, tetraList, domainList};
