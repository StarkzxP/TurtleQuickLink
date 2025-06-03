TurtleQuickLink = TurtleQuickLink or {}

local baseUrl = "%s?%s=%s"
local turtleDBBaseUrl = "https://database.turtle-wow.org/"

local strategies = {}
local turtletooltipStates = {}

function TurtleQuickLink:GetTurtleDBUrl(dataSources)
    for _, strategy in pairs(strategies) do
        local reference, type = strategy(dataSources)
        if reference and type then
            return string.format(baseUrl, turtleDBBaseUrl, type, reference)
        end
    end
end

local function GetTypeAndIdFromLink(link)
    if not link then
        return
    end
    local _, _, type, id = string.find(link, "%|?H?(%a+):(%d+):")
    return id, type
end

local function GetQuestLogTitleIndex(str)
    if type(str) ~= "string" then
        return nil
    end
    local prefix = "QuestLogTitle"
    local prefixLen = 13
    local numStr = string.sub(str, prefixLen + 1)
    if numStr and numStr ~= "" then
        local number = tonumber(numStr)
        return number
    end
    return nil
end

local function urlencode(url)
    local char_to_hex = function(c)
        return string.format("%%%02X", string.byte(c))
    end
    url = string.gsub(url, "\n", "\r\n")
    url = string.gsub(url, "([^%w ])", char_to_hex)
    url = string.gsub(url, " ", "+")
    return url
end

function strategies.GetItemFromTooltip(data)
    if not data.tooltip then
        return nil
    end
    return GetTypeAndIdFromLink(data.tooltip.itemLink)
end

function strategies.GetItemFromItemRef(data)
    if data.focus and data.focus.itemID then
        return data.focus.itemID, "item"
    end
    return nil
end

function strategies.GetQuestTitleFromQuestLog(data)
    if not data.focus then
        return nil
    end
    local questIndex = GetQuestLogTitleIndex(data.focus:GetName())
    if not questIndex then
        return nil
    end
    local questTitle, _, _, isHeader = GetQuestLogTitle(questIndex)
    if not questTitle or isHeader then
        return nil
    end
    return urlencode(questTitle), "search"
end

function strategies.GetQuestFromPfQuestTracker(data)
    if data.focus and data.focus.questid then
        return data.focus.questid, "quest"
    end
    return nil
end
