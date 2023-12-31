function plot_centerlines(centerlines,start_frames, end_frames)

    figure;

    plot(centerlines{start_frames}(:,1),centerlines{start_frames}(:,2),'Color','g','LineWidth',2);
    hold on;

    plot(centerlines{start_frames}(1,1),centerlines{start_frames}(1,2),'ro');

    for i = start_frames+1:end_frames-1
        plot(centerlines{i}(:,1),centerlines{i}(:,2),'Color',[0.7 0.7 0.7]);
    end

    plot(centerlines{end_frames}(:,1),centerlines{end_frames}(:,2),'Color','b','LineWidth',2);
   
    plot(centerlines{end_frames}(1,1),centerlines{end_frames}(1,2),'ro');


end

