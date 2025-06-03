TurtleQuickLink = TurtleQuickLink or {}

local addonName = "TurtleQuickLink"
local addonTitle = "Turtle Quick Link"

local bindingName = "TURTLE_QUICK_LINK"
local defaultKey = "CTRL-C"

local currentUrl = ""

local function ShowCopyLinkFrame(url)
    TurtleCopyFrame:Show()
    TurtleCopyFrame_EditBox:SetText(url or "")
    TurtleCopyFrame_EditBox:HighlightText()
    TurtleCopyFrame_EditBox:SetFocus()
end

local function CreateUrl(dataSources)
    local url = TurtleQuickLink:GetTurtleDBUrl(dataSources)
    if url then
        ShowCopyLinkFrame(url)
    end
end

local function GetDataSources()
    local focus = GetMouseFocus()
    local tooltip = GameTooltip
    return {
        focus = focus,
        tooltip = tooltip
    }
end

function ShowTurtleDBLink()
    if not TurtleCopyFrame:IsVisible() then
        CreateUrl(GetDataSources())
    end
end

local function SetDefaultBindingKey()
    local key1, key2 = GetBindingKey(bindingName)
    local action = GetBindingAction(defaultKey)
    if key1 == nil and key2 == nil and action == "" then
        SetBinding(defaultKey, bindingName)
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
    setglobal("BINDING_HEADER_" .. bindingName, addonTitle)
    setglobal("BINDING_NAME_" .. bindingName, addonTitle .. " Key")

    SetDefaultBindingKey()

    this:UnregisterEvent("PLAYER_LOGIN")
end)
