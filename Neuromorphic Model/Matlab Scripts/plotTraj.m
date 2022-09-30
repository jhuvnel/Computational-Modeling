%this routine will plot a trajectory (i.e. a list of nodes)

%q adds to all of the indexes, in case your using java convention
%m1 is a modifier for the plot, like '-g' for a green trace
function plotTraj(verts, q, m1)
    hold on;
    for i = 1:(size(verts,2)-1)
        plot3([verts(1,i+q) verts(1,i+1+q)],...
                [verts(2,i+q) verts(2,i+1+q)],...
                    [verts(3,i+q) verts(3,i+1+q)], m1);
    end
    return;
                