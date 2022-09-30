%this routine will plot a contour

%q adds to all of the indexes, in case your using java convention
%modifiers are for the plot, like '-g' for a green trace
function y = plotTriSurf(vertInd, verts, q, m1)
    hold on;
    for i = 1:size(vertInd,2)
        plot3([verts(1,vertInd(1,i)+q) verts(1,vertInd(2,i)+q)],...
                [verts(2,vertInd(1,i)+q) verts(2,vertInd(2,i)+q)],...
                    [verts(3,vertInd(1,i)+q) verts(3,vertInd(2,i)+q)], m1);
    end
    return;
                