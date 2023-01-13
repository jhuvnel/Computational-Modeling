%% Nerve Trajectory Export
% exports a representative axon trajectory for each vestibular nerve
% division based on a selected traj on a plot.


%%
tract_post = [cursor_info_post.Target.XData; cursor_info_post.Target.YData; cursor_info_post.Target.ZData];
%%
tract_lat = [cursor_info_lat.Target.XData; cursor_info_lat.Target.YData; cursor_info_lat.Target.ZData];
%%
tract_ant = [cursor_info_ant.Target.XData; cursor_info_ant.Target.YData; cursor_info_ant.Target.ZData];
%%
tract_sacc = [cursor_info_sacc.Target.XData; cursor_info_sacc.Target.YData; cursor_info_sacc.Target.ZData];
%%
tract_utr = [cursor_info_utr.Target.XData; cursor_info_utr.Target.YData; cursor_info_utr.Target.ZData];
%%
tract_fac = [cursor_info_fac.Target.XData; cursor_info_fac.Target.YData; cursor_info_fac.Target.ZData];
%%
tract_coch = [cursor_info_coch.Target.XData; cursor_info_coch.Target.YData; cursor_info_coch.Target.ZData];

%%
labels = {'Posterior SCC', 'Lateral SCC', 'Anterior SCC', 'Saccule', 'Utricle', 'Facial', 'Cochlear'};

figure
plot3(tract_post(1,:), tract_post(2,:), tract_post(3,:))
hold on
plot3(tract_lat(1,:), tract_lat(2,:), tract_lat(3,:))
plot3(tract_ant(1,:), tract_ant(2,:), tract_ant(3,:))
plot3(tract_sacc(1,:), tract_sacc(2,:), tract_sacc(3,:))
plot3(tract_utr(1,:), tract_utr(2,:), tract_utr(3,:))
plot3(tract_fac(1,:), tract_fac(2,:), tract_fac(3,:))
plot3(tract_coch(1,:), tract_coch(2,:), tract_coch(3,:))
legend(labels)
title('Chosen nerve tracts')
axis equal

%% Export vertices into txt file
save_dir = 'R:\Computational Modeling\Solved model data 20230113\';
writematrix(tract_post', [save_dir, 'tract_post.txt'], 'Delimiter', 'tab')
writematrix(tract_lat', [save_dir, 'tract_lat.txt'], 'Delimiter', 'tab')
writematrix(tract_ant', [save_dir, 'tract_ant.txt'], 'Delimiter', 'tab')
writematrix(tract_sacc', [save_dir, 'tract_sacc.txt'], 'Delimiter', 'tab')
writematrix(tract_utr', [save_dir, 'tract_utr.txt'], 'Delimiter', 'tab')
writematrix(tract_fac', [save_dir, 'tract_fac.txt'], 'Delimiter', 'tab')
writematrix(tract_coch', [save_dir, 'tract_coch.txt'], 'Delimiter', 'tab')