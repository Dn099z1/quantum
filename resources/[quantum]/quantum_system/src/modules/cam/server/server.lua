local vCLIENT = Tunnel.getInterface('Cam')

RegisterCommand('cam', function(source)
	local user_id = quantum.getUserId(source)
	if (user_id) and quantum.checkPermissions(user_id, { 'staff.permissao', 'cam.permissao' }) then
		exports.chat:DisableChat(source, false)
		Player(source).state.Cam = true
		vCLIENT.openCam(source)
	end
end)

RegisterNetEvent('quantum_cam:disableCam', function()
	local source = source
	Player(source).state.Cam = false
	exports.chat:DisableChat(source, true)
end)

