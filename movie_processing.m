function movie_processing
    Emovie(j)=getframe(50);

    if save_video
        if isunix
            if num_stacks>1
            % vidObj = VideoWriter([outputdir 'comparative even odd lineouts for ' data_name ' oddx' num2str(multiplier) '_' num2str(i)],'MPEG-4');
                videofilename=[outputFileName '_' num2str(i)];
            else
            % vidObj = VideoWriter([outputdir 'comparative even odd lineouts for ' data_name ' oddx' num2str(multiplier)],'Motion JPEG AVI');
            % vidObj2 = VideoWriter(outputFileName,'Motion JPEG AVI');
                videofilename=outputFileName;
            end
        vidObj2=VideoWriter(videofilename,'MPEG-4');
    elseif ispc
        if num_stacks>1
        % vidObj = VideoWriter([outputdir 'comparative even odd lineouts for ' data_name ' oddx' num2str(multiplier) '_' num2str(i)],'MPEG-4');
        vidObj2=VideoWriter([outputFileName '_' num2str(i)],'MPEG-4');
        else
            vidObj = VideoWriter([outputdir 'comparative even odd lineouts for ' data_name ' oddx' num2str(multiplier)],'MPEG-4');
            vidObj2=VideoWriter([outputFileName],'MPEG-4');
        end
   else
        error('Congragulations, you live in an era of new operating systems, rewrite directory line')
    end


%prone Emovie
    counter=0;
    for k=1:length(Emovie)
        if isempty(Emovie(k).cdata)
            continue
        end
    counter=counter+1;
    Emovie_clean(counter)=Emovie(k);
    end

    Emovie=Emovie_clean;
    vidObj2.FrameRate=4;
    vidObj2.Quality=100;
    open(vidObj2);
    writeVideo(vidObj2,Emovie)
    close(vidObj2);

end