%this tests AmiraGridConvert to see how its performing
clear all

fileConvert = AmiraGridConvert('testGrid.am');

fileConvert.convert();

nodes = fileConvert.vMatrix;
tet = fileConvert.tMatrix;
domains = fileConvert.dMatrix;
bndTri = fileConvert.bndMatrix;
bndTriDom = fileConvert.bndID;

disp(['Number of nodes: ' num2str(fileConvert.numVert)])
disp(['Number of tets: ' num2str(fileConvert.numTet)])
disp(['Number of bndTriangles: ' num2str(fileConvert.numBndTri)])