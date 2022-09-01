

%plotgeorgeCDS.m
%
%calls: PlotCircleOnArbSphereAroundXYZ, russCirclePlot2

%This is TE Hullar's renormalized MeanAllNormals from his 2006 Chinch Paper.

NormalsNames= [        ' +X'     ' +Y'     ' +Z'     '+LA'      '+LH'     '+LP'      '-RA'    '-RH'    '-RP'];
MeanAllnormals =  [       1         0        0      -0.49122   -0.80631  -0.32283  0.488716   0.818676   0.311848;...
                          0         1        0      0.72933    0.15743   -0.67474  0.728066   0.097028  -0.67684;...
                          0         0        1      -0.47621   0.57017   -0.66371  0.48070    -0.565999  0.66681];  
StDvRenormedNmls= [       0         0        0       0.0370    0.0820    0.0660    0.0350    0.0630    0.0620;...
                          0         0        0       0.0070    0.0870    0.0140    0.0220    0.1340    0.0500;...
                          0         0        0       0.0300    0.1170    0.0300    0.0500    0.0940    0.0250];
                     
AxesNames =        ['LH'     'LH>LA'     'LH+LA'     'LH<LA'      'LA'     'LA>LP'      'LA+LP'    'LA<LP'    'LP'     'LP>LH'    'LP+LH'     'LP<LH'];
%MeanAllChinches =  [0.02958   -0.65778   -0.13478    -0.34605    -0.7214   -0.97842    -0.97242    -0.5793    -0.65128  -0.37669   -0.58456   -0.65357;...
%                    -0.27606  0.046984   0.536683    0.403724    0.628837  0.164083    0.161508    -0.74428   -0.71108  0.682567   -0.66605   -0.61066;...
%                    0.960685  0.751746   0.832951    0.84691     0.290086  0.125594    0.168254    0.332358   0.264952  0.626266   0.46332    0.44714];
LeftEyeMeanAllChinches = [-0.31448 -0.52027 -0.624695 -0.49237  -0.704361  -0.942809  -0.703163   -0.666667  -0.863868  -0.681005  -0.683763  -0.275241;...
                          0.104828 0.346844   0       0.615457  0.7043607  0.2357023  0.1054744   -0.666667  -0.431934  -0.425628  -0.569803  -0.385337;...
                          0.943456 0.780399 0.7808688 0.615457  0.0880451  0.2357023  0.7031626   0.3333333  -0.259161  0.5958796  0.4558423  0.8807710];
RightEyeMeanAllChinches=[0.240772  0        -0.447214 -0.41087  -0.596285  -0.775632  -0.970143   -0.316228  -0.816497  -0.894427  0.4082483  0.1270001;...
                         0.120386  0        0         0.753266  0.745356   0.5170877  -0.242536   -0.948683  -0.408248  0          -0.816497  -0.762001;...
                         0.963087  0        0.8944271 0.513590  0.298142   0.3619614  0           0          -0.408248  0.4472136  -0.408248  0.6350006];
StdDvAllangles =...
   [0.0000         0         0    4.2326    5.3480    5.0052    5.8956    6.2236    5.3279    0.2709;...
         0    0.0000    0.0000    4.8127    7.8355    5.5815    5.7279    7.3122    5.1656    0.5705;...
         0    0.0000    0.0000    5.7219    7.3683    6.4943    6.7667    6.8524    6.7750    0.3613;...
    4.2326    4.8127    5.7219    0.3806    6.2655    3.6854    9.5043    9.7071    7.1208    5.6465;...
    5.3480    7.8355    7.3683    6.2655    0.3606    4.6200   10.4801    6.9215    9.0185    7.4464;...
    5.0052    5.5815    6.4943    3.6854    4.6200    0.2693    7.3612    9.1711    9.6960    6.4149;...
    5.8956    5.7279    6.7667    9.5043   10.4801    7.3612    0.3862    6.2806    4.3307    6.5301;...
    6.2236    7.3122    6.8524    9.7071    6.9215    9.1711    6.2806    0.3406    5.1706    6.8038;...
    5.3279    5.1656    6.7750    7.1208    9.0185    9.6960    4.3307    5.1706    0.4004    6.9082;...
    0.2709    0.5705    0.3613    5.6465    7.4464    6.4149    6.5301    6.8038    6.9082    0.3690];
                     % LHgeorge LA george LPgeorge LPch050506B
