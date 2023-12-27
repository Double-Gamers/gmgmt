-- Dependencies: AceAddon-3.0, AceComm-3.0, AceSerializer-3.0, LibDeflate
gmgmt = LibStub("AceAddon-3.0"):NewAddon("G.M.G.M.T", "AceComm-3.0","AceConsole-3.0", "AceEvent-3.0", "LibAboutPanel-2.0","AceBucket-3.0")
local WagoAnalytics = LibStub("WagoAnalytics"):Register("BNBeQxGx")
local LibSerialize = LibStub("AceSerializer-3.0")
local LibDeflate = LibStub("LibDeflate")
local day, monthOffset

function gmgmt:OnInitialize()
    local options = {
        name = "G.M.G.M.T",
        type = "group",
        args = {}
    }
    
    -- support for LibAboutPanel-2.0
    options.args.aboutTab = self:AboutOptionsTable("gmgmt")
    options.args.aboutTab.order = -1 -- -1 means "put it last"

    -- Register your options with AceConfigRegistry
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("gmgmt", "G.M.G.M.T")
    LibStub("AceConfig-3.0"):RegisterOptionsTable("gmgmt", options, {"gmgmt", "gm"})
end

function gmgmt:OnEnable()
    self:RegisterComm("G.M.G.M.T")
    self:RegisterBucketEvent("CALENDAR_UPDATE_PENDING_INVITES",1 ,"RespondTo_CalendarUpdatePendingInvites")
    --self:RegisterEvent("CALENDAR_UPDATE_EVENT_LIST","RespondTo_CalendarUpdatePendingInvites")
    --if ( not IsAddOnLoaded("Blizzard_Calendar") ) then UIParentLoadAddOn("Blizzard_Calendar") end
    gmgmt:QueryCalendar()
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
    C_VoiceChat.SpeakText(voiceID, data, Enum.VoiceTtsDestination.LocalPlayback, 0, 100)
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