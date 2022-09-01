currentRange = linspace(0,12,500);
current = 200e-6;

horSum = zeros(1,size(currentRange,2));
posSum = zeros(1,size(currentRange,2));
supSum = zeros(1,size(currentRange,2));
USum = zeros(1,size(currentRange,2));
SSum = zeros(1,size(currentRange,2));

for i = 1:size(currentRange,2)
    horSum(i) = size(find(horSCC_SimCell{1,1}{4,1} < currentRange(i)),1);
    horSum(i) = horSum(i) - size(find(horSCC_SimCell{1,1}{4,1} <= 0),1);
    horSum(i) = horSum(i) + size(find(horSCC_SimCell{1,2}{4,1} < currentRange(i)),1);
    horSum(i) = horSum(i) - size(find(horSCC_SimCell{1,2}{4,1} <= 0),1);
    horSum(i) = horSum(i) + size(find(horSCC_SimCell{1,3}{4,1} < currentRange(i)),1);
    horSum(i) = horSum(i) - size(find(horSCC_SimCell{1,3}{4,1} <= 0),1);
    horSum(i) = horSum(i) + size(find(horSCC_SimCell{1,4}{4,1} < currentRange(i)),1);
    horSum(i) = horSum(i) - size(find(horSCC_SimCell{1,4}{4,1} <= 0),1);
    horSum(i) = horSum(i) + size(find(horSCC_SimCell{1,5}{4,1} < currentRange(i)),1);
    horSum(i) = horSum(i) - size(find(horSCC_SimCell{1,5}{4,1} <= 0),1);
    horSum(i) = horSum(i) + size(find(horSCC_SimCell{1,6}{4,1} < currentRange(i)),1);
    horSum(i) = horSum(i) - size(find(horSCC_SimCell{1,6}{4,1} <= 0),1);


    posSum(i) = size(find(posSCC_SimCell{1,1}{4,1} < currentRange(i)),1);
    posSum(i) = posSum(i) - size(find(posSCC_SimCell{1,1}{4,1} <= 0),1);
    posSum(i) = posSum(i) + size(find(posSCC_SimCell{1,2}{4,1} < currentRange(i)),1);
    posSum(i) = posSum(i) - size(find(posSCC_SimCell{1,2}{4,1} <= 0),1);
    posSum(i) = posSum(i) + size(find(posSCC_SimCell{1,3}{4,1} < currentRange(i)),1);
    posSum(i) = posSum(i) - size(find(posSCC_SimCell{1,3}{4,1} <= 0),1);
    posSum(i) = posSum(i) + size(find(posSCC_SimCell{1,4}{4,1} < currentRange(i)),1);
    posSum(i) = posSum(i) - size(find(posSCC_SimCell{1,4}{4,1} <= 0),1);
    posSum(i) = posSum(i) + size(find(posSCC_SimCell{1,5}{4,1} < currentRange(i)),1);
    posSum(i) = posSum(i) - size(find(posSCC_SimCell{1,5}{4,1} <= 0),1);
    posSum(i) = posSum(i) + size(find(posSCC_SimCell{1,6}{4,1} < currentRange(i)),1);
    posSum(i) = posSum(i) - size(find(posSCC_SimCell{1,6}{4,1} <= 0),1);

    supSum(i) = size(find(supSCC_SimCell{1,1}{4,1} < currentRange(i)),1);
    supSum(i) = supSum(i) - size(find(supSCC_SimCell{1,1}{4,1} <= 0),1);
    supSum(i) = supSum(i) + size(find(supSCC_SimCell{1,2}{4,1} < currentRange(i)),1);
    supSum(i) = supSum(i) - size(find(supSCC_SimCell{1,2}{4,1} <= 0),1);
    supSum(i) = supSum(i) + size(find(supSCC_SimCell{1,3}{4,1} < currentRange(i)),1);
    supSum(i) = supSum(i) - size(find(supSCC_SimCell{1,3}{4,1} <= 0),1);
    supSum(i) = supSum(i) + size(find(supSCC_SimCell{1,4}{4,1} < currentRange(i)),1);
    supSum(i) = supSum(i) - size(find(supSCC_SimCell{1,4}{4,1} <= 0),1);
    supSum(i) = supSum(i) + size(find(supSCC_SimCell{1,5}{4,1} < currentRange(i)),1);
    supSum(i) = supSum(i) - size(find(supSCC_SimCell{1,5}{4,1} <= 0),1);
    supSum(i) = supSum(i) + size(find(supSCC_SimCell{1,6}{4,1} < currentRange(i)),1);
    supSum(i) = supSum(i) - size(find(supSCC_SimCell{1,6}{4,1} <= 0),1);

    USum(i) = size(find(utricle_SimCell{1,1}{4,1} < currentRange(i)),1);
    USum(i) = USum(i) - size(find(utricle_SimCell{1,1}{4,1} <= 0),1);
    USum(i) = USum(i) + size(find(utricle_SimCell{1,2}{4,1} < currentRange(i)),1);
    USum(i) = USum(i) - size(find(utricle_SimCell{1,2}{4,1} <= 0),1);
    USum(i) = USum(i) + size(find(utricle_SimCell{1,3}{4,1} < currentRange(i)),1);
    USum(i) = USum(i) - size(find(utricle_SimCell{1,3}{4,1} <= 0),1);
    USum(i) = USum(i) + size(find(utricle_SimCell{1,4}{4,1} < currentRange(i)),1);
    USum(i) = USum(i) - size(find(utricle_SimCell{1,4}{4,1} <= 0),1);
    USum(i) = USum(i) + size(find(utricle_SimCell{1,5}{4,1} < currentRange(i)),1);
    USum(i) = USum(i) - size(find(utricle_SimCell{1,5}{4,1} <= 0),1);
    USum(i) = USum(i) + size(find(utricle_SimCell{1,6}{4,1} < currentRange(i)),1);
    USum(i) = USum(i) - size(find(utricle_SimCell{1,6}{4,1} <= 0),1);
    USum(i) = USum(i) + size(find(utricle_SimCell{1,7}{4,1} < currentRange(i)),1);
    USum(i) = USum(i) - size(find(utricle_SimCell{1,7}{4,1} <= 0),1);

    SSum(i) = size(find(saccule_SimCell{1,1}{4,1} < currentRange(i)),1);
    SSum(i) = SSum(i) - size(find(saccule_SimCell{1,1}{4,1} <= 0),1);
    SSum(i) = SSum(i) + size(find(saccule_SimCell{1,2}{4,1} < currentRange(i)),1);
    SSum(i) = SSum(i) - size(find(saccule_SimCell{1,2}{4,1} <= 0),1);
    SSum(i) = SSum(i) + size(find(saccule_SimCell{1,3}{4,1} < currentRange(i)),1);
    SSum(i) = SSum(i) - size(find(saccule_SimCell{1,3}{4,1} <= 0),1);
    SSum(i) = SSum(i) + size(find(saccule_SimCell{1,4}{4,1} < currentRange(i)),1);
    SSum(i) = SSum(i) - size(find(saccule_SimCell{1,4}{4,1} <= 0),1);
    SSum(i) = SSum(i) + size(find(saccule_SimCell{1,5}{4,1} < currentRange(i)),1);
    SSum(i) = SSum(i) - size(find(saccule_SimCell{1,5}{4,1} <= 0),1);
    SSum(i) = SSum(i) + size(find(saccule_SimCell{1,6}{4,1} < currentRange(i)),1);
    SSum(i) = SSum(i) - size(find(saccule_SimCell{1,6}{4,1} <= 0),1);
    SSum(i) = SSum(i) + size(find(saccule_SimCell{1,7}{4,1} < currentRange(i)),1);
    SSum(i) = SSum(i) - size(find(saccule_SimCell{1,7}{4,1} <= 0),1);
    
end



plot(currentRange*current, horSum/5.05, '-b', currentRange*current, posSum/5.05, '-r', currentRange*current, supSum/5.05, '-g',currentRange*current, USum/5.05, '-k', currentRange*current, SSum/5.05, '-y') 
title('Horizontal (blue), posterior (red), superior (green, utricle (black), saccule(yellow)');
xlabel('current in amps');
ylabel('percent of fibers stimulated');
axis([0 2.5e-3 0 100])





