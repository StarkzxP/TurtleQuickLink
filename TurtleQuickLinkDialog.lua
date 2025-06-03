local function ApplyPFUISkin()
    if not pfUI or not pfUI.api then
        return
    end

    TurtleCopyFrame_Title:SetPoint("TOP", TurtleCopyFrame, "TOP", 0, -7)
    TurtleCopyFrame_Subtitle:SetTextColor(1, 1, 1, 1)
    TurtleCopyFrame_EditBox:SetTextInsets(5, 5, 0, 0)
    TurtleCopyFrame_CloseButton:SetPoint("BOTTOM", TurtleCopyFrame, "BOTTOM", 0, 10)
    pfUI.api.CreateBackdrop(TurtleCopyFrame, nil, nil, 0.7)
    pfUI.api.CreateBackdrop(TurtleCopyFrame_EditBox, nil, true)
    pfUI.api.SkinButton(TurtleCopyFrame_CloseButton)
    TurtleCopyFrame_HeaderTexture:Hide()
    TurtleCopyFrame_EditBoxBackground:Hide()
end

function TurtleCopyFrame_OnLoad()
    ApplyPFUISkin()
end
