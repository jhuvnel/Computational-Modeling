%this function takes in a solved fem structure and integrates the current
%leaving subdomain (the COMSOL index, not group number), returns in Amps

function y = integrateCurrent(fem, subdomain)
    ud = flgeomud(fem.mesh);     %get border info (subdomain to boundary relationship)
    currentSum = 0;
    %cycle through all boundaries, intergrating those that lie next to subdomain
    for i = 1:1:size(ud,2)
        if (ud(1,i) == subdomain)   %outward facing normal
            currentSum = currentSum - postint(fem,'nJ_dc', 'dl',i,'edim',2);   %returns net outflow of current across boundary
        elseif (ud(2,i) == subdomain) %inward facing normal
            currentSum = currentSum + postint(fem,'nJ_dc', 'dl',i,'edim',2);   %returns net outflow of current across boundary
        end
    end
    y = currentSum;
            
    