hfig = gcf;
htiles = get(hfig,'children');

fnew = figure;
for cnt=1:3
    hplots = htiles.Children(end-cnt+1); % get the axes in that subplot
    axCopy = copyobj(hplots,fnew);
    subplot(4,1,cnt,axCopy)
    
     

    ylabel('% Activation')
    if cnt == 3
        xlabel('Pulse Amplitude [\muA]')
    end
end

legend('Normal Current Range', 'Lateral amp. n.', 'Anterior amp. n.', 'Posterior amp. n.', 'Saccular n.', 'Utricular n.', 'Facial n.', 'Cochlear n.')
