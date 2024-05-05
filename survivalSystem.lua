--------------------------------------------------------------------
-- load kit
--------------------------------------------------------------------
-- /cmd to reload the screen
SLASH_RELOADUI1 = '/rl' 
SlashCmdList.RELOADUI = ReloadUI

-- /cmd to toggle frame stacks
SLASH_FRAMESTK1 = '/fs' 
SlashCmdList.FRAMESTK = function()
    LoadAddOn('Blizzard_DebugTools')
    FrameStackTooltip_Toggle()
end

-- prevents arrows from turning player (for chat)
for i = 1, NUM_CHAT_WINDOWS do 
    _G['ChatFrame'..i..'EditBox']:SetAltArrowKeyMode(false)
end


--------------------------------------------------------------------
-- main functions
--------------------------------------------------------------------
-- test function to plug stuff in and test things quickly
SLASH_TF1 = '/test' 
SlashCmdList.TF = function() -- find the shorter way of including the /slash function
    testFunc()
end

function testFunc()
    --stuff to test real quick
    local testing = GetSpellInfo('Food')
    print('----------')
    print('response: '..testing)
    print('----------')
end



-- return the player's name
player = UnitName('Player')

SLASH_WAI1 = '/wai' 
SlashCmdList.WAI = function()
    whoAmI()
end

function whoAmI()
    print('----------')
    print('Your name is: '..player)
    print('----------')
end


-- print player class
local myClass = UnitClass("player")

SLASH_CLASS1 = '/myclass' 
SlashCmdList.CLASS = function()
    myClassIs()
end

function myClassIs()
    print(myClass)
end



--------------------------------------------------------------------
-- setup initial hunger and thirst values
local hunger = 100
local thirst = 100



-- print current hunger and thirst values
SLASH_HP1 = '/ht' 
SlashCmdList.HP = function()
    survival()
end

function survival()
    print('----------')
    print('hunger: '..hunger)
    print('thirst: '..thirst)
    print('----------')
    return 1 --do I need this line?
end



-- reset hunger to 100, to be used when player eats any type of food
SLASH_RH1 = '/rh' 
SlashCmdList.RH = function()
    resetHunger()
    print('Hunger is now reset to: '..hunger)
end

function resetHunger()
    hunger = 100
end



-- remove 20 hunger for testing
SLASH_HUNGRY1 = '/hungry' 
SlashCmdList.HUNGRY = function()
    makeHungry()
    print('Hunger is now reset to: '..hunger)
end

function makeHungry()
    hunger = hunger - 20
    MyStatusBar:SetValue(hunger)
end



-- food burn loop
local seconds = 0

local function onUpdate(self,elapsed)
    seconds = seconds + elapsed
    if seconds >= 30 then -- number represents seconds, need other modifiers like mining, walking, swimming, etc.
        -- DEFAULT_CHAT_FRAME:AddMessage("Hunger: "..hunger) -- print currentn hunger value in chat window
        hunger = hunger - 1
        -- MyStatusBar:SetValue(hunger)
        seconds = 0
    end
end

local f = CreateFrame("frame")
f:SetScript("OnUpdate", onUpdate) -- what else can we do with SetScript?



--------------------------------------------------------------------
-- List all player buffs, see if we can even ready any buffs in the first place

SLASH_BUFFS1 = '/buffs' 
SlashCmdList.BUFFS = function()
    ListBuffs()
end

function ListBuffs()
    local i = 1
    while true do
        local name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitBuff('player', i)
        if not name then break end -- if no more buffs, break the loop
        print('Buff:', name, 'Spell ID:', spellId)
        i = i + 1
    end
end



--------------------------------------------------------------------
-- Look for specific buff, '/checkbuff Food' checks if the player is eating, need an event listener to reset hunger when gaining food buff

SLASH_BUFFLISTER1 = '/checkbuff' 
SlashCmdList.BUFFLISTER = function(msg)
    CheckBuff(msg)
end

function CheckBuff(buffName)
    local i = 1
    local found = false

    while true do 
        local name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitBuff('player', i)
        -- if name == 'Lone Wolf' then print('I see lone wolf') else print('i dont see lone wolf') end
        if not name then break end -- if no more buffs, break the loop

        if name == buffName then 
            print('buff found:', name, 'Spell ID:', spellId, '| Duration:', duration, '|Expiration time:', expirationTime - GetTime())
            found = true
            break
        end

        i = i + 1
    end

    if not found then 
        print('buff not found:', buffName)
    end
    
end



--------------------------------------------------------------------
-- movable hunger/thirst bars
--------------------------------------------------------------------
-- hunger bar 
MyStatusBar = CreateFrame("StatusBar", nil, UIParent)
MyStatusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
MyStatusBar:GetStatusBarTexture():SetHorizTile(false)
MyStatusBar:SetMinMaxValues(0, 100)
MyStatusBar:SetValue(hunger)
MyStatusBar:SetWidth(100)
MyStatusBar:SetHeight(10)
MyStatusBar:SetPoint("LEFT",UIParent,"CENTER")
MyStatusBar:SetStatusBarColor(0,1,0)
MyStatusBar:EnableMouse(true) -- movable stuff below this line?
MyStatusBar:SetMovable(true)
MyStatusBar:SetUserPlaced(true) -- This allows the frame position to be saved
MyStatusBar:RegisterForDrag('LeftButton') -- Only initiate drag with the left mouse button
MyStatusBar:SetScript('OnDragStart',
MyStatusBar.StartMoving)
MyStatusBar:SetScript('OnDragStop',
MyStatusBar.StopMovingOrSizing)



