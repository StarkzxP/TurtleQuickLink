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

function ExtractNumberBeforeColon(inputString)
    if not inputString then
        return nil
    end
    local colonPos = string.find(inputString, ":", 1, true)
    if colonPos and colonPos > 1 then
        local numberStr = string.sub(inputString, 1, colonPos - 1)
        return tonumber(numberStr)
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

function strategies.GetItemLinkFromTooltip(data)
    if not data.tooltip or not data.tooltip.itemLink then
        return nil
    end
    return GetTypeAndIdFromLink(data.tooltip.itemLink)
end

function strategies.GetItemIdFromTooltip(data)
    if not data.tooltip or not data.tooltip.itemID then
        return nil
    end
    return data.tooltip.itemID, "item"
end

function strategies.GetItemIdFromAux(data)
    if not data.focus or not data.focus.expandKey then
        return nil
    end
    return ExtractNumberBeforeColon(data.focus.expandKey), "item"
end

function strategies.GetItemFromItemRef(data)
    if not data.focus or not data.focus.itemID then
        return nil
    end
    return data.focus.itemID, "item"
end

function strategies.GetQuestFromItemRef(data)
    if not data.focus or not data.focus.pfQtext then
        return nil
    end
    return GetTypeAndIdFromLink(data.focus.pfQtext)
end

function strategies.GetQuestFromQuestLog(data)
    if not data.focus then
        return nil
    end
    local questIndex = GetQuestLogTitleIndex(data.focus:GetName())
    if not questIndex then
        return nil
    end
    if pfDatabase and pfDatabase.GetQuestIDs then
        local possibleQuests = pfDatabase:GetQuestIDs(questIndex)
        return possibleQuests[1], "quest"
    end
    local questTitle, _, _, isHeader = GetQuestLogTitle(questIndex)
    if not questTitle or isHeader then
        return nil
    end
    return urlencode(questTitle), "search"
end

function strategies.GetQuestFromPfQuestTracker(data)
    if not data.focus or not data.focus.questid then
        return nil
    end
    return data.focus.questid, "quest"
end

function strategies.GetNPCFromMouseover(data)
    local unitName = UnitName("mouseover")
    if not unitName or not pfDatabase or not pfDatabase.GetIDByName then
        return nil
    end
    local unitsResult = pfDatabase:GetIDByName(unitName, "units")
    if next(unitsResult) == nil then
        return nil
    end
    for unitId in pairs(unitsResult) do
        return unitId, "npc"
    end
end
