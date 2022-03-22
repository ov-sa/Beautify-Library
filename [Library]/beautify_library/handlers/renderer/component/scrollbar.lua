----------------------------------------------------------------
--[[ Resource: Beautify Library
     Script: handlers: renderer: component: scrollbar.lua
     Server: -
     Author: vStudio
     Developer: -
     DOC: 01/02/2021
     Desc: Scroll Bar's Renderer ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tocolor = tocolor,
    triggerEvent = triggerEvent,
    isKeyOnHold = isKeyOnHold,
    isMouseScrolled = isMouseScrolled,
    __getUITemplate = __getUITemplate,
    resetScrollCache = resetScrollCache,
    unpackColor = unpackColor,
    interpolateBetween = interpolateBetween,
    dxDrawRectangle = dxDrawRectangle,
    math = math
}


-------------------
--[[ Variables ]]--
-------------------

local componentType = "beautify_scrollbar"


--------------------------------------
--[[ Function: Renders Scroll Bar ]]--
--------------------------------------

function renderScrollbar(elementParent, isComponentInterpolationToBeRefreshed, isComponentToBeReloaded, isComonentToBeUpdated, renderData, referenceData, isFetchingInput, isFetchingForceRender)

    if not isFetchingInput then
        local isComponentToBeRendered, isComponentToBeForceRendered = true, false
        local isComponentInterpolationToBeRefreshed = (not isFetchingForceRender) and (isComponentInterpolationToBeRefreshed or CLIENT_MTA_RESTORED)
        local isComponentToBeReloaded = (not isFetchingForceRender) and (not CLIENT_MTA_MINIMIZED) and (isComponentToBeReloaded or referenceData.reloadComponent or (CLIENT_RESOURCE_TEMPLATE_RELOAD[(renderData.elementReference.sourceResource)] and CLIENT_RESOURCE_TEMPLATE_RELOAD[(renderData.elementReference.sourceResource)][componentType]))
        local isComonentToBeUpdated = (not isFetchingForceRender) and (isComponentToBeReloaded or isComonentToBeUpdated or referenceData.updateComponent or CLIENT_MTA_RESTORED)

        if not isComponentToBeRendered then return false end
        if isComonentToBeUpdated then
            local componentTemplate = imports.__getUITemplate(componentType, renderData.elementReference.sourceResource)
            if not referenceData["__UI_CACHE__"] then
                referenceData["__UI_CACHE__"] = {
                    ["Track"] = {
                        offsets = {}
                    },
                    ["Thumb"] = {
                        offsets = {}
                    }
                }
                referenceData["__UI_INPUT_FETCH_CACHE__"] = {
                    ["Track"] = {}
                }
            end
            if referenceData.isHorizontal then
                referenceData["__UI_CACHE__"]["Track"].offsets.width = renderData.width
                referenceData["__UI_CACHE__"]["Track"].offsets.height = componentTemplate.size
                referenceData["__UI_CACHE__"]["Track"].offsets.startX = renderData.startX
                referenceData["__UI_CACHE__"]["Track"].offsets.startY = renderData.startY - referenceData["__UI_CACHE__"]["Track"].offsets.height
                referenceData["__UI_CACHE__"]["Thumb"].offsets.width = imports.math.max(imports.math.min(referenceData["__UI_CACHE__"]["Track"].offsets.width*0.5, componentTemplate.thumb.minSize), (referenceData["__UI_CACHE__"]["Track"].offsets.width/(referenceData["__UI_CACHE__"]["Track"].offsets.width + renderData.overflownSize))*referenceData["__UI_CACHE__"]["Track"].offsets.width)
                referenceData["__UI_CACHE__"]["Thumb"].offsets.height = referenceData["__UI_CACHE__"]["Track"].offsets.height                
                referenceData["__UI_CACHE__"]["Thumb"].offsets.startX = 0
                referenceData["__UI_CACHE__"]["Thumb"].offsets.startY = referenceData["__UI_CACHE__"]["Track"].offsets.startY
                referenceData["__UI_INPUT_FETCH_CACHE__"]["Track"].width = referenceData["__UI_CACHE__"]["Track"].offsets.width
                referenceData.finalThumbSize = referenceData["__UI_CACHE__"]["Thumb"].offsets.width
            else
                referenceData["__UI_CACHE__"]["Track"].offsets.width = componentTemplate.size
                referenceData["__UI_CACHE__"]["Track"].offsets.height = renderData.height
                referenceData["__UI_CACHE__"]["Track"].offsets.startX = renderData.startX - referenceData["__UI_CACHE__"]["Track"].offsets.width
                referenceData["__UI_CACHE__"]["Track"].offsets.startY = renderData.startY
                referenceData["__UI_CACHE__"]["Thumb"].offsets.width = referenceData["__UI_CACHE__"]["Track"].offsets.width
                referenceData["__UI_CACHE__"]["Thumb"].offsets.height = imports.math.max(imports.math.min(referenceData["__UI_CACHE__"]["Track"].offsets.height*0.5, componentTemplate.thumb.minSize), (referenceData["__UI_CACHE__"]["Track"].offsets.height/(referenceData["__UI_CACHE__"]["Track"].offsets.height + renderData.overflownSize))*referenceData["__UI_CACHE__"]["Track"].offsets.height)
                referenceData["__UI_CACHE__"]["Thumb"].offsets.startX = referenceData["__UI_CACHE__"]["Track"].offsets.startX
                referenceData["__UI_CACHE__"]["Thumb"].offsets.startY = 0
                referenceData["__UI_INPUT_FETCH_CACHE__"]["Track"].height = referenceData["__UI_CACHE__"]["Track"].offsets.height
                referenceData.finalThumbSize = referenceData["__UI_CACHE__"]["Thumb"].offsets.height
            end
            referenceData["__UI_CACHE__"]["Thumb"].shadowSize = componentTemplate.thumb.shadowSize
            if isComponentToBeReloaded then
                referenceData["__UI_CACHE__"]["Thumb"].animAcceleration = 0.25 + (componentTemplate.thumb.animAcceleration*0.1)
                referenceData["__UI_CACHE__"]["Thumb"].scrollAcceleration = 0.25 + (componentTemplate.thumb.scrollAcceleration*0.1)
                referenceData["__UI_CACHE__"]["Track"].color = imports.tocolor(imports.unpackColor(componentTemplate.track.color))
                referenceData["__UI_CACHE__"]["Thumb"].color = imports.tocolor(imports.unpackColor(componentTemplate.thumb.color))
                referenceData["__UI_CACHE__"]["Thumb"].shadowColor = imports.tocolor(imports.unpackColor(componentTemplate.thumb.shadowColor))
            end
            isComponentInterpolationToBeRefreshed = isComponentInterpolationToBeRefreshed or true
            if not CLIENT_MTA_MINIMIZED then
                referenceData.reloadComponent = nil
            end
            referenceData.updateComponent = nil
        end

        local isScrollThumbInterpolationRendering = imports.math.round(referenceData.currentThumbSize, 0) ~= imports.math.round(referenceData.finalThumbSize, 0)
        if isComponentInterpolationToBeRefreshed or isScrollThumbInterpolationRendering then
            isComponentToBeForceRendered = isScrollThumbInterpolationRendering
            if not isFetchingForceRender then
                referenceData.currentThumbSize = imports.interpolateBetween(referenceData.currentThumbSize, 0, 0, referenceData.finalThumbSize, 0, 0, referenceData["__UI_CACHE__"]["Thumb"].animAcceleration, "InQuad")
            end
        end
        local isScrollInterpolationDone = imports.math.round(referenceData.currentPercent, 2) == imports.math.round(referenceData.finalPercent, 2)
        if isComponentInterpolationToBeRefreshed or (not isScrollInterpolationDone) then
            isComponentToBeForceRendered = isComponentToBeForceRendered or not isScrollInterpolationDone
            if not isFetchingForceRender then
                referenceData.currentPercent = imports.interpolateBetween(referenceData.currentPercent, 0, 0, referenceData.finalPercent, 0, 0, referenceData["__UI_CACHE__"]["Thumb"].scrollAcceleration, "InQuad")
                if referenceData.isHorizontal then
                    referenceData["__UI_CACHE__"]["Thumb"].offsets.startX = imports.math.max(referenceData["__UI_CACHE__"]["Track"].offsets.startX, referenceData["__UI_CACHE__"]["Track"].offsets.startX + (referenceData["__UI_CACHE__"]["Track"].offsets.width - referenceData["__UI_CACHE__"]["Thumb"].offsets.width)*(referenceData.currentPercent*0.01))
                else
                    referenceData["__UI_CACHE__"]["Thumb"].offsets.startY = imports.math.max(referenceData["__UI_CACHE__"]["Track"].offsets.startY, referenceData["__UI_CACHE__"]["Track"].offsets.startY + (referenceData["__UI_CACHE__"]["Track"].offsets.height - referenceData["__UI_CACHE__"]["Thumb"].offsets.height)*(referenceData.currentPercent*0.01))
                end
            end
        end
        if isFetchingForceRender then return isComponentToBeForceRendered end

        local scrollbar_thumb_size = referenceData.currentThumbSize
        imports.dxDrawRectangle(referenceData["__UI_CACHE__"]["Track"].offsets.startX, referenceData["__UI_CACHE__"]["Track"].offsets.startY, referenceData["__UI_CACHE__"]["Track"].offsets.width, referenceData["__UI_CACHE__"]["Track"].offsets.height, referenceData["__UI_CACHE__"]["Track"].color, renderData.postGUI)
        if referenceData.isHorizontal then
            imports.dxDrawRectangle(referenceData["__UI_CACHE__"]["Thumb"].offsets.startX, referenceData["__UI_CACHE__"]["Thumb"].offsets.startY, scrollbar_thumb_size, referenceData["__UI_CACHE__"]["Track"].offsets.height, referenceData["__UI_CACHE__"]["Thumb"].color, renderData.postGUI)
            imports.dxDrawRectangle(referenceData["__UI_CACHE__"]["Thumb"].offsets.startX, referenceData["__UI_CACHE__"]["Thumb"].offsets.startY, scrollbar_thumb_size, referenceData["__UI_CACHE__"]["Thumb"].shadowSize, referenceData["__UI_CACHE__"]["Thumb"].shadowColor, renderData.postGUI)
        else
            imports.dxDrawRectangle(referenceData["__UI_CACHE__"]["Thumb"].offsets.startX, referenceData["__UI_CACHE__"]["Thumb"].offsets.startY, referenceData["__UI_CACHE__"]["Track"].offsets.width, referenceData.currentThumbSize, referenceData["__UI_CACHE__"]["Thumb"].color, renderData.postGUI)
            imports.dxDrawRectangle(referenceData["__UI_CACHE__"]["Thumb"].offsets.startX, referenceData["__UI_CACHE__"]["Thumb"].offsets.startY, referenceData["__UI_CACHE__"]["Thumb"].shadowSize, scrollbar_thumb_size, referenceData["__UI_CACHE__"]["Thumb"].shadowColor, renderData.postGUI)
        end
        return true, isComponentToBeForceRendered
    else
        if not renderData.isDisabled then
            local scroll_state, scroll_streak = imports.isMouseScrolled()
            if referenceData.isHorizontal then
                if not imports.isKeyOnHold("lshift") then
                    scroll_state = false
                end
            end
            if scroll_state then
                local scrollbar_scrollAcceleration = (renderData.multiplier/renderData.overflownSize)*100
                if referenceData.isHorizontal then
                    if renderData.overflownSize < referenceData["__UI_INPUT_FETCH_CACHE__"]["Track"].width then
                        scrollbar_scrollAcceleration = scrollbar_scrollAcceleration*(renderData.overflownSize/referenceData["__UI_INPUT_FETCH_CACHE__"]["Track"].width)
                    end
                else
                    if renderData.overflownSize < referenceData["__UI_INPUT_FETCH_CACHE__"]["Track"].height then
                        scrollbar_scrollAcceleration = scrollbar_scrollAcceleration*(renderData.overflownSize/referenceData["__UI_INPUT_FETCH_CACHE__"]["Track"].height)
                    end
                end
                if scroll_state == "up" then
                    if referenceData.finalPercent > 0 then
                        referenceData.finalPercent = referenceData.finalPercent - (scrollbar_scrollAcceleration*scroll_streak)
                    end
                elseif scroll_state == "down" then
                    if referenceData.finalPercent < 100 then
                        referenceData.finalPercent = referenceData.finalPercent + (scrollbar_scrollAcceleration*scroll_streak)
                    end
                end
                referenceData.finalPercent = imports.math.max(0, imports.math.min(100, referenceData.finalPercent))
                imports.resetScrollCache()
                imports.triggerEvent("onClientUIScroll", elementParent, (referenceData.isHorizontal and ((scroll_state == "up" and "left") or "right")) or scroll_state)
            end
        end
    end
    return true

end