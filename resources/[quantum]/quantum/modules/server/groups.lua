local groups = {}
AddEventHandler('onResourceStart', function(resourceName)
  	if ('quantum_setGroups' == resourceName) then 
		groups = exports.quantum_setGroups:GetGroups()
		print('^5[quantum Groups]^7 Grupos criados!')
	end
end)

local users = config.users
------------------------------------------------------------------
-- GET GROUPS
------------------------------------------------------------------
quantum.getGroups = function()
	return groups
end
------------------------------------------------------------------

------------------------------------------------------------------
-- GET GROUP TITLE
------------------------------------------------------------------
quantum.getGroupTitle = function(group, grade)
	local _groups = groups[group]
	if (_groups) and _groups['information'] then
		if (grade) then
			if (_groups['information']['grades']) and _groups['information']['grades'][grade] then
				return (_groups['information']['grades'][grade]['title'] or group)
			end
		end
		if (_groups['information']['title']) then
			return (_groups['information']['title'] or group)
		end
	end
	return group
end
------------------------------------------------------------------

------------------------------------------------------------------
-- GET GROUP TYPE
------------------------------------------------------------------
quantum.getGroupType = function(group)
	local _groups = groups[group]
	if (_groups) and _groups['information'] then
		return _groups['information']['groupType']
	end
end
------------------------------------------------------------------

------------------------------------------------------------------
-- IS GROUP WITH GRADES
------------------------------------------------------------------
quantum.isGroupWithGrades = function(group, retGrades)
	local _groups = groups[group]
	if (_group) and _groups['information'] then	
		if (_groups['information']['grades']) then
			if retGrades then
				return _groups['information']['grades'], _groups['information']['grades_default']
			end
			return true
		end
	end
	return false
end
------------------------------------------------------------------

------------------------------------------------------------------
-- GET USER GROUPS
------------------------------------------------------------------
quantum.getUserGroups = function(user_id)
	local rows = quantum.query('quantum/get_user_groups', { user_id = user_id })
	local cb = {}
	for _,row in ipairs(rows) do
		cb[row.groupId] = { grade = row.gradeId, active = (row.active == 1) }
	end
	return cb
end
------------------------------------------------------------------

------------------------------------------------------------------
-- HAS GROUP
------------------------------------------------------------------
quantum.hasGroup = function(user_id, group)
	local grade = quantum.scalar('quantum/get_user_group_grade', { user_id = user_id, groupId = group })
	return (grade ~= nil), grade
end
------------------------------------------------------------------

------------------------------------------------------------------
-- GET USER GROUP BY TYPE
------------------------------------------------------------------
quantum.getUserGroupByType = function(user_id, gtype)
	local user_groups = quantum.getUserGroups(user_id)
	for index, value in pairs(user_groups) do
		local _groups = groups[index]
		if (_groups) then
			if (_groups.information and _groups.information.groupType and _groups.information.groupType == gtype) then
				return index, value
			end
		end
	end
end
------------------------------------------------------------------

------------------------------------------------------------------
-- HAS GROUP ACTIVE AND SET
------------------------------------------------------------------
quantum.hasGroupActive = function(user_id, group)
	local active = quantum.scalar('quantum/get_user_group_active', { user_id = user_id, groupId = group })
	return (active == 1)
end

quantum.setGroupActive = function(user_id, group, active)
	local affected = quantum.execute('quantum/updt_user_active', { user_id = user_id, groupId = group, active = (active == true) })
	return (affected > 0)
end
------------------------------------------------------------------

------------------------------------------------------------------
-- ADD USER GROUP
------------------------------------------------------------------
quantum.addUserGroup = function(user_id, group, grade)
	local hasGroup, hasGrade = quantum.hasGroup(user_id, group)
	if (not hasGroup) then
		local ngroup = groups[group]
		if ngroup then
			if (not grade) then
				grade = (ngroup.information.grades_default or group)
			end

			local affected = quantum.execute('quantum/add_user_group',{ user_id = user_id, groupId = group, gradeId = grade })
			if affected > 0 then
				if (ngroup['information']) and ngroup['information']['groupType'] ~= nil then
					local user_groups = quantum.getUserGroups(user_id)
					for index, value in pairs(user_groups) do
						if (index ~= group) then
							local _groups = groups[index]
							if (_groups) and _groups['information'] then
								if (_groups['information']['groupType'] == ngroup['information']['groupType']) then
									quantum.removeUserGroup(user_id, index)
								end
							end
						end
					end
				end
				TriggerEvent('quantum:playerJoinGroup', user_id, group, (ngroup['information']['groupType'] or ''))
				return true
			end
		end	
	else
		if grade then
			if (hasGrade ~= grade) then
				quantum.execute('quantum/updt_user_group', { user_id = user_id, groupId = group, gradeId = grade })
				return true
			end
		end
	end
