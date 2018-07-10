E0 = 16.35;

% E = (-3:.25:2) + E0;
E = (-.1:.05:.8) + E0;
% E = (-.15:.05:.55) + E0;
% E = (-.75:.05:.1) + E0;
% E = (-.5:.1:.8) + E0;
pixels = 1:1401;
allRMS = zeros(num_images,rect_option);
stack=4;

for i=[1:26 28:33 35:78 80:91 93:100]
%%%%%%%%%%%%% RMS width
    for j=1:rect_option
        total=sum(squeeze(rlineout(stack,i,j,:)));
        peak=round(sum((squeeze(rlineout(stack,i,j,:))/total)'.*pixels));
        
        RMScounts=0;
        width=0;
        while (RMScounts/total) < .95 % use for 90% of signal
            width=width+2;
            subset=(peak-width/2):(peak+width/2);
            RMScounts=sum(squeeze(rlineout(stack,i,j,subset)));
        end
        total=RMScounts;
%         subset=pixels;
%         figure(1)
%         plot(pixels,squeeze(rlineout(stack,i,j,:)));
%         [xinput,~]=ginput(2);
%         subset=round(xinput(1)):round(xinput(2));
%         total=sum(squeeze(rlineout(stack,i,j,subset)));
        
        allRMS(i,j)=resolution*sqrt(sum((squeeze(rlineout(stack,i,j,subset))/total)'.*((subset-peak).^2)));
    end
    figure(1)
    scatter(E,allRMS(i,:))

%%%%%%%%%%%%% Double Gaussian
%     for j=1:rect_option
%         [allRMS(i,j,1),allRMS(i,j,2)]=rms2(pixels,squeeze(rlineout(stack,i,j,:)));
%     end
%     allRMS(i,:,:)=allRMS(i,:,:)*resolution;
%     figure(1)
%     scatter(E,allRMS(i,:,1))
%     hold on
%     scatter(E,allRMS(i,:,2))
%     hold off

%%%%%%%%%%%% Single Gaussian
%     for j=1:rect_option
%         allRMS(i,j)=resolution*rms(pixels,squeeze(rlineout(stack,i,j,:)));
%     end
%     figure(1)
%     scatter(E,allRMS(i,:))

%     axis([23.5 26 0 1000])
    xlabel('Energy (GeV)')
    ylabel('rms (\mum)')
    title(['Shot #' num2str(i)])
    pause(.2);
end