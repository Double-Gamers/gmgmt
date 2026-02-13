local AddonName, OptionsPrivate = ...
-- Dependencies: AceAddon-3.0, AceComm-3.0, AceSerializer-3.0, LibDeflate
gmgmt = LibStub("AceAddon-3.0"):NewAddon("G.M.G.M.T", "AceComm-3.0","AceConsole-3.0", "AceEvent-3.0", "LibAboutPanel-2.0","AceBucket-3.0","AceTimer-3.0")
local WagoAnalytics = LibStub("WagoAnalytics"):Register("BNBeQxGx")
local LibSerialize = LibStub("AceSerializer-3.0")
local LibDeflate = LibStub("LibDeflate")
local openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0")
local db = LibStub("AceDB-3.0"):New("G.M.G.M.T", defaults, true)
local day, monthOffset

function gmgmt:OnInitialize()
    local options = {
        name = "G.M.G.M.T",
        type = "group",
        args = {}
    }
    
    -- Assuming `options` is your top-level options table and `self.db` is your database:
    options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(db)

    -- support for LibAboutPanel-2.0
    options.args.aboutTab = self:AboutOptionsTable("gmgmt")
    options.args.aboutTab.order = -1 -- -1 means "put it last"

    -- Register your options with AceConfigRegistry
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("gmgmt", "G.M.G.M.T")
    LibStub("AceConfig-3.0"):RegisterOptionsTable("gmgmt", options, {"gmgmt", "gm"})

    gmgmt:RegisterSharedMedia()

end

function gmgmt:DelayedImport()
    local aura2bimported = "!WA:2!TAv3UXTXvyVyTRqyDtTusDtCsJiuAuTsQeKTSSJmQs7YvRCu7UskCPKssfa9qodjNgsoJNz4kT6IEXIIgFJVrpc7DbWxTpc(jyGqqFa8JGUOx3ZqUY21w2bOOlWU7W5NZCoNVVVZH12DkP7YlSYclov2u4PWpC6NgWeyIWbf(DybJZVItk9OJqcSThJLQO8tqfQeMylUIYYLwI(BffjjQAJq5HW8BZO5QGMT20RL7OkB1KLYe)5A1QvxGclp1TDLkKqz5qZPkRGi4pzI1aLGghteYRnRy8W)5qmjOikYRpNi(YwT3E9DA7OGhCrfc0nhi5K00nWsRNklci9i5QUWUPhoYVzJUE(D9A465uaxsapf1NiCZrzePLB5wd(sckvL8SJUTGah1T72TA3(4I8XUG1Pqare5O0Dbxd8(hDSKKgvgN6jCWezOZnU5slpemJljUmP4KYq41DK0Jix1nRasBwoGRgEv9Ny5gMIKsZOafkfUwZWtcgNVRYv1RxF76lUWYbswHiKeqZ4mHYvgchOEqvwnzy1)TWXe(KDFqbsqSxVin1EVeQImuu6lMeNBSGvWhV9UGpDPNunUc5ERHkwyVQy79Q99jZqXhFVf6SG5R3OibKX6Qeif6DoTcIx3mLXWbDB62Q1MbHS8iAS1nlO4rozB(GE7UZbZDN0Jr50mKbWVT2AD9Ko5SCYtiiPXEK8yvYeNGby0SdFdOkKeWuy5aZEmxGEvNmenhoREv9xmH(pQ)t6gWWl)YZioCmlCOXa0kQ5iAEetu5bwJ5IBKd7Q(uHF6dN(uf5qvHGSNaX7WWe(72SDJoB7TLt7gn)lnwBTn82y3w6BzYj67O)C9fTCrP8eu9GmQqWej6lvt)Z0tOBw74aajXgR460U1MRPxum266pED9V1aX6zl)93v(71RycNb211VLjfjWm)4u2bjhddclKkwwIlqbYX87UHHegHcj73aJHOB)4S4m1(DiykAFz0H73JgQyI(Z3Jrdj45VXTxELpFLfY4lnamwPrUV(NBPVSL(x82ZQF7)LEYGQRq)U6F1GZWHPww)(6RP)a9hoQAv)ekeukAgbR94)qurEPe(6LkMFVng4fZzzdFOr2LZzV6Q2ZCVo3RJNFZD66Tvh)w7cvdMXwLqYl3P5Z8ZVJKyMYgjIlYGZjTbWcMHkRSZZ2QrP7tY7TqCM52SxT8sF2YccKMZTvIcs5CaoybF1VJvLQwYN6v9MZcodRdc43ZsFv9Vw)l1xr)BS4tAQs1J4vP)nG6JVGUd)6VriigGaC88PSyM(JEuGGPqksI(pa46UqQMliaXRK8AOS(orimXqGDEvYnSFT)Z3Q((WQGO0PTX2td8TBxhklkrkdMrsguExaMutF3r5Uh9TlT396lDr6vS0ZCTRQN8eOYKP(IPmqooiHqJtux0wVMLULL7buSk5I2pCEyvvknhklSJx7n2SfW3hHPstHtpGlpZNeoSkRzEIp3ZycvW)yy4LaRsK4s)JlBKj8p(fSMFLY0p0hfeii9OqK4NHoCsU95SlUVHao(PA8R8C)yhoCnae(uOReZi1d3ZeponGhlfvZQ)k(n(jfpjeaoeZV0klDRBz0m6UjVOy5FdiINEx9EgTIrCO3XiuEsZeKYUdrkrXKtX9HMl0W1gRKs0FJ(BbjZF))xsM)N1b6)Q(9hviH8BLNM8FZ317)4lW)GZnRxnac7p6rdoaQFAkvoyVXdCIy5k(vwxqpY(RkqytlcBpVkoN(nv47CVn5z32Qdmg20NAv9NQ)StKjim7GVUQaF9ZuuVGcb0o(JKPqDQaMYuqZ5vxFyzL7TlsLKxwGzwEq5XvmUErhtHB(mVEwygd7BeE3heqJDUVPY5(WlaTcoxA(4JcvbcPM(S1nItqkl(BatMg1hAASUhF6FcbssvZiOwqW2cwgxDUjYWXdcKWBWKhdvlk7ETzvJM7o6b3XTi9glTv35(o(N9691X0zFvcu6kHLI7pQkyF(RZneEDjcUuWbs8ww8zF9MlLeJc77hLYGgNt17h)6)d"
    local auraVersion = 1235
    if WeakAuras then
        if WeakAuras.IsLibsOK() then
            local list = gmgmt:listAuras()
            local found
            local status
            local msg
            for k,v in pairs(list) do
                if not (v.isChild or v.name == "VERSION") then
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
    gmgmt:QueryCalendar()
    --if C_AddOns.IsAddOnLoaded("WeakAuras") then
    --    self:ScheduleTimer("DelayedImport", 30)
    --else
    --    self:Print("|cFFFF0000WeakAuras ist nicht geladen, bitte aktivieren!")
    --end
    if not (C_AddOns.IsAddOnLoaded("BigWigs") or C_AddOns.IsAddOnLoaded("DBM")) then
        self:Print("|cFFFF0000BigWigs oder DBM sind nicht geladen, bitte aktivieren!")
    end
