----------------------------------------------------------------
--[[ Resource: Beautify Library
     Script: configurations: elements.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 01/02/2021 (OvileAmriam)
     Desc: Element's Confign ]]--
----------------------------------------------------------------


------------------------
--[[ Configurations ]]--
------------------------

--inputDelayDuration = 500 --(In milliseconds)
availableElements = {

    ["beautify_window"] = {
        __syntax = {
            functionName = "createWindow",
            parameters = {
                {name = "x", type = "float"},
                {name = "y", type = "float"},
                {name = "width", type = "float"},
                {name = "height", type = "float"},
                {name = "title", type = "string"},
                {name = "color", type = "number"}
            },
        },
        __renderFunction = renderWindow,
        __allowedChildren = {
            
        },
        __minimumSize = 56,
        __titleBar = {
            paddingX = 5,
            height = 25,
            close_button = {
                hoverAnimDuration = 1000
            }
        },
        __contentSection = {
            padding = 5
        }
    }

}