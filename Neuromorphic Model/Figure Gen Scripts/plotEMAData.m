%this function is designed to work in conjunction with the m-file:
%AllVestibFiberRecruitmentVScurrent.m
%the function plots an EMA data set upon the axon recruitment curve

%if normalizer is equal to -1, then the function will normalize the EMA
%data based upon sumArray and normalizePoint (for instance, if you are
%plotting a posterior stimulation case, then you may want to set arraySum  
%to posSum and normalizePoint = EMA's L-RALP value)
%if normalizer is not -1, then its value is used to normalize all data

%sumArray = either posSum, horSum, or supSum from AllVestibFiberRecur...
%EMAcurrent = stimulus magnitude for the given EMA data
%currentStandard = "current" from AllVestibFiberRecruitment...
%currentRange = "currentRange" from AllVestibFiberRecruit...
%emaData = [LARP Horizontal RALP], same format for emaSTD (standard dev)

%returns the value used to normalize data, plots within the "current"
%figure, Only does one eye at a time (doing both is too confusing)

function y = plotEMAData(normalizer, sumArray, normalizerPoint, EMAcurrent,...
                         emaData, emaSTD, currentStandard, currentRange)
    i = 1;
    if (normalizer == -1)
        while (currentRange(i)*currentStandard < EMAcurrent)
            i = i + 1;
        end
        normalizer = sumArray(i)/normalizerPoint;
    end
    
    emaData = emaData*normalizer;
    emaSTD = emaSTD*normalizer;
    
    hold on
    %plot the left eye data
    errorbar(EMAcurrent, emaData(1), emaSTD(1), '-og'); %LA
    errorbar(EMAcurrent, emaData(2), emaSTD(2), '-or'); %LH
    errorbar(EMAcurrent, emaData(3), emaSTD(3), '-ob'); %LP

    y = normalizer;