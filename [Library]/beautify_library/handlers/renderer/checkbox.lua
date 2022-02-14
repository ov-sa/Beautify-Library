----------------------------------------------------------------
--[[ Resource: Beautify Library
     Script: handlers: renderer: checkbox.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 01/02/2021 (OvileAmriam)
     Desc: Checkbox's Renderer ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    unpack = unpack,
    tocolor = tocolor,
    isKeyClicked = isKeyClicked,
    getUIParent = getUIParent,
    __getUITemplate = __getUITemplate,
    manageElementForceRender = manageElementForceRender,
    setCheckboxSelection = setCheckboxSelection,
    unpackColor = unpackColor,
    isMouseOnPosition = isMouseOnPosition,
    getInterpolationProgress = getInterpolationProgress,
    interpolateBetween = interpolateBetween,
    dxSetRenderTarget = dxSetRenderTarget,
    dxDrawRectangle = dxDrawRectangle,
    dxDrawText = dxDrawText,
    math = math
}


-------------------
--[[ Variables ]]--
-------------------

local elementType = "beautify_checkbox"


------------------------------------
--[[ Function: Renders Checkbox ]]--
------------------------------------

function renderCheckbox(element, isActiveMode, isFetchingInput, mouseReference)

    local elementReference = createdElements[element]
    if not isFetchingInput then
        local elementParent = imports.getUIParent(element)
        if not elementParent then imports.dxSetRenderTarget() end
        local isElementToBeRendered, isElementToBeForceRendered = true, false
        local isElementInterpolationToBeRefreshed = CLIENT_MTA_RESTORED
        local isElementToBeReloaded = (not CLIENT_MTA_MINIMIZED) and (elementReference.gui["__UI_CACHE__"].reloadElement or (CLIENT_RESOURCE_TEMPLATE_RELOAD[(elementReference.sourceResource)] and CLIENT_RESOURCE_TEMPLATE_RELOAD[(elementReference.sourceResource)][elementType]))
        local isElementToBeUpdated = isElementToBeReloaded or elementReference.gui["__UI_CACHE__"].updateElement or CLIENT_MTA_RESTORED
        local elementTemplate = imports.__getUITemplate(elementType, elementReference.sourceResource)

        if not isElementToBeRendered then return false end
        if (isActiveMode or isElementToBeReloaded) and isElementToBeUpdated then
            if not elementReference.gui["__UI_CACHE__"]["Checkbox"] then
                elementReference.gui["__UI_CACHE__"]["Checkbox"] = {
                    text = {
                        offsets = {}
                    }
                }
                elementReference.gui["__UI_CACHE__"]["Tick Box"] = {
                    offsets = {},
                    icon = {
                        offsets = {}
                    }
                }
                elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Checkbox"] = {}
                elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Tick Box"] = {}
            end
            local checkbox_tickbox_icon_size = imports.math.min(availableElements[elementType].minimumSize, availableElements[elementType].tickboxSize)
            local checkbox_tickbox_icon_padding = (availableElements[elementType].minimumSize - checkbox_tickbox_icon_size)*0.5
            local checkbox_tickbox_offsetY = elementReference.gui.y + ((elementReference.gui.height - availableElements[elementType].minimumSize)*0.5)
            elementReference.gui["__UI_CACHE__"]["Tick Box"].offsets.width = availableElements[elementType].minimumSize
            elementReference.gui["__UI_CACHE__"]["Tick Box"].offsets.height = availableElements[elementType].minimumSize
            elementReference.gui["__UI_CACHE__"]["Tick Box"].offsets.startX = elementReference.gui.x
            elementReference.gui["__UI_CACHE__"]["Tick Box"].offsets.startY = checkbox_tickbox_offsetY
            elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.width = checkbox_tickbox_icon_size
            elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.height = checkbox_tickbox_icon_size
            elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.startX = elementReference.gui["__UI_CACHE__"]["Tick Box"].offsets.startX + checkbox_tickbox_icon_padding
            elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.startY = elementReference.gui["__UI_CACHE__"]["Tick Box"].offsets.startY + checkbox_tickbox_icon_padding
            if elementReference.gui.text then
                elementReference.gui["__UI_CACHE__"]["Checkbox"].text.text = elementReference.gui.text
                elementReference.gui["__UI_CACHE__"]["Checkbox"].text.offsets.startX = elementReference.gui.x + availableElements[elementType].minimumSize + availableElements[elementType].viewSection.paddingLeft
                elementReference.gui["__UI_CACHE__"]["Checkbox"].text.offsets.startY = elementReference.gui.y + availableElements[elementType].viewSection.padding + elementTemplate.fontPaddingY
                elementReference.gui["__UI_CACHE__"]["Checkbox"].text.offsets.endX = elementReference.gui.x + elementReference.gui.width - availableElements[elementType].viewSection.padding
                elementReference.gui["__UI_CACHE__"]["Checkbox"].text.offsets.endY = elementReference.gui.y + elementReference.gui.height - availableElements[elementType].viewSection.padding
                elementReference.gui["__UI_CACHE__"]["Checkbox"].text.isToBeRendered = ((elementReference.gui["__UI_CACHE__"]["Checkbox"].text.offsets.endX - elementReference.gui["__UI_CACHE__"]["Checkbox"].text.offsets.startX) > 0) and ((elementReference.gui["__UI_CACHE__"]["Checkbox"].text.offsets.endY - elementReference.gui["__UI_CACHE__"]["Checkbox"].text.offsets.startY) > 0)
            else
                elementReference.gui["__UI_CACHE__"]["Checkbox"].text.text = false
                elementReference.gui["__UI_CACHE__"]["Checkbox"].text.offsets.startX = false
                elementReference.gui["__UI_CACHE__"]["Checkbox"].text.offsets.startY = false
                elementReference.gui["__UI_CACHE__"]["Checkbox"].text.offsets.endX = false
                elementReference.gui["__UI_CACHE__"]["Checkbox"].text.offsets.endY = false
                elementReference.gui["__UI_CACHE__"]["Checkbox"].text.isToBeRendered = false
            end
            elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Tick Box"].startX = elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.startX
            elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Tick Box"].startY = elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.startY
            elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Tick Box"].width = elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.width
            elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Tick Box"].height = elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.height
            if isElementToBeReloaded then
                elementReference.gui["__UI_CACHE__"]["Tick Box"].color = imports.tocolor(imports.unpackColor(elementTemplate.tickBox.color))
                elementReference.gui["__UI_CACHE__"]["Tick Box"].iconColor = imports.tocolor(imports.unpack(elementTemplate.tickBox.iconColor))
            end
            if not CLIENT_MTA_MINIMIZED then
                elementReference.gui["__UI_CACHE__"].reloadElement = nil
            end
            elementReference.gui["__UI_CACHE__"].updateElement = nil
        end

        local isCheckBoxSelected = elementReference.gui.selection
        if isActiveMode then
            if not elementReference.gui.tickBox.animAlphaPercent then
                elementReference.gui.tickBox.animAlphaPercent = 0
                elementReference.gui.tickBox.hoverStatus = "backward"
                elementReference.gui.tickBox.hoverAnimTickCounter = CLIENT_CURRENT_TICK
            end
            elementReference.gui.tickBox.interpolationProgress = imports.getInterpolationProgress(elementReference.gui.tickBox.hoverAnimTickCounter, availableElements[elementType].viewSection.hoverAnimDuration)
            local isTickBoxHoverInterpolationRendering = elementReference.gui.tickBox.interpolationProgress < 1
            isElementToBeForceRendered = isElementToBeForceRendered or isTickBoxHoverInterpolationRendering or (not isCheckBoxSelected and elementReference.gui.tickBox.hoverStatus ~= "backward")
            if isElementInterpolationToBeRefreshed or isTickBoxHoverInterpolationRendering then
                if elementReference.gui.tickBox.hoverStatus == "forward" then
                    elementReference.gui.tickBox.animAlphaPercent = imports.interpolateBetween(elementReference.gui.tickBox.animAlphaPercent, 0, 0, 1, 0, 0, elementReference.gui.tickBox.interpolationProgress, "InQuad")
                else
                    elementReference.gui.tickBox.animAlphaPercent = imports.interpolateBetween(elementReference.gui.tickBox.animAlphaPercent, 0, 0, 0, 0, 0, elementReference.gui.tickBox.interpolationProgress, "InQuad")
                end
            end
        end
        if elementReference.gui.tickBox.animAlphaPercent < 1 then
            imports.dxDrawRectangle(elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.startX, elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.startY, elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.width, elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.height, elementReference.gui["__UI_CACHE__"]["Tick Box"].color, elementReference.gui.postGUI)
            if elementReference.gui.tickBox.animAlphaPercent > 0 then
                imports.dxDrawRectangle(elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.startX, elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.startY, elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.width, elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.height, imports.tocolor(elementTemplate.tickBox.iconColor[1], elementTemplate.tickBox.iconColor[2], elementTemplate.tickBox.iconColor[3], elementTemplate.tickBox.iconColor[4]*elementReference.gui.tickBox.animAlphaPercent), elementReference.gui.postGUI)
            end
        else
            imports.dxDrawRectangle(elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.startX, elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.startY, elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.width, elementReference.gui["__UI_CACHE__"]["Tick Box"].icon.offsets.height, elementReference.gui["__UI_CACHE__"]["Tick Box"].iconColor, elementReference.gui.postGUI)
        end
        if elementReference.gui["__UI_CACHE__"]["Checkbox"].text.isToBeRendered then
            if isActiveMode then
                if not elementReference.gui.animAlphaPercent then
                    elementReference.gui.animAlphaPercent = 0.8
                    elementReference.gui.hoverStatus = "backward"
                    elementReference.gui.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                end
                elementReference.gui.interpolationProgress = imports.getInterpolationProgress(elementReference.gui.hoverAnimTickCounter, availableElements[elementType].viewSection.hoverAnimDuration)
                local isTextHoverInterpolationRendering = elementReference.gui.interpolationProgress < 1
                isElementToBeForceRendered = isElementToBeForceRendered or isTextHoverInterpolationRendering or (not isCheckBoxSelected and elementReference.gui.hoverStatus ~= "backward")
                if isElementInterpolationToBeRefreshed or isTextHoverInterpolationRendering then
                    if elementReference.gui.hoverStatus == "forward" then
                        elementReference.gui.animAlphaPercent = imports.interpolateBetween(elementReference.gui.animAlphaPercent, 0, 0, 1, 0, 0, elementReference.gui.interpolationProgress, "InQuad")
                    else
                        elementReference.gui.animAlphaPercent = imports.interpolateBetween(elementReference.gui.animAlphaPercent, 0, 0, 0.8, 0, 0, elementReference.gui.interpolationProgress, "InQuad")
                    end
                end
            end
            local checkbox_fontColor = (elementReference.gui.fontColor and imports.tocolor(elementReference.gui.fontColor[1], elementReference.gui.fontColor[2], elementReference.gui.fontColor[3], elementReference.gui.fontColor[4]*elementReference.gui.animAlphaPercent)) or imports.tocolor(elementTemplate.fontColor[1], elementTemplate.fontColor[2], elementTemplate.fontColor[3], elementTemplate.fontColor[4]*elementReference.gui.animAlphaPercent)
            imports.dxDrawText(elementReference.gui["__UI_CACHE__"]["Checkbox"].text.text, elementReference.gui["__UI_CACHE__"]["Checkbox"].text.offsets.startX, elementReference.gui["__UI_CACHE__"]["Checkbox"].text.offsets.startY, elementReference.gui["__UI_CACHE__"]["Checkbox"].text.offsets.endX, elementReference.gui["__UI_CACHE__"]["Checkbox"].text.offsets.endY, checkbox_fontColor, elementTemplate.fontScale or 1, elementTemplate.font, "left", "center", true, false, elementReference.gui.postGUI, false)
        end
        if isActiveMode then
            imports.manageElementForceRender(element, isElementToBeForceRendered)
        end
    else
        if elementReference.gui["__UI_CACHE__"]["Tick Box"].offsets.startX and elementReference.gui["__UI_CACHE__"]["Tick Box"].offsets.startY then
            local __mouseReference = {x = mouseReference.x, y = mouseReference.y}
            local isElementHovered = CLIENT_HOVERED_ELEMENT.element == element
            local isCheckBoxHovered, isTickBoxHovered = false, false
            local isCheckBoxSelected = elementReference.gui.selection
            if isElementHovered then
                if not elementReference.isDisabled then
                    isCheckBoxHovered = isElementHovered
                end
            end
            if isCheckBoxHovered or isCheckBoxSelected then
                if elementReference.gui.hoverStatus ~= "forward" then
                    elementReference.gui.hoverStatus = "forward"
                    elementReference.gui.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                end
                isTickBoxHovered = isCheckBoxHovered and imports.isMouseOnPosition(__mouseReference.x + elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Tick Box"].startX, __mouseReference.y + elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Tick Box"].startY, elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Tick Box"].width, elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Tick Box"].height)
            else
                if elementReference.gui.hoverStatus ~= "backward" then
                    elementReference.gui.hoverStatus = "backward"
                    elementReference.gui.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                end
            end
            if isTickBoxHovered or isCheckBoxSelected then
                if isTickBoxHovered and imports.isKeyClicked("mouse1") then
                    imports.setCheckboxSelection(element, not isCheckBoxSelected)
                end
                if elementReference.gui.tickBox.hoverStatus ~= "forward" then
                    elementReference.gui.tickBox.hoverStatus = "forward"
                    elementReference.gui.tickBox.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                end
            else
                if elementReference.gui.tickBox.hoverStatus ~= "backward" then
                    elementReference.gui.tickBox.hoverStatus = "backward"
                    elementReference.gui.tickBox.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                end
            end
        end
    end
    return true

end