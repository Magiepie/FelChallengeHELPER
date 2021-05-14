function ToolTip()  
    local mytext1=_G["GameTooltipTextLeft1"] 
    local ChalName=mytext1:GetText()
    local mytext2=_G["GameTooltipTextLeft2"] 
    local Tier=mytext2:GetText()
    if Tier and ChalName and IsChallenge(Tier,ChalName) then -- Fix lua errors By Szyler
        GameTooltipTextLeft1:SetText(ChalName.." -- Completed")
    end
end

function IsChallenge(Tier,ChalName)
    local Tier = Tier:match("Tier (%d*)")
    if Tier then -- Fix lua errors By Szyler
        for i=1,25 do
            local IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText, isGuildAch = GetAchievementInfo(80000+Tier, i) 
            local Challenge = Name:match(".*: (%a.*)")
            if Challenge == ChalName then 
                return Completed
            end
        end
    end
end

ItemRefTooltip:HookScript("OnTooltipSetItem", function(tooltip, ...) -- ItemRef support By Szyler
    local myItemText1=_G["ItemRefTooltipTextLeft1"] 
    local itemLinkName=myItemText1:GetText()
    local mytext2=_G["ItemRefTooltipTextLeft2"] 
    local Tier=mytext2:GetText()
    if Tier and itemLinkName and IsChallenge(Tier,itemLinkName) then 
        ItemRefTooltipTextLeft1:SetText(itemLinkName.." -- Completed")
    end
  end)

function MouseOver()   
	for i=1,10 do
		local button =_G["MerchantItem"..i.."ItemButton"]
		if(MouseIsOver(button)) then ToolTip() end
   end
	for i=1,5 do -- bag support by Szyler
		for j=1,36 do
			local bagItem =_G["ContainerFrame"..i.."Item"..j] 
			if(MouseIsOver(bagItem)) then ToolTip() end
		end
	end
end
GameTooltip:HookScript("OnTooltipSetItem", MouseOver)