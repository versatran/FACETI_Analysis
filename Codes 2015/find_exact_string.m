function returned_text = find_exact_string(stringcell, stringsearched)
match=[];

for i=1:length(stringcell)
    if findstr(stringcell{i}, stringsearched)>0
        match=[match i];
    end
end
%If more than one lineout structure is found, ask user which to use. Show
%the example image for each of them 
if isempty(match)
    error('no matches were found')
end 
if length(match)>1 
    error('this part is not written yet!')
end

returned_text = stringcell{match};