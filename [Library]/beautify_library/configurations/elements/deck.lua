----------------------------------------------------------------
--[[ Resource: Beautify Library
     Script: configurations: elements: deck.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 01/02/2021 (OvileAmriam)
     Desc: Element's Confign ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local elementType = "beautify_deck"


------------------------
--[[ Configurations ]]--
------------------------

availableElements[elementType] = {
    reference = "deck",
    syntax = {
        functionName = "createDeck",
        parameters = {
            {name = "x", type = "float"},
            {name = "y", type = "float"},
            {name = "height", type = "float"},
            {name = "title", type = "string"},
            {name = "deckpane", type = "userdata", userDataType = "beautify_deckpane"}
        }
    },
    renderFunction = renderDeck,
    allowedChildren = {
        ["beautify_gridlist"] = true,
        ["beautify_button"] = true,
        ["beautify_label"] = true,
        ["beautify_slider"] = true,
        ["beautify_selector"] = true,
        ["beautify_checkbox"] = true
    },
    isDraggable = false,
    titleBar = {
        paddingX = 5,
        height = 22,
        toggleButton = {
            arrowIconSize = 12,
            hoverAnimDuration = 1000
        }
    },
    contentSection = {
        padding = 5
    }
}

availableElements[elementType]["APIs"] = {}