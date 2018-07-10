%comment repo
%This is where commented code from image_processing_common_matter ends up

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%BEGIN USER INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initialize flags
% set data path & set 

% source_dir='/Volumes/LaCie 1/FACET_data/2014/';
% source_dir='/Volumes/LaCie1/FACET_data/2014/';
% source_dir='/Volumes/LaCie1/FACET_data/2015/';
% source_dir='/';
% server_str='nas/nas-li20-pm00/';

% expt_str='E217';
% expt_str='E200';

% date_str='20150607';
% date_str='20150328';
% date_str='20150228';
% date_str='20150227';
% date_str='20140406';
% date_str='20140407';
% date_str='20140601';
% date_str='20140625';
% date_str='20140629';

% dataset_str='12283';
% dataset_str='12325';
% dataset_str='12366';
% dataset_str='12407';
% dataset_str='12487';
% dataset_str='12439';
% dataset_str='13113';
% dataset_str='13132';
% dataset_str='13128';
% dataset_str='13438';
% dataset_str='13449';
% dataset_str='13546';
% dataset_str='13537';
% dataset_str='13431';
% dataset_str='13438';
% dataset_str='15226';
% dataset_str='14600';
% dataset_str='18013';

% dataset_str=num2str(E200_vector(ii))

% purpose='test_linear';
% purpose='demo';
% purpose='lineouts';
% purpose='lineouts_contrast_1000_8000';
% purpose='he_select'
% purpose='unaff'

% purpose='lineouts';
% purpose=['lineouts_x_' num2str(box_region(1)) '_' num2str(box_region(end)) '_GeV_scale'];
% purpose=['lineouts_x_' num2str(box_region(1)) '_' num2str(box_region(end))];
% purpose=['lineouts_x_' num2str(box_region(1)) '_' num2str(box_region(end)) '_scale_force_fit'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%processtype properties
%for CMOS_FAR
% box_region=315:375;
% box_region=340:440; %June 25
% box_region=440:540; %June 29
% box_region=350:500; %June 29
% box_region=200:450; %12414 & 13450
% box_region=53:420; %14610
box_region=200:420; %14610
% box_region=200:500; %13123

%For Elanes:
% box_region=1:1392;
% box_region=600:1000; %box for 11330 finding 2GeV
% box_region=500:1200; %to catch the whole 
%box_region=1:200; %box for 11330 finding 2GeV
% box_region=1100:1392; %box for 11330 finding 0GeV
% box_region=700:900; %for 11357
% box_region=150:700; %for 11328 CELOSS
% box_region=720:760; %box for 11330 YAG

%FOR SYAG
% box_region=300:320; %14614 SYAG

%%%%%%%%%%%%%%
%Edit If processtype =2, otherwise ignore
% rect_option=-1 %means you are picking the ROI for each data
% rect_option=0 %means you don't want any ROI
%rect_oprion>1 means that you have a specific (number of) ROI in mind, 
%which you should introduce using the parameter "rectangles"
rect_option=2; %select rectangles
% rect_option=3; %select rectangles

rectangles=[200 800 160 350;
    1 1 745 1935] %unaffected 14614

% rectangles=[240 850 160 120;
%     1 1 745 1935] %unaffected 12382
%unaffected charge 12407 #50 used 10% peak noise 260
%for 12407
% rectangles=[315 735 160 365]
% rectangles=[270 735 245 365;
%     320 2200 60 359;
%     30 1 710 2558]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%Visualization properties
%see comment_repo_im_proc for other options.

%show image or run process in background
show_image=1;
%Which camera do you want to look at--> Set Dependent property below
% camera='E224_Probe';
% camera='CMOS_FAR'; 
% camera='CMOS_NEAR'; 
% camera='CMOS_ELAN'; 
% camera='CMOS_WLAN'; 
% camera='ELANEX'; 
% camera='SYAG'; 
% camera='PHOSPHOR';
% camera='CELOSS'; 


% axis_limits_image=[200 500 750 1200]; %for unaff in 12382
% axis_limits_image=[35 735 500 1400]; %for june 25
% axis_limits_image=[200 500 1000 2559]; 
% axis_limits_image=[100 500 1000 2559]; %12414
% axis_limits_image=[100 500 1 2559]; %12414 all frame
% axis_limits_image=[250 550 500 1600]; %for long oven sent to Mike
% axis_limits_image=[50 735 500 2558]; %12407 beam region


% axis_limits_lineout=[0 1e5 800 1344]; %laser off
% axis_limits_lineout=[0 2.5e8 800 1344]; %13123
% axis_limits_lineout=[0 4e6 800 1344]; %12407
% axis_limits_lineout=[0 4e6 800 1344]; %June 25


% curr_lim='auto'
% curr_lim=[0 1500];
% curr_lim=[0 2500]; %for linearized image
% curr_lim=[1100 3000];%for long oven sent to Mike
% curr_lim=[1000 8000];%June 25
% curr_lim=[1000 3000];%June 25 high contrast
% curr_lim=[1000 5000];%June 29 13532
% curr_lim=[160 420];%for unaffected charge in 12382

% plot_location1=[600,1,560,420];
% plot_location1=[360,278,560,420]; %on a mac
% plot_location1=[360   547   560   559] %for squished long oven sent to Mike
% plot_location2=[1,1,560,420];