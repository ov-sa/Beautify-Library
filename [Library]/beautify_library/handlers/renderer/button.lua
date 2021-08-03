----------------------------------------------------------------
--[[ Resource: Beautify Library
     Script: handlers: renderer: button.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 01/02/2021 (OvileAmriam)
     Desc: Button's Renderer ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local elementType = "beautify_button"


----------------------------------
--[[ Function: Renders Button ]]--
----------------------------------

function renderButton(element, isFetchingInput, mouseReference)

    if not isFetchingInput then
        if not isUIValid(element) or (element:getType() ~= elementType) then return false end
    else
        if not mouseReference then return false end
    end

    local elementParent = getUIParent(element)
    local elementReference = createdElements[element]
    if not isFetchingInput then
        local elementTemplate = getUITemplate(elementType)
        local button_type = elementReference.gui.type
        elementTemplate = elementTemplate[button_type]
        local button_borderSize = availableElements[elementType]["TEMPLATE_PROPERTIES"][button_type].minimumSize*0.5
        local button_startX, button_startY = elementReference.gui.x, elementReference.gui.y
        local button_width, button_height = false, false
        local button_content_padding = availableElements[elementType].contentSection.paddingX
        local button_postGUI = elementReference.gui.postGUI

        if button_type == "default" then
            button_width, button_height = elementReference.gui.width, elementReference.gui.height
        end

        elementReference.gui["__UI_INPUT_FETCH_CACHE__"].startX = button_startX
        elementReference.gui["__UI_INPUT_FETCH_CACHE__"].startY = button_startY
        elementReference.gui["__UI_INPUT_FETCH_CACHE__"].width = button_width
        elementReference.gui["__UI_INPUT_FETCH_CACHE__"].height = button_height
    
        if not elementParent then dxSetRenderTarget() end
        if button_width and button_height then
            if not elementReference.gui["__UI_CACHE__"]["Content Section"] or not elementReference.gui["__UI_CACHE__"]["Content Section"].renderTexture or elementReference.gui["__UI_CACHE__"]["Content Section"].updateTexture then
                if not elementReference.gui["__UI_CACHE__"]["Content Section"] then
                    elementReference.gui["__UI_CACHE__"]["Content Section"] = {}
                end
                if not elementReference.gui["__UI_CACHE__"]["Content Section"].renderTarget then
                    elementReference.gui["__UI_CACHE__"]["Content Section"].renderTarget = DxRenderTarget(button_width, button_height, true)
                end
                if elementReference.gui["__UI_CACHE__"]["Content Section"].updateTexture then
                    if elementReference.gui["__UI_CACHE__"]["Content Section"].renderTexture and isElement(elementReference.gui["__UI_CACHE__"]["Content Section"].renderTexture) then
                        elementReference.gui["__UI_CACHE__"]["Content Section"].renderTexture:destroy()
                        elementReference.gui["__UI_CACHE__"]["Content Section"].renderTexture = nil
                    end
                end
                dxSetRenderTarget(elementReference.gui["__UI_CACHE__"]["Content Section"].renderTarget, true)
                dxSetBlendMode("modulate_add")
                local button_color = tocolor(elementTemplate.color[1], elementTemplate.color[2], elementTemplate.color[3], elementTemplate.color[4])
                dxDrawImage(0, 0, button_borderSize, button_borderSize, createdAssets["images"]["curved_square/button/top_left.png"], 0, 0, 0, button_color, false)
                dxDrawImage(button_width - button_borderSize, 0, button_borderSize, button_borderSize, createdAssets["images"]["curved_square/button/top_right.png"], 0, 0, 0, button_color, false)
                dxDrawImage(0, button_height - button_borderSize, button_borderSize, button_borderSize, createdAssets["images"]["curved_square/button/bottom_left.png"], 0, 0, 0, button_color, false)
                dxDrawImage(button_width - button_borderSize, button_height - button_borderSize, button_borderSize, button_borderSize, createdAssets["images"]["curved_square/button/bottom_right.png"], 0, 0, 0, button_color, false)
                if (button_width > availableElements[elementType]["TEMPLATE_PROPERTIES"][button_type].minimumSize) and (button_height >= availableElements[elementType]["TEMPLATE_PROPERTIES"][button_type].minimumSize) then
                    dxDrawRectangle(button_borderSize, 0, button_width - availableElements[elementType]["TEMPLATE_PROPERTIES"][button_type].minimumSize, button_height, button_color, false)
                    if button_height > availableElements[elementType]["TEMPLATE_PROPERTIES"][button_type].minimumSize then
                        dxDrawRectangle(0, button_borderSize, button_borderSize, button_height - availableElements[elementType]["TEMPLATE_PROPERTIES"][button_type].minimumSize, button_color, false)
                        dxDrawRectangle(button_width - button_borderSize, button_borderSize, button_borderSize, button_height - availableElements[elementType]["TEMPLATE_PROPERTIES"][button_type].minimumSize, button_color, false)
                    end
                end
                dxSetBlendMode("blend")
                if not elementParent then
                    dxSetRenderTarget()
                else
                    dxSetRenderTarget(createdElements[elementParent].gui.renderTarget)
                end
                local renderPixels = dxGetTexturePixels(elementReference.gui["__UI_CACHE__"]["Content Section"].renderTarget)
                if renderPixels then
                    elementReference.gui["__UI_CACHE__"]["Content Section"].renderTexture = DxTexture(renderPixels, "argb", false, "clamp")
                    elementReference.gui["__UI_CACHE__"]["Content Section"].renderTarget:destroy()
                    elementReference.gui["__UI_CACHE__"]["Content Section"].renderTarget = nil
                    elementReference.gui["__UI_CACHE__"]["Content Section"].updateTexture = nil
                end
            end

            if not elementReference.gui.animAlphaPercent then
                elementReference.gui.animAlphaPercent = 0.25
                elementReference.gui.hoverStatus = "backward"
                elementReference.gui.hoverAnimTickCounter = getTickCount()
            end
            if elementReference.gui.hoverStatus == "forward" then
                elementReference.gui.animAlphaPercent = interpolateBetween(elementReference.gui.animAlphaPercent, 0, 0, 1, 0, 0, getInterpolationProgress(elementReference.gui.hoverAnimTickCounter, availableElements[elementType].contentSection.hoverAnimDuration), "InQuad")
            else
                elementReference.gui.animAlphaPercent = interpolateBetween(elementReference.gui.animAlphaPercent, 0, 0, 0.25, 0, 0, getInterpolationProgress(elementReference.gui.hoverAnimTickCounter, availableElements[elementType].contentSection.hoverAnimDuration), "InQuad")
            end
            local button_fontColor = tocolor(elementTemplate.fontColor[1], elementTemplate.fontColor[2], elementTemplate.fontColor[3], elementTemplate.fontColor[4]*elementReference.gui.animAlphaPercent)
            if elementReference.gui["__UI_CACHE__"]["Content Section"].renderTexture then
                dxDrawImage(button_startX, button_startY, button_width, button_height, elementReference.gui["__UI_CACHE__"]["Content Section"].renderTexture, 0, 0, 0, tocolor(255, 255, 255, 255*math.max(0.3, elementReference.gui.animAlphaPercent)), button_postGUI)
            end
            dxDrawText(elementReference.gui.text, button_startX + button_content_padding, button_startY + (elementTemplate.fontPaddingY or 0), button_startX + button_width - button_content_padding, button_startY + button_height, button_fontColor, elementTemplate.fontScale or 1, elementTemplate.font, "center", "center", true, false, button_postGUI, false)
        end
    else
        local __mouseReference = {x = mouseReference.x, y = mouseReference.y}
        renderElementChildren(element, true, mouseReference)
        if elementReference.gui["__UI_INPUT_FETCH_CACHE__"].width and elementReference.gui["__UI_INPUT_FETCH_CACHE__"].height then
            local isElementHovered = CLIENT_HOVERED_ELEMENT == element
            local isButtonHovered = false
            if isElementHovered then
                if not elementReference.isDisabled then
                    isButtonHovered = isMouseOnPosition(__mouseReference.x + elementReference.gui["__UI_INPUT_FETCH_CACHE__"].startX, __mouseReference.y + elementReference.gui["__UI_INPUT_FETCH_CACHE__"].startY, elementReference.gui["__UI_INPUT_FETCH_CACHE__"].width, elementReference.gui["__UI_INPUT_FETCH_CACHE__"].height)
                end
            end
            if isButtonHovered then
                if elementReference.gui.hoverStatus ~= "forward" then
                    elementReference.gui.hoverStatus = "forward"
                    elementReference.gui.hoverAnimTickCounter = getTickCount()
                end
            else
                if elementReference.gui.hoverStatus ~= "backward" then
                    elementReference.gui.hoverStatus = "backward"
                    elementReference.gui.hoverAnimTickCounter = getTickCount()
                end
            end
        end
    end
    return true

end