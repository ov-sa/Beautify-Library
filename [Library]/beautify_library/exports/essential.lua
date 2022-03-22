----------------------------------------------------------------
--[[ Resource: Beautify Library
     Script: exports: essential.lua
     Server: -
     Author: vStudio
     Developer: -
     DOC: 01/02/2021
     Desc: Essential Exports ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tonumber = tonumber,
    isElement = isElement,
    getElementType = getElementType,
    addEventHandler = addEventHandler,
    triggerEvent = triggerEvent
}

imports.addEventHandler("onClientResourceStart", resource, function()
    imports.destroyElementForceRender = destroyElementForceRender
    imports.getUIParent = getUIParent
    imports.updateElement = updateElement
end)


------------------------------------------
--[[ Function: Verifies UI's Validity ]]--
------------------------------------------

function isUIValid(element)

    if element and imports.isElement(element) then
        local elementParent = imports.getUIParent(element)
        if elementParent then
            if createdElements[elementParent].isValid then
                return createdElements[element].isValid
            end
        else
            return createdElements[element].isValid
        end
    end
    return false

end


---------------------------------------------------
--[[ Functions: Retrieves/Sets UI's Visibility ]]--
---------------------------------------------------

function isUIVisible(element)

    if isUIValid(element) then
        local elementParent = imports.getUIParent(element)
        if elementParent then
            if createdElements[elementParent].isVisible then
                return createdElements[element].isVisible
            end
        else
            return createdElements[element].isVisible
        end
    end
    return false

end

function setUIVisible(element, state)

    if isUIValid(element) and (state == true or state == false) then
        if createdElements[element].isVisible ~= state then
            createdElements[element].isVisible = state
            if state then
                imports.updateElement(element)
            else
                imports.destroyElementForceRender(element)
            end
            imports.triggerEvent("onClientUIVisibilityAltered", element, state)
            return true
        end
    end
    return false

end


-----------------------------------------------------
--[[ Functions: Retrieves/Sets UI's Draggability ]]--
-----------------------------------------------------

function isUIDraggable(element)

    if isUIValid(element) then
        return createdElements[element].isDraggable
    end
    return false

end

function setUIDraggable(element, state)

    if isUIValid(element) and availableElements[imports.getElementType(element)].isDraggable and (state == true or state == false) then
        if createdElements[element].isDraggable ~= state then
            createdElements[element].isDraggable = state
            return true
        end
    end
    return false

end


-------------------------------------------------------
--[[ Functions: Retrieves/Sets UI's Disabled State ]]--
-------------------------------------------------------

function isUIDisabled(element)

    if isUIValid(element) then
        return createdElements[element].isDisabled
    end
    return false

end

function setUIDisabled(element, state)

    if isUIValid(element) and (state == true or state == false) then
        if createdElements[element].isDisabled ~= state then
            createdElements[element].isDisabled = state
            return true
        end
    end
    return false

end


-------------------------------------------------
--[[ Functions: Retrieves/Sets UI's Position ]]--
-------------------------------------------------

function getUIPosition(element)

    if isUIValid(element) then
        return createdElements[element].gui.x, createdElements[element].gui.y
    end
    return false

end

function setUIPosition(element, x, y)

    x, y = imports.tonumber(x), imports.tonumber(y)
    if x and y and isUIValid(element) then
        createdElements[element].gui.x, createdElements[element].gui.y = x, y
        imports.updateElement(element)
    end
    return false

end