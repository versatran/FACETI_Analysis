%simple dataload
%For example the E217 data taken on date 20150607 with the identifier of 
%E217_18013 is loaded thus:
%data=simple_data_load('E217','20150607','18013')
function data=simple_data_load(expt_str,date_str,dataset_str)
% set path to data
% source_dir='/Volumes/LaCie 1/FACET_data/2014/';
% source_dir='/Volumes/LaCie1/FACET_data/2015/';
source_dir=['/Volumes/LaCie/FACET_data/' date_str(1:4) '/'];

% This preference is a sticky preference and identifies the location of the 
% nas folder
setpref('FACET_data','prefix',source_dir) 
% source_dir='/';
server_str='nas/nas-li20-pm00/';

% if nargin<2
%     date_str='20150228';
%     dataset_str='14614';
%     warning('default dataset
% end

%set to zero only if /nas is in the pwd
remote=1;

save_override=0;
%this parameter is necessary if there is a floor of noise that needs to be
%subtracted
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%END USER INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Load dataset
% data_path=[source_dir server_str expt_str '/' date_str(1:4) '/' date_str '/' ...
%     expt_str '_' dataset_str '/' expt_str '_' dataset_str '.mat'];
data_path=[server_str expt_str '/' date_str(1:4) '/' date_str '/' ...
    expt_str '_' dataset_str '/' expt_str '_' dataset_str '.mat'];

% load data
data=E200_load_data(data_path,expt_str);
