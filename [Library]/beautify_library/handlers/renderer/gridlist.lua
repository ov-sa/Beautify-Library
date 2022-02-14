----------------------------------------------------------------
--[[ Resource: Beautify Library
     Script: handlers: renderer: gridlist.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 01/02/2021 (OvileAmriam)
     Desc: Grid List's Renderer ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    tocolor = tocolor,
    isElement = isElement,
    isKeyClicked = isKeyClicked,
    getUIParent = getUIParent,
    __getUITemplate = __getUITemplate,
    manageElementForceRender = manageElementForceRender,
    renderScrollbar = renderScrollbar,
    setGridlistSelection = setGridlistSelection,
    unpackColor = unpackColor,
    isMouseOnPosition = isMouseOnPosition,
    getInterpolationProgress = getInterpolationProgress,
    interpolateBetween = interpolateBetween,
    dxSetRenderTarget = dxSetRenderTarget,
    dxSetBlendMode = dxSetBlendMode,
    dxDrawImage = dxDrawImage,
    dxDrawRectangle = dxDrawRectangle,
    dxDrawText = dxDrawText,
    math = math
}


-------------------
--[[ Variables ]]--
-------------------

local elementType = "beautify_gridlist"


-------------------------------------
--[[ Function: Renders Grid List ]]--
-------------------------------------

function renderGridlist(element, isActiveMode, isFetchingInput, mouseReference)

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
            if not elementReference.gui["__UI_CACHE__"]["Gridlist"] then
                elementReference.gui["__UI_CACHE__"]["Gridlist"] = {
                    offsets = {},
                    view = {
                        offsets = {}
                    }
                }
                elementReference.gui["__UI_CACHE__"]["Grid Columns"] = {
                    offsets = {},
                    divider = {}
                }
                elementReference.gui["__UI_CACHE__"]["Grid Rows"] = {
                    offsets = {}
                }
                elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Grid View"] = {}
            end
            elementReference.gui["__UI_CACHE__"]["Gridlist"].startX = elementReference.gui.x
            elementReference.gui["__UI_CACHE__"]["Gridlist"].startY = elementReference.gui.y
            elementReference.gui["__UI_CACHE__"]["Gridlist"].width = elementReference.gui.width
            elementReference.gui["__UI_CACHE__"]["Gridlist"].height = elementReference.gui.height
            elementReference.gui["__UI_CACHE__"]["Gridlist"].view.offsets.startX = elementReference.gui["__UI_CACHE__"]["Gridlist"].startX + elementReference.gui.viewSection.startX
            elementReference.gui["__UI_CACHE__"]["Gridlist"].view.offsets.startY = elementReference.gui["__UI_CACHE__"]["Gridlist"].startY + elementReference.gui.viewSection.startY
            elementReference.gui["__UI_CACHE__"]["Gridlist"].view.offsets.width = elementReference.gui.viewSection.width
            elementReference.gui["__UI_CACHE__"]["Gridlist"].view.offsets.height = elementReference.gui.viewSection.height
            elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Grid View"].width = elementReference.gui["__UI_CACHE__"]["Gridlist"].view.offsets.width 
            elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Grid View"].height = elementReference.gui["__UI_CACHE__"]["Gridlist"].view.offsets.height
            elementReference.gui["__UI_CACHE__"]["Grid Columns"].height = availableElements[elementType].columnBar.height
            elementReference.gui["__UI_CACHE__"]["Grid Columns"].padding = availableElements[elementType].columnBar.padding
            elementReference.gui["__UI_CACHE__"]["Grid Rows"].height = availableElements[elementType].rowBar.height
            elementReference.gui["__UI_CACHE__"]["Grid Rows"].padding = availableElements[elementType].rowBar.padding
            if isElementToBeReloaded then
                elementReference.gui["__UI_CACHE__"]["Gridlist"].color = imports.tocolor(imports.unpackColor(elementTemplate.color))
                elementReference.gui["__UI_CACHE__"]["Grid Columns"].divider.size = elementTemplate.columnBar.divider.size
                elementReference.gui["__UI_CACHE__"]["Grid Columns"].color = imports.tocolor(imports.unpackColor(elementTemplate.columnBar.color))
                elementReference.gui["__UI_CACHE__"]["Grid Columns"].fontColor = imports.tocolor(imports.unpackColor(elementTemplate.columnBar.fontColor))
                elementReference.gui["__UI_CACHE__"]["Grid Columns"].divider.color = imports.tocolor(imports.unpackColor(elementTemplate.columnBar.divider.color))
                elementReference.gui["__UI_CACHE__"]["Grid Rows"].color = imports.tocolor(imports.unpackColor(elementTemplate.rowBar.color))
                elementReference.gui["__UI_CACHE__"]["Grid Rows"].fontColor = imports.tocolor(imports.unpackColor(elementTemplate.rowBar.fontColor))
                elementReference.gui["__UI_CACHE__"]["Grid Columns"].offsets = {}
                for i, j in ipairs(elementReference.gridData.columns) do
                    local gridlist_column_offsetX = ((elementReference.gui["__UI_CACHE__"]["Grid Columns"].offsets[i - 1] and elementReference.gui["__UI_CACHE__"]["Grid Columns"].offsets[i - 1].endX) or 0) + elementReference.gui["__UI_CACHE__"]["Grid Columns"].divider.size
                    elementReference.gui["__UI_CACHE__"]["Grid Columns"].offsets[i] = {
                        startX = gridlist_column_offsetX,
                        endX = gridlist_column_offsetX + j.width + elementReference.gui["__UI_CACHE__"]["Grid Columns"].divider.size,
                        text = {
                            offsets = {}
                        }
                    }
                    elementReference.gui["__UI_CACHE__"]["Grid Columns"].offsets[i].text.offsets.startX = elementReference.gui["__UI_CACHE__"]["Grid Columns"].offsets[i].startX + elementReference.gui["__UI_CACHE__"]["Grid Columns"].padding
                    elementReference.gui["__UI_CACHE__"]["Grid Columns"].offsets[i].text.offsets.endX = elementReference.gui["__UI_CACHE__"]["Grid Columns"].offsets[i].endX - elementReference.gui["__UI_CACHE__"]["Grid Columns"].padding            
                end
            end
            if not CLIENT_MTA_MINIMIZED then
                elementReference.gui["__UI_CACHE__"].reloadElement = nil
            end
            elementReference.gui["__UI_CACHE__"].updateElement = nil
        end

        if isActiveMode then
            elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Scroll Bars"] = {}
            elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Grid Rows"] = {}
        end
        imports.dxDrawRectangle(elementReference.gui["__UI_CACHE__"]["Gridlist"].startX, elementReference.gui["__UI_CACHE__"]["Gridlist"].startY, elementReference.gui["__UI_CACHE__"]["Gridlist"].width, elementReference.gui["__UI_CACHE__"]["Gridlist"].height, elementReference.gui["__UI_CACHE__"]["Gridlist"].color, elementReference.gui.postGUI)
        local gridlist_row_count, gridlist_column_count = #elementReference.gridData.rows, #elementReference.gridData.columns
        if elementReference.gui.renderTarget and imports.isElement(elementReference.gui.renderTarget) then
            if isActiveMode then
                imports.dxSetRenderTarget(elementReference.gui.renderTarget, true)
                imports.dxSetBlendMode("modulate_add")
                if gridlist_row_count > 0 then
                    local gridlist_selection = elementReference.gridData.selection
                    local gridlist_scrolled_offsetY = 0
                    local gridlist_row_occupiedSpace = elementReference.gui["__UI_CACHE__"]["Grid Rows"].height + elementReference.gui["__UI_CACHE__"]["Grid Rows"].padding
                    local gridlist_row_maxRenderered = imports.math.ceil(elementReference.gui["__UI_CACHE__"]["Gridlist"].view.offsets.height/gridlist_row_occupiedSpace)
                    local gridlist_data_height = (gridlist_row_occupiedSpace)*(gridlist_row_count) + elementReference.gui["__UI_CACHE__"]["Grid Rows"].padding
                    local gridlist_exceeded_height = gridlist_data_height - elementReference.gui["__UI_CACHE__"]["Gridlist"].view.offsets.height
                    if gridlist_exceeded_height > 0 then gridlist_scrolled_offsetY = gridlist_exceeded_height*elementReference.gui.scrollBar_Vertical.currentPercent*0.01 end
                    local gridlist_row_startIndex = imports.math.floor(gridlist_scrolled_offsetY/gridlist_row_occupiedSpace) + 1
                    local gridlist_row_endIndex = imports.math.min(gridlist_row_count, gridlist_row_startIndex + gridlist_row_maxRenderered)
                    elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Grid Rows"].startIndex = gridlist_row_startIndex
                    elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Grid Rows"].endIndex = gridlist_row_endIndex
                    for i = gridlist_row_startIndex, gridlist_row_endIndex, 1 do
                        local j = elementReference.gridData.rows[i]
                        local row_offsetX, row_offsetY = 0, gridlist_row_occupiedSpace*(i - 1) + elementReference.gui["__UI_CACHE__"]["Grid Rows"].padding - gridlist_scrolled_offsetY
                        elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Grid Rows"][i] = {}
                        elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Grid Rows"][i].startX = elementReference.gui["__UI_CACHE__"]["Gridlist"].view.offsets.startX + row_offsetX
                        elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Grid Rows"][i].startY = elementReference.gui["__UI_CACHE__"]["Gridlist"].view.offsets.startY + row_offsetY
                        if not j.animAlphaPercent then
                            j.animAlphaPercent = 0
                            j.hoverStatus = "backward"
                            j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                        end
                        j.interpolationProgress = imports.getInterpolationProgress(j.hoverAnimTickCounter, availableElements[elementType].rowBar.hoverAnimDuration)
                        local isRowHoverInterpolationRendering = j.interpolationProgress < 1
                        isElementToBeForceRendered = isElementToBeForceRendered or isRowHoverInterpolationRendering or (gridlist_selection ~= i and j.hoverStatus ~= "backward")
                        if isElementInterpolationToBeRefreshed or isRowHoverInterpolationRendering then
                            if j.hoverStatus == "forward" then
                                j.animAlphaPercent = imports.interpolateBetween(j.animAlphaPercent, 0, 0, 1, 0, 0, j.interpolationProgress, "OutBounce")
                            else
                                j.animAlphaPercent = imports.interpolateBetween(j.animAlphaPercent, 0, 0, 0, 0, 0, j.interpolationProgress, "OutBounce")
                            end
                        end
                        imports.dxDrawRectangle(row_offsetX, row_offsetY, elementReference.gui["__UI_CACHE__"]["Gridlist"].view.offsets.width, elementReference.gui["__UI_CACHE__"]["Grid Rows"].height, elementReference.gui["__UI_CACHE__"]["Grid Rows"].color, false)
                        if j.animAlphaPercent > 0  then
                            imports.dxDrawRectangle(row_offsetX, row_offsetY, elementReference.gui["__UI_CACHE__"]["Gridlist"].view.offsets.width, elementReference.gui["__UI_CACHE__"]["Grid Rows"].height, imports.tocolor(elementTemplate.rowBar.hoverColor[1], elementTemplate.rowBar.hoverColor[2], elementTemplate.rowBar.hoverColor[3], elementTemplate.rowBar.hoverColor[4]*j.animAlphaPercent), false)
                        end
                        for k = 1, gridlist_column_count, 1 do
                            local v = elementReference.gridData.columns[k]
                            local gridlist_column_text = j[k] or "-"
                            local gridlist_column_startX, gridlist_column_startY = row_offsetX + elementReference.gui["__UI_CACHE__"]["Grid Columns"].offsets[k].text.offsets.startX, row_offsetY + (elementTemplate.rowBar.fontPaddingY or 0)
                            local gridlist_column_endX, gridlist_column_endY = row_offsetX + elementReference.gui["__UI_CACHE__"]["Grid Columns"].offsets[k].text.offsets.endX, row_offsetY + elementReference.gui["__UI_CACHE__"]["Grid Rows"].height
                            imports.dxDrawText(gridlist_column_text, gridlist_column_startX, gridlist_column_startY, gridlist_column_endX, gridlist_column_endY, elementReference.gui["__UI_CACHE__"]["Grid Rows"].fontColor, elementTemplate.rowBar.fontScale or 1, elementTemplate.rowBar.font, "center", "center", true, false, false, false)
                            if j.animAlphaPercent > 0 then
                                imports.dxDrawText(gridlist_column_text, gridlist_column_startX, gridlist_column_startY, gridlist_column_endX, gridlist_column_endY, imports.tocolor(elementTemplate.rowBar.hoverFontColor[1], elementTemplate.rowBar.hoverFontColor[2], elementTemplate.rowBar.hoverFontColor[3], elementTemplate.rowBar.hoverFontColor[4]*j.animAlphaPercent), elementTemplate.rowBar.fontScale or 1, elementTemplate.rowBar.font, "center", "center", true, false, false, false)
                            end
                        end
                    end
                    if gridlist_exceeded_height > 0 then
                        elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Scroll Bars"]["Vertical"] = {
                            {
                                isDisabled = elementReference.isDisabled,
                                elementReference = elementReference,
                                startX = elementReference.gui["__UI_CACHE__"]["Gridlist"].view.offsets.width,
                                startY = 0,
                                height = elementReference.gui["__UI_CACHE__"]["Gridlist"].view.offsets.height,
                                overflownSize = gridlist_exceeded_height,
                                multiplier = gridlist_row_occupiedSpace,
                                postGUI = false
                            },
                            elementReference.gui.scrollBar_Vertical
                        }
                        local _, isComponentToBeForceRendered = imports.renderScrollbar(element, false, false, false, elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Scroll Bars"]["Vertical"][1], elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Scroll Bars"]["Vertical"][2])
                        isElementToBeForceRendered = isElementToBeForceRendered or isComponentToBeForceRendered
                    end
                end
                imports.manageElementForceRender(element, isElementToBeForceRendered)
                if not elementParent then
                    imports.dxSetRenderTarget()
                else
                    imports.dxSetRenderTarget(createdElements[elementParent].gui.renderTarget)
                end
            end
            imports.dxDrawImage(elementReference.gui["__UI_CACHE__"]["Gridlist"].view.offsets.startX, elementReference.gui["__UI_CACHE__"]["Gridlist"].view.offsets.startY, elementReference.gui["__UI_CACHE__"]["Gridlist"].view.offsets.width, elementReference.gui["__UI_CACHE__"]["Gridlist"].view.offsets.height, elementReference.gui.renderTarget, 0, 0, 0, -1, elementReference.gui.postGUI)    
        end
        imports.dxDrawRectangle(elementReference.gui["__UI_CACHE__"]["Gridlist"].startX, elementReference.gui["__UI_CACHE__"]["Gridlist"].startY, elementReference.gui["__UI_CACHE__"]["Gridlist"].width, elementReference.gui["__UI_CACHE__"]["Grid Columns"].height, elementReference.gui["__UI_CACHE__"]["Grid Columns"].color, elementReference.gui.postGUI)
        imports.dxDrawRectangle(elementReference.gui["__UI_CACHE__"]["Gridlist"].startX, elementReference.gui["__UI_CACHE__"]["Gridlist"].startY + elementReference.gui["__UI_CACHE__"]["Grid Columns"].height, elementReference.gui["__UI_CACHE__"]["Gridlist"].width, elementReference.gui["__UI_CACHE__"]["Grid Columns"].divider.size, elementReference.gui["__UI_CACHE__"]["Grid Columns"].divider.color, elementReference.gui.postGUI)
        for i = 1, gridlist_column_count, 1 do
            local j = elementReference.gridData.columns[i]
            if i ~= gridlist_column_count then
                imports.dxDrawRectangle(elementReference.gui["__UI_CACHE__"]["Gridlist"].startX + elementReference.gui["__UI_CACHE__"]["Grid Columns"].offsets[i].startX + j.width + elementReference.gui["__UI_CACHE__"]["Grid Columns"].divider.size, elementReference.gui["__UI_CACHE__"]["Gridlist"].startY + elementReference.gui["__UI_CACHE__"]["Grid Columns"].height, elementReference.gui["__UI_CACHE__"]["Grid Columns"].divider.size, elementReference.gui["__UI_CACHE__"]["Gridlist"].height - elementReference.gui["__UI_CACHE__"]["Grid Columns"].height, elementReference.gui["__UI_CACHE__"]["Grid Columns"].divider.color, elementReference.gui.postGUI)
            end
            imports.dxDrawText(j.name, elementReference.gui["__UI_CACHE__"]["Gridlist"].startX + elementReference.gui["__UI_CACHE__"]["Grid Columns"].offsets[i].startX + elementReference.gui["__UI_CACHE__"]["Grid Columns"].padding, elementReference.gui["__UI_CACHE__"]["Gridlist"].startY + elementReference.gui["__UI_CACHE__"]["Grid Columns"].padding + (elementTemplate.columnBar.fontPaddingY or 0), elementReference.gui["__UI_CACHE__"]["Gridlist"].startX + elementReference.gui["__UI_CACHE__"]["Grid Columns"].offsets[i].endX - elementReference.gui["__UI_CACHE__"]["Grid Columns"].padding, elementReference.gui["__UI_CACHE__"]["Gridlist"].startY + elementReference.gui["__UI_CACHE__"]["Grid Columns"].height, elementReference.gui["__UI_CACHE__"]["Grid Columns"].fontColor, elementTemplate.columnBar.fontScale or 1, elementTemplate.columnBar.font, "center", "center", true, false, elementReference.gui.postGUI, false)
        end
    else
        local __mouseReference = {x = mouseReference.x, y = mouseReference.y}
        local gridlist_row_count = #elementReference.gridData.rows
        if gridlist_row_count > 0 then
            local isElementHovered = CLIENT_HOVERED_ELEMENT.element == element
            local isGridListHovered = false
            local gridlist_selection = elementReference.gridData.selection
            if isElementHovered then
                local isGridViewAnimating = imports.math.round(elementReference.gui.scrollBar_Vertical.currentPercent, 2) ~= imports.math.round(elementReference.gui.scrollBar_Vertical.finalPercent or 0, 2)
                if not elementReference.isDisabled and not isGridViewAnimating then
                    isGridListHovered = true
                end
            end
            for i = elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Grid Rows"].startIndex, elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Grid Rows"].endIndex, 1 do
                local j = elementReference.gridData.rows[i]
                local isRowHovered = false
                if isGridListHovered then
                    isRowHovered = imports.isMouseOnPosition(__mouseReference.x + elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Grid Rows"][i].startX, __mouseReference.y + elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Grid Rows"][i].startY, elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Grid View"].width, elementReference.gui["__UI_CACHE__"]["Grid Rows"].height)
                end
                if isRowHovered or (gridlist_selection == i) then
                    if imports.isKeyClicked("mouse1") and (gridlist_selection ~= i) then
                        imports.setGridlistSelection(element, i)
                    end
                    if j.hoverStatus ~= "forward" then
                        j.hoverStatus = "forward"
                        j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                    end
                    if isRowHovered then
                        prevRowHoverState = i
                    end
                else
                    if j.hoverStatus ~= "backward" then
                        j.hoverStatus = "backward"
                        j.hoverAnimTickCounter = CLIENT_CURRENT_TICK
                    end
                end
            end
            if isElementHovered and elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Scroll Bars"]["Vertical"] then
                imports.renderScrollbar(element, false, false, false, elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Scroll Bars"]["Vertical"][1], elementReference.gui["__UI_INPUT_FETCH_CACHE__"]["Scroll Bars"]["Vertical"][2], true)
            end
        end
    end
    return true

end