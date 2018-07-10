function datasaved=E200_save_remote(data,override)

if nargin<2
    override = false;
end
prefix=get_remoteprefix();
loc=strfind(data.VersionInfo.loadrequest,'nas/nas-li');
loadpath=[prefix '/' data.VersionInfo.loadrequest(loc:end)];
dataorig=E200_load_data(loadpath);
datanew=E200_merge(data,dataorig,override);
% datasaved=save_data(datanew,fullfile(getpref('FACET_data','prefix'),datanew.VersionInfo.originalpath,datanew.VersionInfo.originalfilename),false);

savepath=fullfile(prefix,datanew.VersionInfo.originalpath,datanew.VersionInfo.originalfilename);
datasaved=save_data(datanew,savepath,false);
end
