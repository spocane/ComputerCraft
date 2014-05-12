-- SyncPortal by spocane

-- Improved "direwolf20" Design (http://pastebin.com/SY4K63Vc)
    -- Requires EnderChest to be max size (54 Slots)

version = "Beta 1.0"

-- Variables

local checkSlot = 37 -- Slot to check if Full/Empty (Armor-Boots)

local lockExit = "back" -- Redstone control for "Shell Storage" Blockade (Must be Inverted)
local lockEntry = "right" -- Redstone control for "Entry" Blockade
local pimSide = "top" -- Side that the PIM is Placed
local eChestSide = "south" -- Direction that the EnderChest is Placed (Must be next to PIM)

-- Initialization

p = peripheral.wrap(pimSide)

local playerStatus = 0 --Status of Players current Inventory (0=Empty, 1=Full)
-- local enderChest = 0 --Status of EnderChests current Inventory (0=Empty, 1=Full)
-- local lockExit = 0 --Status of the "Shell Storage" Blockade (0=OFF, 1=ON)
-- local lockEntry = 0 --Status of the "Entry" Blockade (0=OFF, 1=ON)

--Functions

function getState() -- Check the Inventory state (Full/Empty)
    if p.getStackInSlot(checkSlot) then
        playerStatus = 1
        print("Player has Inventory")
    else
        playerStatus = 0
        print("Player has 'NO' Inventory")
    end
end

function emptyPlayer() -- Emptys the Players Inventory into the EnderChest
    s = 1
    for i = 1,9 do -- HotBar
        p.pushItemIntoSlot(eChestSide, i, 64, s)
        s = s + 1
    end
    
    for i = 10,36 do -- MainInventory
        p.pushItemIntoSlot(eChestSide, i, 64, s)
        s = s + 1
    end

    s = 46
    for i = 37, 40 do -- Armor
        p.pushItemIntoSlot(eChestSide, i, 64, s)
        s = s + 1
    end
end

function fillPlayer() -- Fills the Players Inventory From the EnderChest
        s = 1
    for i = 1,9 do -- HotBar
        p.pullItemIntoSlot(eChestSide, s, 64, i)
        s = s + 1
    end
    
    for i = 10,36 do -- MainInventory
        p.pullItemIntoSlot(eChestSide, s, 64, i)
        s = s + 1
    end

    s = 46
    for i = 37, 40 do -- Armor
        p.pullItemIntoSlot(eChestSide, s, 64, i)
        s = s + 1
    end
end

-- Program Startup

print("Running 'syncPortal'")
print("Version : "..version)

rs.setOutput(lockEntry, false)
rs.setOutput(lockExit, false)

-- Main Program

while true do
    if os.pullEvent('player_on') then
        rs.setOutput(lockEntry, true)
        --rs.setOutput(lockExit, true)
        print("Player On")
        getState()
        print("Player Status = "..playerStatus)
    end
    if playerStatus == 1 then
        emptyPlayer()
        rs.setOutput(lockExit, true)
        sleep(2)
        rs.setOutput(lockEntry, false)
        rs.setOutput(lockExit, false)
        playerStatus = 0
    else
        fillPlayer()
        rs.setOutput(lockEntry, false)
        sleep(2)
        rs.setOutput(lockExit, false)
    end
    sleep(.1)
end
