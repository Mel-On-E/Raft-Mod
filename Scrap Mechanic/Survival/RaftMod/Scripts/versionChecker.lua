local VERSION = 1.11 -- UPDATE version.json ASWELL!!!!!!
g_checkForUpdates = true -- delcare to check for updates

function checkRaftVersion()
	g_checkForUpdates = false -- set it here incase it errors out.
    
    local success, data = pcall(sm.json.open, '$CONTENT_3df6725e-462a-47e3-92ed-e5b66883588c/verison.json' )

	if not success then return end -- If the file doesn't exist, don't bother checking the version

	local modVersion = data.version
	local needsUpdate = modVersion ~= nil and VERSION < modVersion -- compare using (float) numbers
	
	if needsUpdate then
		sm.gui.chatMessage("[Raft Mechanic] Your on version " .. tostring(VERSION) .. " and version " .. tostring(modVersion) .. " is available, please update!" )
	end

    sm.log.info("[Raft Mechanic] You are on version: " .. tostring(VERSION) .. " and version.json is: " .. tostring(modVersion) )
end
