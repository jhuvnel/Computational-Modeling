%SCCSolutionScript does the simulation in the following order:
%1to3 (reg), 3to5 (reg), 5to8 (dimorph), 6to10 (irreg), 2to5 (dimorph),
%4to7 (dimorph)

%what this outputs: a matrix of number activated = [reg1 reg2
%dimorph1 dimorph2 dimorph3 totIreg totReg totDimorph totIreg total]

horSCCAP = zeros(10,1);
supSCCAP = zeros(10,1);
posSCCAP = zeros(10,1);

horSCCAP(1) = size(find(horSCC_SimCell{1}{5,1}(:,1) ~= -1),1);
posSCCAP(1) = size(find(posSCC_SimCell{1}{5,1}(:,1) ~= -1),1);
supSCCAP(1) = size(find(supSCC_SimCell{1}{5,1}(:,1) ~= -1),1);

horSCCAP(2) = size(find(horSCC_SimCell{2}{5,1}(:,1) ~= -1),1);
posSCCAP(2) = size(find(posSCC_SimCell{2}{5,1}(:,1) ~= -1),1);
supSCCAP(2) = size(find(supSCC_SimCell{2}{5,1}(:,1) ~= -1),1);

horSCCAP(5) = size(find(horSCC_SimCell{3}{5,1}(:,1) ~= -1),1);
posSCCAP(5) = size(find(posSCC_SimCell{3}{5,1}(:,1) ~= -1),1);
supSCCAP(5) = size(find(supSCC_SimCell{3}{5,1}(:,1) ~= -1),1);

horSCCAP(6) = size(find(horSCC_SimCell{4}{5,1}(:,1) ~= -1),1);
posSCCAP(6) = size(find(posSCC_SimCell{4}{5,1}(:,1) ~= -1),1);
supSCCAP(6) = size(find(supSCC_SimCell{4}{5,1}(:,1) ~= -1),1);

horSCCAP(3) = size(find(horSCC_SimCell{5}{5,1}(:,1) ~= -1),1);
posSCCAP(3) = size(find(posSCC_SimCell{5}{5,1}(:,1) ~= -1),1);
supSCCAP(3) = size(find(supSCC_SimCell{5}{5,1}(:,1) ~= -1),1);

horSCCAP(4) = size(find(horSCC_SimCell{6}{5,1}(:,1) ~= -1),1);
posSCCAP(4) = size(find(posSCC_SimCell{6}{5,1}(:,1) ~= -1),1);
supSCCAP(4) = size(find(supSCC_SimCell{6}{5,1}(:,1) ~= -1),1);
    
horSCCAP(7) = horSCCAP(1)+horSCCAP(2);
posSCCAP(7) = posSCCAP(1)+posSCCAP(2);
supSCCAP(7) = supSCCAP(1)+supSCCAP(2);

horSCCAP(8) = horSCCAP(3)+horSCCAP(4)+horSCCAP(5);
posSCCAP(8) = posSCCAP(3)+posSCCAP(4)+posSCCAP(5);
supSCCAP(8) = supSCCAP(3)+supSCCAP(4)+supSCCAP(5);

horSCCAP(9) = horSCCAP(6);
posSCCAP(9) = posSCCAP(6);
supSCCAP(9) = supSCCAP(6);

horSCCAP(10) = horSCCAP(7)+horSCCAP(8)+horSCCAP(9);
posSCCAP(10) = posSCCAP(7)+posSCCAP(8)+posSCCAP(9);
supSCCAP(10) = supSCCAP(7)+supSCCAP(8)+supSCCAP(9);

totalActivated = horSCCAP(10)+posSCCAP(10)+supSCCAP(10);
horPer = (horSCCAP(10)/totalActivated)*100;
posPer = (posSCCAP(10)/totalActivated)*100;
supPer = (supSCCAP(10)/totalActivated)*100;

%now find the relitive percentages of individual fiber types
horFiberPer = [horSCCAP(7)/horSCCAP(10);horSCCAP(8)/horSCCAP(10);horSCCAP(9)/horSCCAP(10)];
posFiberPer = [posSCCAP(7)/posSCCAP(10);posSCCAP(8)/posSCCAP(10);posSCCAP(9)/posSCCAP(10)];
supFiberPer = [supSCCAP(7)/supSCCAP(10);supSCCAP(8)/supSCCAP(10);supSCCAP(9)/supSCCAP(10)];




    
    