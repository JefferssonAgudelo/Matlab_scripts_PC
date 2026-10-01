function grp = find_group_with_subgroup(groups, subgroup_name)
% FIND_GROUP_WITH_SUBGROUP  Recursively search an h5info() Groups array for
% the group that contains a subgroup named subgroup_name, and return its
% full HDF5 path.
%
%   info = h5info(fname);
%   g = find_group_with_subgroup(info.Groups, 'hx_fc');
%
% Returns '' if not found. This avoids assuming the per-step data group is
% info.Groups(1) -- the actual top-level structure can have more than one
% group, or nest an extra level, depending on the PSC writer/version, so
% we search for a group that actually HAS the dataset we need instead.

    grp = '';
    for i = 1:numel(groups)
        g = groups(i);
        if isfield(g, 'Groups') && ~isempty(g.Groups)
            names = {g.Groups.Name};
            base = cell(size(names));
            for k = 1:numel(names)
                parts = strsplit(names{k}, '/');
                base{k} = parts{end};
            end
            if any(strcmp(base, subgroup_name))
                grp = g.Name;
                return
            end
            sub = find_group_with_subgroup(g.Groups, subgroup_name);
            if ~isempty(sub)
                grp = sub;
                return
            end
        end
    end
end
