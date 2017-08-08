% Determine if the host name of the current machine is 'facet-srv20'.
function bool = isfs20()
	[~, hostname] = unix('hostname');
	hostname = strrep(hostname, newline, '');
	bool = strcmp(hostname, 'facet-srv20');
end