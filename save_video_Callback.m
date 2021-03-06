function save_video_Callback(~, ~, ~)
    Emovie = getappdata(0, 'Emovie');
    [file, path] = uiputfile('.MP4', 'Save Video', 'UntitledVideo.MP4');
    videofilename = strcat(path, file);
    vidObj2=VideoWriter(videofilename,'MPEG-4');

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