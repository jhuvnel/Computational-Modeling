%use this file to create the mirror image of a data set (may be used to
%make a left ear appear as a right ear if the slices are coronal)
%Continuously numbered data sets ONLY!

originalBase = input('Please enter the base name of the file sequence you wish to mirror (include quotes): ');
originalMinNumber = input('Please enter the # of the first file in the sequence: ');
originalMaxNumber = input('Please enter the # of the last file in the sequence: ');
originalFormat = input('Please indicate the amount of digits the numbers are formated with (none = 1): ');
fileType = input('Please enter the file extension (including the period, eg ".tif", include quotes): ');
newBase = input('Please enter the new file name base (cannot be the original name, include quotes): ');
newFormat = input('Please enter the new format for the numbering (num digits, none = 1): ');

originalFormat = strcat('%0', num2str(originalFormat), '.0f');
newFormat = strcat('%0', num2str(newFormat), '.0f');

j = 0;
for i = [originalMinNumber:originalMaxNumber]
    currentOriginal = strcat(originalBase, num2str(i, originalFormat), fileType);
    currentNewFile = strcat(newBase, num2str(originalMaxNumber - j, newFormat), fileType);
    j = j + 1;
    copyfile(currentOriginal, currentNewFile);
end




