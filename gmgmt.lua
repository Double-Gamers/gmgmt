-- Dependencies: AceAddon-3.0, AceComm-3.0, AceSerializer-3.0, LibDeflate
gmgmt = LibStub("AceAddon-3.0"):NewAddon("G.M.G.M.T", "AceComm-3.0","AceConsole-3.0", "AceEvent-3.0", "LibAboutPanel-2.0","AceBucket-3.0")
local WagoAnalytics = LibStub("WagoAnalytics"):Register("BNBeQxGx")
local LibSerialize = LibStub("AceSerializer-3.0")
local LibDeflate = LibStub("LibDeflate")
local day, monthOffset

-- declare defaults to be used in the DB
local defaults = {
    profile = {
    setting = true,
    }
}

function gmgmt:OnInitialize()
    local options = {
        name = "G.M.G.M.T",
        type = "group",
        args = {}
    }
    
    -- Assuming `options` is your top-level options table and `self.db` is your database:
    self.db = LibStub("AceDB-3.0"):New("gmgmtDB", defaults, true)
    options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

    -- support for LibAboutPanel-2.0
    options.args.aboutTab = self:AboutOptionsTable("gmgmt")
    options.args.aboutTab.order = -1 -- -1 means "put it last"

    -- Register your options with AceConfigRegistry
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("gmgmt", "G.M.G.M.T")
    LibStub("AceConfig-3.0"):RegisterOptionsTable("gmgmt", options, {"gmgmt", "gm"})

    gmgmt:RegisterSharedMedia()

end

function gmgmt:DelayedImport()
    local aura2bimported = "!WA:2!fw12UTTrt4iOMAew3uB1w3u30gcNg)hJMiKehhNEqT1urkXfw2Uu02PagGDj3LIBdj3n7U0XYxku83CtUXpc6Uc0R0JqEcgy0NG8iKl61Dxsz3dXbvaIC4WzNdFFZmSY21KUlv)U1xUwAnCn8tV0lcycmr4GcFewW48PCsOhCasGT9ySefLl2FJOijrvr0FSWiuwymtSjJMPcA2ADVwUJk9stwct8DvQuPQafQOSm5DCLkKqz5qZOkRGi9nzS1aLG2RhriNDEXyX))qmjipkYRpNiEqR12S9wR5O0p4IYfOBnqYjjjRILwVqMhq2JKP6QTMU)i)MR01ZVR3kUEo56GeWtq9jItmBtbrBMB3nBT2AUfAcEabLOIDZqPeP1H5zJtbRxQliIidLSTo10z)ZoussIkQtychmrg6CZBT4sd1U2L0ZuEwojmeUTJKEazg30CnGz5Ot1WzGRy5gMGKsJuGcLOdSr8OGXiDjwvTA1nREJ6lfiz5IqsanLZekxzO(avdkr14HL3BH7r4t39X5ibXUDEsI9oXufzOOixmaNBpblNp28U6C6SpVuUK5o3qflCVYA7cv(L45O4dVF9o1n)9gfj04rxLaPqvFzjf32OY44GUnDB1A9X08QzANv9iuUsBZg8cI2kiKLfr7zDikJMIm6Udy1gM2jJLrEobjn(MK1tfpXrynLASW3qWcjrFuSCGXgtWGgoPiAM(Sqd4RNa(g4BHv0It(V1m0CoAz4hrZIyIYaBDRCkEKt66pEVT36jlSCsTWzF610qJkHMPbJT8wB11BbVrLryQ00U4r2xn3vchgMlvSuZt8fIYZkAHV6cw26FcIkxKzBAg9jz7vVxkwduwKm8rYyeM9KFOeJV4zG3eMGF5)MN9ltm)qFuqGGShfPi(PO9NMBFkwX9v0uY4NQWN6VYPT46qsGzFHg4zMknChkwf7SI(r4CA0EExDxugMFZvn9XrOqYURGXA0z3EP9sv72HGPODLr7VBmbP5XRV4NV4TVD9u(IdWm)IZgdVLfmPf82NFE48)bmDqz4hvEZpMIjUM8ddVh8(LdysET735(D88BUvxVn643AB9kHbhtX1wcM95nJrk7oePe1JaZaFaCb4dHT4)6jyCHJUMTbslHBAKDHo7gnSN7vD)C2QyswHLMFx)6Bjjgv2irV8utszRbqTgQS0pNy6)IaTBue0tE9yAwjYjf608RHJH316yiW0YcZokxQ5WYkkgUO1lX91RtOH3BCzhdVdmf8Xw8Pnlc3J4vUIPddt(TZW)OtL3lfGD4Z)6Blsi9qH99Jsymrm8vAsFBnjXfeDRxXqIz0qpHeosMO5QaMsNZGJ2ii8F8(HOeEmAZ8ejbM8vF9GIJRyCNiwMIpvBb9a7VphHnRhS98G5MDgy6J0Bcn7ZmRD0G0LBdFQzhhmFX1)xX1RAUEQvS84kUXatqm7RAmEy6HLdtvHB4O0Na(cRbprV6zhbIpyNXcqtl4Svo1jTXGLgwcPMLDvHp5zWLcC2Wt3bbFPf)s)hJNXWThVGmytblLRCdpEDDv4ovHLH7EQLu4jLe0A0Jx2np5MlUr3fEK4N0np0O(oR1QTh)ZE9P842iFvSMsJzj4(JkrK)6tRd1FoJGlg9)5jH7zXN717Uug2xZyKFS2E)(d)Z)"
    local auraVersion = 1235
    if WeakAuras then
        if WeakAuras.IsLibsOK() then
            local list = gmgmt:listAuras()
            local found
            local status
            local msg
            for k,v in pairs(list) do
                if not (v.isChild or v.name == "VERSION") then
                    --self:Print(v.name)
                    --self:Print(v.data.uid)
                    if v.name == "G.M.G.M.T" then
                        found = v.data
                    end
                end
            end
            if not found then                
                status, msg = WeakAuras.Import(aura2bimported)
            else
                if tonumber(found.desc) < auraVersion then
                    status, msg = WeakAuras.Import(aura2bimported,found.uid)
                end
            end
            if not status and msg then
                self:Print(msg)
            end
        end
    end
