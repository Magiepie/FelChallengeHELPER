local frame, events = CreateFrame("Frame"), {};
function events:MERCHANT_SHOW(...)
	if  MerchantNameText:GetText() == "Azzazel" then
	   if MerchantItem1Name:GetText() == "Slaughterhouse" then
			 FelChallengeShop()
	   end
	end
end

frame:SetScript("OnEvent", function(self, event, ...)
	events[event](self, ...); 
end);
for k, v in pairs(events) do
	frame:RegisterEvent(k);
end



function ToolTip(i)  
    local mytext1=_G["GameTooltipTextLeft1"] 
	--local Challenge = Name:match(".*: (%a.*)")
    local ChalName= mytext1:GetText()
    local mytext2=_G["GameTooltipTextLeft2"] 
    local Tier=mytext2:GetText()
	local Tier = Tier:match("Tier (%d*)")

    if Tier and ChalName and IsChallenge(Tier,ChalName) then -- Fix lua errors By Szyler
        GameTooltipTextLeft1:SetText(ChalName.." -- Completed")

    end
end

function MerchantFrame_Update()
	if ( MerchantFrame.selectedTab == 1 ) then
		MerchantFrame_UpdateMerchantInfo();
		FelChallengeShop()
	else
		MerchantFrame_UpdateBuybackInfo();
	end
	
end

function FelChallengeShop()
	local FelTier = GetFelChalTier()
	for i=1,10 do
		local ChalName = _G["MerchantItem"..i.."Name"]:GetText();
		if IsChallenge(FelTier,ChalName) then
			local itemButton = _G["MerchantItem"..i.."ItemButton"];
			local merchantButton = _G["MerchantItem"..i];
			SetItemButtonNameFrameVertexColor(merchantButton, 0, 1, 0);
			SetItemButtonSlotVertexColor(merchantButton, 0, 1, 0);
			SetItemButtonNormalTextureVertexColor(itemButton, 0, 1.0, 0);
		end
	end
	
end

function GetFelChalTier()
	for i = 1,10 do
		local IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText, isGuildAch = GetAchievementInfo(39990+i)
		if Completed == false then return i end
	end
	return 1
end

function IsChallenge(Tier,ChalName)
    if Tier ~= nil then -- Fix lua errors By Szyler
        for i=1,25 do
            local IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText, isGuildAch = GetAchievementInfo(80000+tonumber(Tier), i) 
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
	 local Tier = Tier:match("Tier (%d*)")
    if Tier and itemLinkName and IsChallenge(Tier,itemLinkName) then 
        ItemRefTooltipTextLeft1:SetText(itemLinkName.." -- Completed")
    end
  end)

function MouseOver()   
	for i=1,10 do
		local button =_G["MerchantItem"..i.."ItemButton"]
		if(MouseIsOver(button)) then ToolTip(i) end
   end
	for i=1,5 do -- bag support by Szyler
		for j=1,36 do
			local bagItem =_G["ContainerFrame"..i.."Item"..j] 
			if(MouseIsOver(bagItem)) then ToolTip() end
		end
	end
end
GameTooltip:HookScript("OnTooltipSetItem", MouseOver)