end
vRP.addUserGroup = quantum.addUserGroup
------------------------------------------------------------------

------------------------------------------------------------------
-- REMOVE USER GROUP
------------------------------------------------------------------
quantum.removeUserGroup = function(user_id, group)
	local affected = quantum.execute('quantum/rem_user_group',{ user_id = user_id, groupId = group })
	if affected > 0 then
		TriggerEvent('quantum:playerLeaveGroup', user_id, group, (groups[group]['information']['groupType'] or ''))
		return true
	end
end
vRP.removeUserGroup = quantum.removeUserGroup
------------------------------------------------------------------

------------------------------------------------------------------
-- HAS PERMISSION
------------------------------------------------------------------
-- quantum.hasPermission(user_id,'+Policia.Sargento') | Cargo Igual ou Maior que Sargento
-- quantum.hasPermission(user_id,'@Policia.Sargento') | Cargo identico a Sargento
quantum.hasPermission = function(user_id, perm)
	local fchar = string.sub(perm, 1, 1)
	if fchar == '+' then
		local _perm = string.sub(perm,2,string.len(perm))
		local parts = splitString(_perm,'.')
		if #parts == 2 then
			local paramGroup = parts[1]
			local paramGrade = parts[2]
			local groupConfig = groups[paramGroup]
			if groupConfig and groupConfig['information'] and groupConfig['information']['grades'] then
				local targetLevel = groupConfig['information']['grades'][paramGrade]['level']
				local inGroup, inGrade = quantum.hasGroup(user_id, paramGroup)
				if inGroup then
					local currLevel = groupConfig['information']['grades'][inGrade]['level']
					return currLevel >= targetLevel
				end
			end
		end
	elseif fchar == '@' then
		local _perm = string.sub(perm, 2, string.len(perm))
		local parts = splitString(_perm, '.')
		if #parts == 2 then
			local paramGroup = parts[1]
			local paramGrade = parts[2]
			local groupConfig = groups[paramGroup]
			if groupConfig then
				local inGroup, inGrade = quantum.hasGroup(user_id, paramGroup)
				if inGroup and inGrade == paramGrade then
					return quantum.hasGroupActive(user_id, paramGroup)
				end
			end
		end
	else
		local user_groups = quantum.getUserGroups(user_id)
		for k, value in pairs(user_groups) do
			if (value) then
				local _groups = groups[k]
				if (_groups) then
					for index, values in pairs(_groups) do
						if index ~= 'information' and values == perm and value['active'] then
							return true
						end
					end
				end
			end
		end
	end
	return false
end
vRP.hasPermission = quantum.hasPermission
------------------------------------------------------------------

------------------------------------------------------------------
-- GET USERS BY PERMISSION
------------------------------------------------------------------
quantum.getUsersByPermission = function(perm)
	local users = {}
	for index, _ in pairs(cacheUsers['rusers']) do
		if quantum.hasPermission(tonumber(index), perm) then
			table.insert(users, tonumber(index))
		end
	end
	return users
end
vRP.getUsersByPermission = quantum.getUsersByPermission
------------------------------------------------------------------

------------------------------------------------------------------
-- CHECKPERMISSIONS
------------------------------------------------------------------
quantum.checkPermissions = function(user_id, permission)
    if (permission) then
        if (type(permission) == 'table') then
            for _, perm in pairs (permission) do
                if (quantum.hasPermission(user_id, perm)) then
                    return true
                end
            end
            return false
        end
        return quantum.hasPermission(user_id, permission)
    end
    return true
end
------------------------------------------------------------------

AddEventHandler('quantum:playerSpawn', function(user_id, source, first_spawn)
	if (first_spawn) then
		local _user = users[user_id]
		if _user then
			for group, grade in pairs(_user) do
				quantum.addUserGroup(user_id, group, grade)
			end
		end
	end
end)