end

local function sortByName(a,b)
    if a and b and a.name and b.name then
        return a.name < b.name
    end
end

function gmgmt:listAuras()
    local auras,auras2 = {},{}
    for WA_name,WA_data in pairs(WeakAurasSaved.displays) do
        local aura = auras2[WA_name]
        if aura then
            aura.name = WA_name
            aura.data = WA_data
        else
            aura = {
                name = WA_name,
                data = WA_data,
            }
        end
        if not Filter or WA_name:lower():find(Filter) then
            local parent = WA_data.parent
            if parent then
                local a = auras2[parent] or {}
                auras2[parent] = a
                a[#a+1] = aura
            else
                auras[#auras+1] = aura
            end
        end
        auras2[WA_name] = aura
    end
    if Filter then
        local inList = {}
        for i=1,#auras do
            inList[ auras[i] ] = true
        end
        for k,v in pairs(auras2) do
            if #v > 0 and not inList[v] and v.name then
                auras[#auras+1] = v
            end
        end
    end
    sort(auras,sortByName)
    for i=1,#auras do
        sort(auras[i],sortByName)
    end
    local sortedTable = {}
    if not Filter then
        sortedTable[#sortedTable+1] = {name="VERSION"}
    end
    for i=1,#auras do
        sortedTable[#sortedTable+1] = auras[i]
        for j=1,#auras[i] do
            sortedTable[#sortedTable+1] = auras[i][j]
            auras[i][j].isChild = true
        end
    end
    return sortedTable
end

function gmgmt:OnEnable()
    self:RegisterComm("G.M.G.M.T")
    self:RegisterBucketEvent("CALENDAR_UPDATE_PENDING_INVITES",1 ,"RespondTo_CalendarUpdatePendingInvites")
    --self:RegisterEvent("CALENDAR_UPDATE_EVENT_LIST","RespondTo_CalendarUpdatePendingInvites")
    --if ( not IsAddOnLoaded("Blizzard_Calendar") ) then UIParentLoadAddOn("Blizzard_Calendar") end
    gmgmt:QueryCalendar()
    if IsAddOnLoaded("WeakAuras") then
        self:ScheduleTimer("DelayedImport", 30)
    else
        self:Print("|cFFFF0000WeakAuras ist nicht geladen, bitte aktivieren!")
    end
    if not (IsAddOnLoaded("BigWigs") or IsAddOnLoaded("DBM")) then
        self:Print("|cFFFF0000BigWigs oder DBM sind nicht geladen, bitte aktivieren!")
    end
end

function gmgmt:Transmit(data, channel)
    local serialized = LibSerialize:Serialize(data)
    local compressed = LibDeflate:CompressDeflate(serialized)
    local encoded = LibDeflate:EncodeForWoWAddonChannel(compressed)
    self:SendCommMessage("G.M.G.M.T", encoded, channel)
end

function gmgmt:OnCommReceived(prefix, payload, distribution, sender)
    local decoded = LibDeflate:DecodeForWoWAddonChannel(payload)
    if not decoded then return end
    local decompressed = LibDeflate:DecompressDeflate(decoded)
    if not decompressed then return end
    local success, data = LibSerialize:Deserialize(decompressed)
    if not success then return end

    -- Handle `data`
    WagoAnalytics:IncrementCounter("triggered")
    self:Print(data)
    local voiceID = C_TTSSettings.GetVoiceOptionID(0)
    PlaySoundFile("Interface\\Addons\\gmgmt\\Media\\sfx\\announcement-sound-5-21465.mp3", "SFX")
    C_VoiceChat.SpeakText(voiceID, data, Enum.VoiceTtsDestination.LocalPlayback, 0, 100)
    if IsAddOnLoaded("WeakAuras") then
        WeakAuras.ScanEvents("GMGMT_CUSTOM_EVENT", data)
    end
end

function gmgmt:QueryCalendar()

	--self:Print("Querying Calendar")

	C_Calendar.OpenCalendar();

	--self:Print("Generating list of months and weekdays and event types")
	eventTypes = { C_Calendar.EventGetTypes() }

	local d  = C_DateAndTime.GetCurrentCalendarTime()
	--self:Print("CalendarGetDate returned: ", d.weekday,"(",CALENDAR_WEEKDAY_NAMES[d.weekday],")", d.monthDay, d.month, d.year)
	--self:Print("Setting calendar to month/year : ", d.month, d.year)
	C_Calendar.SetAbsMonth(d.month,d.year)
	monthOffset = 0
	--self:Print("Getting Number of events for day/monthoffset : ", d.monthDay,monthOffset)
	numEvents = C_Calendar.GetNumDayEvents(monthOffset, d.monthDay)
	--self:Print("Number of events/monthOffset = ", numEvents, monthOffset)

	gmgmt:RespondTo_CalendarUpdatePendingInvites()
end

function gmgmt:RespondTo_CalendarUpdatePendingInvites()

	local d  = C_DateAndTime.GetCurrentCalendarTime()
    monthOffset = 0
	--self:Print("Getting Number of events for day/monthoffset : ", d.monthDay,monthOffset)
	numEvents = C_Calendar.GetNumDayEvents(monthOffset, d.monthDay)
	--self:Print("Number of events/monthOffset = ", numEvents, monthOffset)
	if ( numEvents == 0 ) then return end
	
	--self:Print("Laufende Ereignisse : ");
	for index = 1,numEvents do
		--title, hour, minute, calendarType, sequenceType, eventType, texture, modStatus, inviteStatus, invitedBy, difficulty, inviteType = C_Calendar.GetDayEvent(monthOffset, d.monthDay, index)
        --currEvent = C_Calendar.GetDayEvent(monthOffset, d.monthDay, index)
		--self:Print("Title:", currEvent.title, "Start:", currEvent.startTime.hour..":"..currEvent.startTime.minute, "Calendar Type:", currEvent.calendarType, "Sequence Type:",currEvent.sequenceType, "Event Type:", currEvent.eventType, "Invite Status:", currEvent.inviteStatus, "Invited By:", currEvent.invitedBy, "Difficulty:", currEvent.difficulty, "Invite Type:", currEvent.inviteType);
        --self:Print("+", currEvent.title);
		--if ( currEvent.calendarType == GUILD_EVENT or currEvent.calendarType == GUILD_ANNOUNCEMENT or currEvent.calendarType == PLAYER ) then
			--self:Print("This is a guild event or announcement or a player created event")
			--if ( currEvent.inviteStatus == 1 or currEvent.inviteStatus == 8 or currEvent.inviteStatus == 5 ) then		
				--self:Print("You have been invited or have not signed up or the invite is out");
			--end
		--end
	end

    --self:Print("Getting Number of Pending Invites")
	numInvites = C_Calendar.GetNumPendingInvites()
	if ( numInvites > 0 ) then self:Print("|cFFFF0000Du musst noch auf ", numInvites, " Kalenderinvite(s) antworten!!!|r") end
end

gmgmt:RegisterChatCommand("gnotify", "gnotify")

function gmgmt:gnotify(input)
    gmgmt:Transmit(input,"GUILD")
end

gmgmt:RegisterChatCommand("rnotify", "rnotify")

function gmgmt:rnotify(input)
    gmgmt:Transmit(input,"RAID")
end

function gmgmt:RegisterSharedMedia()
    local LSM = LibStub("LibSharedMedia-3.0")
    local SOUND = LSM.MediaType.SOUND
    local BG = LSM.MediaType.BACKGROUND
    LSM:Register(SOUND, "G.M.G.M.T: announcement-sound-2", [[Interface\Addons\gmgmt\Media\sfx\announcement-sound-2-21462.mp3]])
    LSM:Register(SOUND, "G.M.G.M.T: announcement-sound-3", [[Interface\Addons\gmgmt\Media\sfx\announcement-sound-3-21463.mp3]])
    LSM:Register(SOUND, "G.M.G.M.T: announcement-sound-5", [[Interface\Addons\gmgmt\Media\sfx\announcement-sound-5-21465.mp3]])
    LSM:Register(SOUND, "G.M.G.M.T: bingbong", [[Interface\Addons\gmgmt\Media\sfx\bingbong-42645.mp3]])
    LSM:Register(SOUND, "G.M.G.M.T: brace-yourself", [[Interface\Addons\gmgmt\Media\sfx\brace-yourself-for-impact-locutora-virtual-140333.mp3]])
    LSM:Register(SOUND, "G.M.G.M.T: call-to-attention", [[Interface\Addons\gmgmt\Media\sfx\call-to-attention-123107.mp3]])
    LSM:Register(SOUND, "G.M.G.M.T: did-you-see-that", [[Interface\Addons\gmgmt\Media\sfx\did-you-see-that-89154.mp3]])
    LSM:Register(SOUND, "G.M.G.M.T: go2", [[Interface\Addons\gmgmt\Media\sfx\go2-88814.mp3]])
    LSM:Register(SOUND, "G.M.G.M.T: header", [[Interface\Addons\gmgmt\Media\sfx\header-39344.mp3]])
    LSM:Register(SOUND, "G.M.G.M.T: infobleep", [[Interface\Addons\gmgmt\Media\sfx\infobleep-87963.mp3]])
    LSM:Register(SOUND, "G.M.G.M.T: positive-notification", [[Interface\Addons\gmgmt\Media\sfx\positive-notification-new-level-152480.mp3]])
    LSM:Register(SOUND, "G.M.G.M.T: quotcancelledquot", [[Interface\Addons\gmgmt\Media\sfx\quotcancelledquot-175693.mp3]])
    LSM:Register(SOUND, "G.M.G.M.T: ready-set-go", [[Interface\Addons\gmgmt\Media\sfx\ready-set-go-83272.mp3]])
    LSM:Register(SOUND, "G.M.G.M.T: sevendayslater", [[Interface\Addons\gmgmt\Media\sfx\sevendayslater-82332.mp3]])
    LSM:Register(SOUND, "G.M.G.M.T: short-success-sound", [[Interface\Addons\gmgmt\Media\sfx\short-success-sound-glockenspiel-treasure-video-game-6346.mp3]])
    LSM:Register(SOUND, "G.M.G.M.T: tannoy-announcement", [[Interface\Addons\gmgmt\Media\sfx\tannoy-announcement-jingle-94124.mp3]])
    LSM:Register(SOUND, "G.M.G.M.T: victory-voiced", [[Interface\Addons\gmgmt\Media\sfx\victory-voiced-165989.mp3]])
    LSM:Register(BG, "G.M.G.M.T: Logo", [[Interface\Addons\gmgmt\Media\gfx\dg-logo.tga]])
end