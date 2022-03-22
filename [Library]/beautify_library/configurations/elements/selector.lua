----------------------------------------------------------------
--[[ Resource: Beautify Library
     Script: configurations: elements: selector.lua
     Server: -
     Author: vStudio
     Developer: -
     DOC: 01/02/2021
     Desc: Element's Confign ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local elementType = "beautify_selector"


------------------------
--[[ Configurations ]]--
------------------------

availableElements[elementType] = {
    reference = "selector",
    syntax = {
        functionName = "createSelector",
        parameters = {
            {name = "x", type = "float"},
            {name = "y", type = "float"},
            {name = "width", type = "float"},
            {name = "height", type = "float"},
            {name = "type", type = "string"}
        }
    },
    renderFunction = renderSelector,
    allowedChildren = false,
    isDraggable = false,
    minimumSize = 20,
    arrowIconSize = 11,
    validTypes = {
        ["horizontal"] = true,
        ["vertical"] = true
    },
    viewSection = {
        padding = 1,
        hoverAnimDuration = 1250
    }
}

availableElements[elementType]["APIs"] = {
    ["setSelectorDataList"] = {
        parameters = {
            {name = "selector", type = "userdata", userDataType = elementType},
            {name = "list", type = "table"}
        }
    },
    ["getSelectorDataList"] = {
        parameters = {
            {name = "selector", type = "userdata", userDataType = elementType}
        }
    },
    ["clearSelectorText"] = {
        parameters = {
            {name = "selector", type = "userdata", userDataType = elementType}
        }
    },
    ["setSelectorText"] = {
        parameters = {
            {name = "selector", type = "userdata", userDataType = elementType},
            {name = "text", type = "string"}
        }
    },
    ["getSelectorText"] = {
        parameters = {
            {name = "selector", type = "userdata", userDataType = elementType}
        }
    },
    ["clearSelectorTextColor"] = {
        parameters = {
            {name = "selector", type = "userdata", userDataType = elementType}
        }
    },
    ["setSelectorTextColor"] = {
        parameters = {
            {name = "selector", type = "userdata", userDataType = elementType},
            {name = "color", type = "table"}
        }
    },
    ["getSelectorTextColor"] = {
        parameters = {
            {name = "selector", type = "userdata", userDataType = elementType}
        }
    },
    ["setSelectorSelection"] = {
        parameters = {
            {name = "selector", type = "userdata", userDataType = elementType},
            {name = "data", type = "number"}
        }
    },
    ["getSelectorSelection"] = {
        parameters = {
            {name = "selector", type = "userdata", userDataType = elementType}
        }
    }
}