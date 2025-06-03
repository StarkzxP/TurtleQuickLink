-- Función para aplicar el skin de pfUI si está disponible
local function ApplyPFUISkin()
    -- Verificar si pfUI está instalado y cargado
    if not pfUI or not pfUI.api then
        return false
    end

    -- Aplicar skin de pfUI a nuestro frame

    TurtleCopyFrame_Title:SetPoint("TOP", TurtleCopyFrame, "TOP", 0, -7)
    TurtleCopyFrame_Subtitle:SetTextColor(1, 1, 1, 1)
    TurtleCopyFrame_EditBox:SetTextInsets(5, 5, 0, 0)
    TurtleCopyFrame_CloseButton:SetPoint("BOTTOM", TurtleCopyFrame, "BOTTOM", 0, 10)
    pfUI.api.CreateBackdrop(TurtleCopyFrame, nil, nil, 0.7)
    pfUI.api.CreateBackdrop(TurtleCopyFrame_EditBox, nil, true)
    pfUI.api.SkinButton(TurtleCopyFrame_CloseButton)
    TurtleCopyFrame_HeaderTexture:Hide()
    TurtleCopyFrame_EditBoxBackground:Hide()

    return true
end

-- Función de carga principal
function TurtleCopyFrame_OnLoad(self)
    ApplyPFUISkin()
    -- -- Configuración adicional común para ambos estilos
    -- TurtleCopyFrame_Title:SetText("Turtle Quick Link")
    -- TurtleCopyFrame_Subtitle:SetText("Press CTRL-C to copy")
    -- TurtleCopyFrame_Subtitle:SetTextColor(1, 1, 1)

    -- -- Posicionar elementos
    -- TurtleCopyFrame_EditBox:SetPoint("TOP", 0, -40)
    -- TurtleCopyFrame_CopyButton:SetPoint("BOTTOM", 0, 20)
    -- TurtleCopyFrame_CloseButton:SetPoint("TOPRIGHT", -5, -5)
end
