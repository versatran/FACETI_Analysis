%even odd code
            
        if do_sort && evenOdd
            [Y1,I1]=sort(sort_values_image_matched(i,:));   
            I1_odd=I1(mod(I1,2)==1);
            I1_even=I1(mod(I1,2)==0);
            
            vidObj_even=VideoWriter([videofilename '_even'],'MPEG-4');
            vidObj_odd=VideoWriter([videofilename '_odd'],'MPEG-4');
             
            vidObj_even.FrameRate=4;
            vidObj_even.Quality=100;
            vidObj_odd.FrameRate=4;
            vidObj_odd.Quality=100;    
            
            open(vidObj_even);
            open(vidObj_odd);
            
            writeVideo(vidObj_even,Emovie(I1_even));
            writeVideo(vidObj_odd,Emovie(I1_odd));

            close(vidObj_even);
            close(vidObj_odd);
        elseif evenOdd
            vidObj_even=VideoWriter([videofilename '_even'],'MPEG-4');
            vidObj_odd=VideoWriter([videofilename '_odd'],'MPEG-4');
             
            vidObj_even.FrameRate=4;
            vidObj_even.Quality=100;
            vidObj_odd.FrameRate=4;
            vidObj_odd.Quality=100;
        
            open(vidObj_even);
            open(vidObj_odd);
            
            even_nums=2:2:length(Emovie);
            odd_nums=1:2:length(Emovie);
            
            writeVideo(vidObj_even,Emovie(even_nums));
            writeVideo(vidObj_odd,Emovie(odd_nums));
%             writeVideo(vidObj,Emovie_even);
            % Close the file.
            close(vidObj_even);
            close(vidObj_odd);
        elseif do_sort
            %sort the sort_value matrix
            [Y1,I1]=sort(sort_values_image_matched(i,:));        
            %sort E-movie based on these numbers
            Emovie_unsorted=Emovie;
            Emovie=Emovie(I1);
            %range of shots in each stack
    %         range=(i-1)*num_images+1:(i)*num_images;            
