%this routine will plot a set of triangles

%q adds to all of the indexes, in case your using java convention
%modifiers are for the plot, like '-g' for a green trace
function y = plotTetDomain(tets, verts, q, m)
    hold on;
    for i = 1:size(tets,2)
        tri1 = [tets(1,i); tets(2, i); tets(3,i)];
        tri2 = [tets(1,i); tets(2, i); tets(4,i)];
        tri3 = [tets(1,i); tets(3, i); tets(4,i)];
        tri4 = [tets(2,i); tets(3, i); tets(4,i)];
        plotTriSurf(tri1,verts,q,m);
        plotTriSurf(tri2,verts,q,m);
        plotTriSurf(tri3,verts,q,m);
        plotTriSurf(tri4,verts,q,m);
    end
    return;
                