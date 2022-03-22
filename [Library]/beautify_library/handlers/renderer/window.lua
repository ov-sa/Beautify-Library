----------------------------------------------------------------
--[[ Resource: Beautify Library
     Script: handlers: renderer: window.lua
     Server: -
     Author: vStudio
     Developer: -
     DOC: 01/02/2021
     Desc: Window's Renderer ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tocolor = tocolor,
    isElement = isElement,
    isKeyClicked = isKeyClicked,
    __getUITemplate = __getUITemplate,
    manageElementForceRender = manageElementForceRender,
    renderElementChildren = renderElementChildren,
    attachUIElement = attachUIElement,
    destroyElement = destroyElement,
    setUIVisible = setUIVisible,
    unpackColor = unpackColor,
    isMouseOnPosition = isMouseOnPosition,
    getInterpolationProgress = getInterpolationProgress,
    interpolateBetween = interpolateBetween,
    dxCreateRenderTarget = dxCreateRenderTarget,
    dxSetRenderTarget = dxSetRenderTarget,
    dxSetBlendMode = dxSetBlendMode,
    dxCreateTexture = dxCreateTexture,
    dxDrawImage = dxDrawImage,
    dxDrawRectangle = dxDrawRectangle,
    dxDrawText = dxDrawText,
    dxGetTexturePixels = dxGetTexturePixels,
    dxGetTextWidth = dxGetTextWidth
}


-------------------
--[[ Variables ]]--
-------------------

local elementType = "beautify_window"


----------------------------------
--[[ Function: Renders Window ]]--
----------------------------------

function renderWindow(element, isActiveMode, isFetchingInput, mouseReference)

    local elementReference = createdElements[element]
    if not isFetchingInput then
        local isElementToBeRendered, isElementToBeForceRendered = true, false
        local isElementInterpolationToBeRefreshed = CLIENT_MTA_RESTORED
        local isElementToBeReloaded = (not CLIENT_MTA_MINIMIZED) and (elementReference.gui["__UI_CACHE__"].reloadElement or (CLIENT_RESOURCE_TEMPLATE_RELOAD[(elementReference.sourceResource)] and CLIENT_RESOURCE_TEMPLATE_RELOAD[(elementReference.sourceResource)][elementType]))
        local isElementToBeUpdated = isElementToBeReloaded or elementReference.gui["__UI_CACHE__"].updateElement or CLIENT_MTA_RESTORED
        local elementTemplate = imports.__getUITemplate(elementType, elementReference.sourceResource)

        if not isElementToBeRendered then return false end
        if (isActiveMode or isElementToBeReloaded) and isElementToBeUpdated then
            if not elementReference.gui["__UI_CACHE__"]["Window"] then
                elementReference.gui["__UI_CACHE__"]["Window"] = {
                    offsets = {},
                    divider = {},
                    view = {
                        offsets = {}
                    }
                }
                elementReference.gui["__UI_CACHE__"]["Title Bar"] = {
                    offsets = {},
                    text = {
                        offsets = {}
                    }
                }
                elementReference.gui["__UI_CACHE__"]["Close Button"] = {
                    offsets = {},
                    text = {
                        offsets = {}
                    }
                }
                elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Title Bar"] = {}
                elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Close Button"] = {}
            end
            local window_borderSize = availableElements[elementType].minimumSize*0.5
            elementReference.gui["__UI_CACHE__"]["Window"].offsets.startX = elementReference.gui.x
            elementReference.gui["__UI_CACHE__"]["Window"].offsets.startY = elementReference.gui.y
            elementReference.gui["__UI_CACHE__"]["Window"].offsets.width = elementReference.gui.width
            elementReference.gui["__UI_CACHE__"]["Window"].offsets.height = elementReference.gui.height
            elementReference.gui["__UI_CACHE__"]["Window"].view.offsets.startX = elementReference.gui["__UI_CACHE__"]["Window"].offsets.startX + elementReference.gui.viewSection.startX
            elementReference.gui["__UI_CACHE__"]["Window"].view.offsets.startY = elementReference.gui["__UI_CACHE__"]["Window"].offsets.startY + elementReference.gui.viewSection.startY
            elementReference.gui["__UI_CACHE__"]["Window"].view.offsets.width = elementReference.gui.viewSection.width
            elementReference.gui["__UI_CACHE__"]["Window"].view.offsets.height = elementReference.gui.viewSection.height
            local window_titleBar_paddingX = availableElements[elementType].titleBar.paddingX
            elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.startX = elementReference.gui["__UI_CACHE__"]["Window"].offsets.startX
            elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.startY = elementReference.gui["__UI_CACHE__"]["Window"].offsets.startY
            elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.width = elementReference.gui["__UI_CACHE__"]["Window"].offsets.width
            elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.height = window_borderSize
            elementReference.gui["__UI_CACHE__"]["Window"].divider.size = elementTemplate.titleBar.divider.size
            if isElementToBeReloaded then
                elementReference.gui["__UI_CACHE__"]["Window"].divider.color = imports.tocolor(imports.unpackColor(elementTemplate.titleBar.divider.color))
                elementReference.gui["__UI_CACHE__"]["Title Bar"].text.fontColor = imports.tocolor(imports.unpackColor(elementTemplate.titleBar.fontColor))
                elementReference.gui["__UI_CACHE__"]["Title Bar"].text.padding = ""
                while imports.dxGetTextWidth(elementReference.gui["__UI_CACHE__"]["Title Bar"].text.padding, 1, elementTemplate.titleBar.font) < window_borderSize do
                    elementReference.gui["__UI_CACHE__"]["Title Bar"].text.padding = elementReference.gui["__UI_CACHE__"]["Title Bar"].text.padding.." "
                end
                elementReference.gui["__UI_CACHE__"]["Close Button"].text.fontColor = imports.tocolor(imports.unpackColor(elementTemplate.titleBar.closeButton.fontColor))
            end
            elementReference.gui["__UI_CACHE__"]["Title Bar"].text.text = elementReference.gui["__UI_CACHE__"]["Title Bar"].text.padding..elementReference.gui.title
            elementReference.gui["__UI_CACHE__"]["Title Bar"].text.offsets.startX = elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.startX + window_titleBar_paddingX
            elementReference.gui["__UI_CACHE__"]["Title Bar"].text.offsets.startY = elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.startY + (elementTemplate.titleBar.fontPaddingY or 0)
            elementReference.gui["__UI_CACHE__"]["Title Bar"].text.offsets.endX = elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.startX + elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.width - elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.height - window_titleBar_paddingX
            elementReference.gui["__UI_CACHE__"]["Title Bar"].text.offsets.endY = elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.startY + elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.height
            elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Title Bar"].startX = elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.startX
            elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Title Bar"].startY = elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.startY
            elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Title Bar"].width = elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.width - elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.height
            elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Title Bar"].height = elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.height
            elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.startX = elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.startX + elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.width - elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.height
            elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.startY = elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.startY
            elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.width = elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.height
            elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.height = elementReference.gui["__UI_CACHE__"]["Title Bar"].offsets.height
            elementReference.gui["__UI_CACHE__"]["Close Button"].text.text = "X"
            elementReference.gui["__UI_CACHE__"]["Close Button"].text.offsets.startX = elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.startX
            elementReference.gui["__UI_CACHE__"]["Close Button"].text.offsets.startY = elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.startY + (elementTemplate.titleBar.fontPaddingY or 0)
            elementReference.gui["__UI_CACHE__"]["Close Button"].text.offsets.endX = elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.startX + elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.width
            elementReference.gui["__UI_CACHE__"]["Close Button"].text.offsets.endY = elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.startY + elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.height
            elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Close Button"].startX = elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.startX
            elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Close Button"].startY = elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.startY
            elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Close Button"].width = elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.width
            elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Close Button"].height = elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.height
            if isElementToBeReloaded or not elementReference.gui["__UI_CACHE__"]["Window"].renderTexture then
                if not elementReference.gui["__UI_CACHE__"]["Window"].renderTarget then
                    elementReference.gui["__UI_CACHE__"]["Window"].renderTarget = imports.dxCreateRenderTarget(elementReference.gui.width, elementReference.gui.height, true)
                end
                if elementReference.gui["__UI_CACHE__"]["Window"].renderTexture and imports.isElement(elementReference.gui["__UI_CACHE__"]["Window"].renderTexture) then
                    imports.destroyElement(elementReference.gui["__UI_CACHE__"]["Window"].renderTexture)
                    elementReference.gui["__UI_CACHE__"]["Window"].renderTexture = nil
                end
                imports.dxSetRenderTarget(elementReference.gui["__UI_CACHE__"]["Window"].renderTarget, true)
                imports.dxSetBlendMode("modulate_add")
                local window_color, window_titleBar_color = imports.tocolor(imports.unpackColor(elementTemplate.color)), imports.tocolor(imports.unpackColor(elementTemplate.titleBar.color))
                imports.dxDrawImage(0, 0, window_borderSize, window_borderSize, createdAssets["images"]["curved_square/regular/top_left.rw"], 0, 0, 0, window_titleBar_color, false)
                imports.dxDrawImage(elementReference.gui.width - window_borderSize, 0, window_borderSize, window_borderSize, createdAssets["images"]["curved_square/regular/top_right.rw"], 0, 0, 0, window_titleBar_color, false)
                imports.dxDrawImage(0, elementReference.gui.height - window_borderSize, window_borderSize, window_borderSize, createdAssets["images"]["curved_square/regular/bottom_left.rw"], 0, 0, 0, window_color, false)
                imports.dxDrawImage(elementReference.gui.width - window_borderSize, elementReference.gui.height - window_borderSize, window_borderSize, window_borderSize, createdAssets["images"]["curved_square/regular/bottom_right.rw"], 0, 0, 0, window_color, false)
                if elementReference.gui.width > availableElements[elementType].minimumSize then
                    imports.dxDrawRectangle(window_borderSize, 0, elementReference.gui.width - availableElements[elementType].minimumSize, window_borderSize, window_titleBar_color, false)
                    imports.dxDrawRectangle(window_borderSize, elementReference.gui.height - window_borderSize, elementReference.gui.width - availableElements[elementType].minimumSize, window_borderSize, window_color, false)
                end
                if elementReference.gui.height > availableElements[elementType].minimumSize then
                    imports.dxDrawRectangle(0, window_borderSize, window_borderSize, elementReference.gui.height - availableElements[elementType].minimumSize, window_color, false)
                    imports.dxDrawRectangle(elementReference.gui.width - window_borderSize, window_borderSize, window_borderSize, elementReference.gui.height - availableElements[elementType].minimumSize, window_color, false)
                end
                if (elementReference.gui.width > availableElements[elementType].minimumSize) and (elementReference.gui.height > availableElements[elementType].minimumSize) then
                    imports.dxDrawRectangle(window_borderSize, window_borderSize, elementReference.gui.width - availableElements[elementType].minimumSize, elementReference.gui.height - availableElements[elementType].minimumSize, window_color, false)
                end
                imports.dxDrawRectangle(0, window_borderSize, elementReference.gui.width, elementReference.gui["__UI_CACHE__"]["Window"].divider.size, elementReference.gui["__UI_CACHE__"]["Window"].divider.color, false)    
                imports.dxSetRenderTarget()
                local renderPixels = imports.dxGetTexturePixels(elementReference.gui["__UI_CACHE__"]["Window"].renderTarget)
                if renderPixels then
                    elementReference.gui["__UI_CACHE__"]["Window"].renderTexture = imports.dxCreateTexture(renderPixels, "argb", false, "clamp")
                    imports.destroyElement(elementReference.gui["__UI_CACHE__"]["Window"].renderTarget)
                    elementReference.gui["__UI_CACHE__"]["Window"].renderTarget = nil
                end
            end
            if not CLIENT_MTA_MINIMIZED then
                elementReference.gui["__UI_CACHE__"].reloadElement = nil
            end
            elementReference.gui["__UI_CACHE__"].updateElement = nil
        end

        if isActiveMode then
            if not elementReference.gui.titleBar.closeButton.animAlphaPercent then
                elementReference.gui.titleBar.closeButton.animAlphaPercent = 0
                elementReference.gui.titleBar.closeButton.hoverStatus = "backward"
                elementReference.gui.titleBar.closeButton.hoverAnimTickCounter = CLIENT_CURRENT_TICK
            end
            elementReference.gui.titleBar.closeButton.interpolationProgress = imports.getInterpolationProgress(elementReference.gui.titleBar.closeButton.hoverAnimTickCounter, availableElements[elementType].titleBar.closeButton.hoverAnimDuration)
            local isCloseButtonHoverInterpolationRendering = elementReference.gui.titleBar.closeButton.interpolationProgress < 1
            isElementToBeForceRendered = isElementToBeForceRendered or isCloseButtonHoverInterpolationRendering or (elementReference.gui.titleBar.closeButton.hoverStatus ~= "backward")
            if isElementInterpolationToBeRefreshed or isCloseButtonHoverInterpolationRendering then
                if elementReference.gui.titleBar.closeButton.hoverStatus == "forward" then
                    elementReference.gui.titleBar.closeButton.animAlphaPercent = imports.interpolateBetween(elementReference.gui.titleBar.closeButton.animAlphaPercent, 0, 0, 1, 0, 0, elementReference.gui.titleBar.closeButton.interpolationProgress, "InQuad")
                else
                    elementReference.gui.titleBar.closeButton.animAlphaPercent = imports.interpolateBetween(elementReference.gui.titleBar.closeButton.animAlphaPercent, 0, 0, 0, 0, 0, elementReference.gui.titleBar.closeButton.interpolationProgress, "InQuad")
                end
            end
        end
        if elementReference.gui["__UI_CACHE__"]["Window"].renderTexture then
            imports.dxDrawImage(elementReference.gui["__UI_CACHE__"]["Window"].offsets.startX, elementReference.gui["__UI_CACHE__"]["Window"].offsets.startY, elementReference.gui["__UI_CACHE__"]["Window"].offsets.width, elementReference.gui["__UI_CACHE__"]["Window"].offsets.height, elementReference.gui["__UI_CACHE__"]["Window"].renderTexture, 0, 0, 0, -1, elementReference.gui.postGUI)
        end
        local isCloseButtonHoverToBeRendered = elementReference.gui.titleBar.closeButton.animAlphaPercent > 0
        imports.dxDrawText(elementReference.gui["__UI_CACHE__"]["Title Bar"].text.text, elementReference.gui["__UI_CACHE__"]["Title Bar"].text.offsets.startX, elementReference.gui["__UI_CACHE__"]["Title Bar"].text.offsets.startY, elementReference.gui["__UI_CACHE__"]["Title Bar"].text.offsets.endX, elementReference.gui["__UI_CACHE__"]["Title Bar"].text.offsets.endY, elementReference.gui["__UI_CACHE__"]["Title Bar"].text.fontColor, elementTemplate.titleBar.fontScale or 1, elementTemplate.titleBar.font, "center", "center", true, false, elementReference.gui.postGUI, false)
        if isCloseButtonHoverToBeRendered then    
            imports.dxDrawImage(elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.startX, elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.startY, elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.width, elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.height, createdAssets["images"]["curved_square/regular/top_right.rw"], 0, 0, 0, imports.tocolor(elementTemplate.titleBar.closeButton.hoverColor[1], elementTemplate.titleBar.closeButton.hoverColor[2], elementTemplate.titleBar.closeButton.hoverColor[3], elementTemplate.titleBar.closeButton.hoverColor[4]*elementReference.gui.titleBar.closeButton.animAlphaPercent), elementReference.gui.postGUI)
        end
        imports.dxDrawText(elementReference.gui["__UI_CACHE__"]["Close Button"].text.text, elementReference.gui["__UI_CACHE__"]["Close Button"].text.offsets.startX, elementReference.gui["__UI_CACHE__"]["Close Button"].text.offsets.startY, elementReference.gui["__UI_CACHE__"]["Close Button"].text.offsets.endX, elementReference.gui["__UI_CACHE__"]["Close Button"].text.offsets.endY, elementReference.gui["__UI_CACHE__"]["Close Button"].text.fontColor, elementTemplate.titleBar.fontScale or 1, elementTemplate.titleBar.font, "center", "center", true, false, elementReference.gui.postGUI, false)
        if isCloseButtonHoverToBeRendered then
            imports.dxDrawText(elementReference.gui["__UI_CACHE__"]["Close Button"].text.text, elementReference.gui["__UI_CACHE__"]["Close Button"].text.offsets.startX, elementReference.gui["__UI_CACHE__"]["Close Button"].text.offsets.startY, elementReference.gui["__UI_CACHE__"]["Close Button"].text.offsets.endX, elementReference.gui["__UI_CACHE__"]["Close Button"].text.offsets.endY, imports.tocolor(elementTemplate.titleBar.closeButton.hoverFontColor[1], elementTemplate.titleBar.closeButton.hoverFontColor[2], elementTemplate.titleBar.closeButton.hoverFontColor[3], elementTemplate.titleBar.closeButton.hoverFontColor[4]*elementReference.gui.titleBar.closeButton.animAlphaPercent), elementTemplate.titleBar.fontScale or 1, elementTemplate.titleBar.font, "center", "center", true, false, elementReference.gui.postGUI, false)
        end
        imports.dxDrawRectangle(elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.startX, elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.startY, elementReference.gui["__UI_CACHE__"]["Window"].divider.size, elementReference.gui["__UI_CACHE__"]["Close Button"].offsets.height, elementReference.gui["__UI_CACHE__"]["Window"].divider.color, elementReference.gui.postGUI)
        if elementReference.gui.renderTarget and imports.isElement(elementReference.gui.renderTarget) then
            if isActiveMode then
                imports.manageElementForceRender(element, isElementToBeForceRendered)
                imports.renderElementChildren(element, isActiveMode)
                imports.dxSetRenderTarget()
            end
            imports.dxDrawImage(elementReference.gui["__UI_CACHE__"]["Window"].view.offsets.startX, elementReference.gui["__UI_CACHE__"]["Window"].view.offsets.startY, elementReference.gui["__UI_CACHE__"]["Window"].view.offsets.width, elementReference.gui["__UI_CACHE__"]["Window"].view.offsets.height, elementReference.gui.renderTarget, 0, 0, 0, -1, elementReference.gui.postGUI)
        end
    else
        local __mouseReference = {x = mouseReference.x, y = mouseReference.y}
        imports.renderElementChildren(element, isActiveMode, true, mouseReference)
        local isElementHovered = CLIENT_HOVERED_ELEMENT.element == element
        local isCloseButtonHovered = false
        if isElementHovered then
            local isTitleBarClicked = false
            if imports.isKeyClicked("mouse1") then
                isTitleBarClicked = imports.isMouseOnPosition(elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Title Bar"].startX, elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Title Bar"].startY, elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Title Bar"].width, elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Title Bar"].height)
            end
            if isTitleBarClicked then
                if not elementReference.isDisabled and elementReference.isDraggable then
                    imports.attachUIElement(element)
                end
            else
                isCloseButtonHovered = imports.isMouseOnPosition(__mouseReference.x + elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Close Button"].startX, __mouseReference.y + elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Close Button"].startY, elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Close Button"].width, elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Close Button"].height)
            end
        end
        if isCloseButtonHovered then
            if imports.isKeyClicked("mouse1") then
                imports.setUIVisible(element, false)
            end
            if elementReference.gui.titleBar.closeButton.hoverStatus ~= "forward" then
                elementReference.gui.titleBar.closeButton.hoverStatus = "forward"
                elementReference.gui.titleBar.closeButton.hoverAnimTickCounter = CLIENT_CURRENT_TICK
            end
        else
            if elementReference.gui.titleBar.closeButton.hoverStatus ~= "backward" then
                elementReference.gui.titleBar.closeButton.hoverStatus = "backward"
                elementReference.gui.titleBar.closeButton.hoverAnimTickCounter = CLIENT_CURRENT_TICK
            end
        end
    end
    return true

end