% AxesNamesRuss=['LH stim' 'LA stim' 'LP stim' 'LP stim2'];
% LeftEyeActual=[[-0.98869254335791;0.06173769303483;0.13665837686434] [-0.80999235321120;0.46463160956868;-0.35781259777850][-0.76792093324550;-0.24539672215444;-0.59167380290090] [-0.68589428623602;-0.47389821119726;-0.55224044901909]];
% LeftEyeModel=[[-0.99429752335172;0.10491420991097;-0.01911657959435] [-0.74370548386716;0.62994098729161;-0.22377780452043] [-0.79714662020251;-0.31857188670089;-0.51290273824922] [-0.83392991604344;-0.2269826351235;-0.50303059398029]];                 
                         
% %Now adjust for tilt off Reid's line
% Reid_up_pitch = input ('Enter how many degrees nose-up Reid line was in Room 2 alignment (use -45 for chinch): ');
Reid_up_pitch = -45;
a=Reid_up_pitch*pi/180;
rotY3_plusReidpitch= [cos(a)  0  sin(a);
                        0      1   0;
                     -sin(a) 0   cos(a)];
LeftEyeMeanAllChinches=(rotY3_plusReidpitch*LeftEyeMeanAllChinches);
RightEyeMeanAllChinches=(rotY3_plusReidpitch*RightEyeMeanAllChinches);

for fignum=1:4,

    figure

    hold on
    [xx,yy,zz]=sphere(40);
    surf(xx/2,yy/2,zz/2);
    colormap(white);
    hold on
    hand= plot3([0 MeanAllnormals(1,1)],[0 MeanAllnormals(2,1)],[0 MeanAllnormals(3,1)],'k',...
        [0 MeanAllnormals(1,2)],[0 MeanAllnormals(2,2)],[0 MeanAllnormals(3,2)],'k',...
        [0 MeanAllnormals(1,3)],[0 MeanAllnormals(2,3)],[0 MeanAllnormals(3,3)],'k',...
        [0 MeanAllnormals(1,4)],[0 MeanAllnormals(2,4)],[0 MeanAllnormals(3,4)],'g',... %left = cyan
        [0 MeanAllnormals(1,5)],[0 MeanAllnormals(2,5)],[0 MeanAllnormals(3,5)],'r',...
        [0 MeanAllnormals(1,6)],[0 MeanAllnormals(2,6)],[0 MeanAllnormals(3,6)],'b');
    %                                                                                         ,...
    %             [0 MeanAllnormals(1,7)],[0 MeanAllnormals(2,7)],[0 MeanAllnormals(3,7)],'r',... %right = black
    %             [0 MeanAllnormals(1,8)],[0 MeanAllnormals(2,8)],[0 MeanAllnormals(3,8)],'r',...
    %             [0 MeanAllnormals(1,9)],[0 MeanAllnormals(2,9)],[0 MeanAllnormals(3,9)],'r');
    set (hand, 'Linewidth', 2);
    grid on;
    hold on; %we'll keep adding to this plot
%    view(-120,25);
view(-90,0);
    axis ([-1 1 -1 1 -1 1]);
    axis square
    %for both L and R
    % text(MeanAllnormals(1,:)*1.1,MeanAllnormals(2,:)*1.1,MeanAllnormals(3,:)*1.1,...
    %     [' +X';' +Y';' +Z';'+LA';'+LH';'+LP';'-RA';'-RH';'-RP'],'FontWeight','bold','FontSize',14);

    %for just L:
    text(MeanAllnormals(1,1:6)*1.1,MeanAllnormals(2,1:6)*1.1,MeanAllnormals(3,1:6)*1.1,...
        {'+X';'+Y';'+Z';'LA';'LH';'LP'},'FontSize',12,'FontWeight','bold');
    ticks=[-1;-0.5;0;0.5;1];
    ticklabs={'-1';' ';' ';' ';'1'};
