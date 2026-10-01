function grp_name = find_group_with_subgroup(groups, target_name)
    grp_name = '';
    for i = 1:numel(groups)
        g = groups(i);
        if isfield(g, 'Groups') && ~isempty(g.Groups)
            child_names = arrayfun(@(s) last_component(s.Name), g.Groups, 'UniformOutput', false);
            if any(strcmp(child_names, target_name))
                grp_name = g.Name;
                return;
            end
            grp_name = find_group_with_subgroup(g.Groups, target_name);
            if ~isempty(grp_name), return; end
        end
    end
end

function c = last_component(fullpath)
    parts = strsplit(fullpath, '/');
    c = parts{end};
end