end

function gmgmt:Transmit(data, channel, target)
    local serialized = LibSerialize:Serialize(data)
    local compressed = LibDeflate:CompressDeflate(serialized)
    local encoded = LibDeflate:EncodeForWoWAddonChannel(compressed)
    self:SendCommMessage("G.M.G.M.T", encoded, channel, target)
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
    C_VoiceChat.SpeakText(voiceID, data, 1, 0, 100)
    if C_AddOns.IsAddOnLoaded("WeakAuras") then
        WeakAuras.ScanEvents("GMGMT_CUSTOM_EVENT", data)
    end
end

function gmgmt:QueryCalendar()
	C_Calendar.OpenCalendar();
	eventTypes = { C_Calendar.EventGetTypes() }
	local d  = C_DateAndTime.GetCurrentCalendarTime()
	C_Calendar.SetAbsMonth(d.month,d.year)
	monthOffset = 0
	numEvents = C_Calendar.GetNumDayEvents(monthOffset, d.monthDay)
	gmgmt:RespondTo_CalendarUpdatePendingInvites()
end

function gmgmt:RespondTo_CalendarUpdatePendingInvites()
	local d  = C_DateAndTime.GetCurrentCalendarTime()
    monthOffset = 0
	numEvents = C_Calendar.GetNumDayEvents(monthOffset, d.monthDay)
	if ( numEvents == 0 ) then return end
	numInvites = C_Calendar.GetNumPendingInvites()
	if ( numInvites > 0 ) then self:Print("|cFFFF0000Du musst noch auf ", numInvites, " Kalenderinvite(s) antworten!!!|r") end
end

gmgmt:RegisterChatCommand("gnotify", "gnotify")

function gmgmt:gnotify(input)
    gmgmt:Transmit(input,"GUILD",nil)
end

gmgmt:RegisterChatCommand("rnotify", "rnotify")

function gmgmt:rnotify(input)
    gmgmt:Transmit(input,"RAID", nil)
end

gmgmt:RegisterChatCommand("testnotify", "testnotify")

function gmgmt:testnotify(input)
    gmgmt:Transmit(input,"WHISPER",UnitName("player"))
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
