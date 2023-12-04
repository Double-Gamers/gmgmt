-- Dependencies: AceAddon-3.0, AceComm-3.0, LibSerialize, LibDeflate
gmgmt = LibStub("AceAddon-3.0"):NewAddon("G.M.G.M.T", "AceComm-3.0")
local LibSerialize = LibStub("LibSerialize")
local LibDeflate = LibStub("LibDeflate")

function gmgmt:OnEnable()
    self:RegisterComm("G.M.G.M.T")
    gmgmt:Transmit("test")
end

-- With compression (recommended):
function gmgmt:Transmit(data)
    local serialized = LibSerialize:Serialize(data)
    local compressed = LibDeflate:CompressDeflate(serialized)
    local encoded = LibDeflate:EncodeForWoWAddonChannel(compressed)
    self:SendCommMessage("G.M.G.M.T", encoded, "WHISPER", UnitName("player"))
end

function gmgmt:OnCommReceived(prefix, payload, distribution, sender)
    local decoded = LibDeflate:DecodeForWoWAddonChannel(payload)
    if not decoded then return end
    local decompressed = LibDeflate:DecompressDeflate(decoded)
    if not decompressed then return end
    local success, data = LibSerialize:Deserialize(decompressed)
    if not success then return end

    -- Handle `data`
    print(data)
end