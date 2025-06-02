TurtleQuickLink = TurtleQuickLink or {}

local strategies = {}
local turtletooltipStates = {}

function TurtleQuickLink:GetTurtleDBUrl(dataSources)
    for _, strategy in pairs(strategies) do
        local id, type = strategy(dataSources)
        if id and type then
            return string.format("https://database.turtle-wow.org/?%s=%s", type, id)
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

function strategies.GetItemFromTooltip(data)
    if not data.tooltip then
        return
    end
    return GetTypeAndIDFromLink(data.tooltip.itemLink)
end