set(gca,'XTick',ticks,'XTickLabel',ticklabs,'YTick',ticks,'YTickLabel',ticklabs,'ZTick',ticks,'ZTickLabel',ticklabs);
    clear xx yy zz ans ii jj
    h=PlotCircleOnArbSphereAroundXYZ(MeanAllnormals(:,4),pi*sqrt(sum((StdDvAllangles(1:3,4)).^2)/3)/180,0.5,'g');set (h, 'Linewidth', 1.5);
    h=PlotCircleOnArbSphereAroundXYZ(MeanAllnormals(:,5),pi*sqrt(sum((StdDvAllangles(1:3,5)).^2)/3)/180,0.5,'r');set (h, 'Linewidth', 1.5);
    h=PlotCircleOnArbSphereAroundXYZ(MeanAllnormals(:,6),pi*sqrt(sum((StdDvAllangles(1:3,6)).^2)/3)/180,0.5,'b');set (h, 'Linewidth', 1.5);
    % h=PlotCircleOnArbSphereAroundXYZ(MeanAllnormals(:,7),pi*sqrt(sum((StdDvAllangles(1:3,7)).^2)/3)/180,0.5,'r');set (h, 'Linewidth', 1.5);
    % h=PlotCircleOnArbSphereAroundXYZ(MeanAllnormals(:,8),pi*sqrt(sum((StdDvAllangles(1:3,8)).^2)/3)/180,0.5,'r');set (h, 'Linewidth', 1.5);
    % h=PlotCircleOnArbSphereAroundXYZ(MeanAllnormals(:,9),pi*sqrt(sum((StdDvAllangles(1:3,9)).^2)/3)/180,0.5,'r');set (h, 'Linewidth', 1.5);
    hold on;

    ev = [0;0;0];

    switch (fignum)      %Yellow = Actual Axis of Eye Stim      Cyan = Model Prediction
        case (1) %horizontal Ch0505060A
            title('LH Ch0505060A                                  ');
            h = russCirclePlot2(2, [-0.799;0.156;0.565], 'r', [-0.491;0.729;-0.476], 'g', [-0.322;-0.673;-0.662], 'b', ...
                [-0.98869254335791;0.06173769303483;0.13665837686434], 'y',[-0.99429752335172;0.10491420991097;...
                -0.01911657959435],'c');

        case (2) %superior Ch0505060A
            title('LA Ch0505060A                                  ');
            h = russCirclePlot2(2, [-0.799;0.156;0.565], 'r', [-0.491;0.729;-0.476], 'g', [-0.322;-0.673;-0.662], 'b', ...
                [-0.80999235321120;0.46463160956868;-0.35781259777850], 'y',[-0.74370548386716;...
                0.62994098729161;-0.22377780452043],'c');

        case (3) %posterior Ch0505060A
            title('LP Ch0505060A                                  ');
            h = russCirclePlot2(2, [-0.799;0.156;0.565], 'r', [-0.491;0.729;-0.476], 'g', [-0.322;-0.673;-0.662], 'b', ...
                [-0.76792093324550;-0.24539672215444;-0.59167380290090], 'y',...
                [-0.79714662020251;-0.31857188670089;-0.51290273824922], 'c');

        case (4) %posterior Ch0505060B
            title('LP Ch0505060B                                  ');
            h = russCirclePlot2(2, [-0.799;0.156;0.565], 'r', [-0.491;0.729;-0.476], 'g', [-0.322;-0.673;-0.662], 'b', ...
                [-0.68589428623602;-0.47389821119726;-0.55224044901909], 'y',...
                [-0.83392991604344;-0.2269826351235;-0.50303059398029], 'c');

    end %switch
        axis vis3d;
end %for
