----------------------------------------------------------------
--[[ Resource: Beautify Library
     Script: handlers: element: manager.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 01/02/2021 (OvileAmriam)
     Desc: Element's Manager ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    ipairs = ipairs,
    isElement = isElement,
    getElementType = getElementType,
    addEventHandler = addEventHandler,
    createElement = createElement,
    destroyElement = destroyElement,
    collectgarbage = collectgarbage,
    table = {
        insert = table.insert,
        remove = table.remove
    }
}


-------------------
--[[ Variables ]]--
-------------------

local createdResourceElements = {}
createdElements = {}
createdRenderingPriority = {}
local createdNonParentElements = {}


-------------------------------------------------
--[[ Function: Clears Resource's UI Elements ]]--
-------------------------------------------------

local function __clearResourceUIElements(sourceResource)

    if not sourceResource or not createdResourceElements[sourceResource] then return false end

    for i, j in imports.ipairs(createdResourceElements[sourceResource]) do
        if j and imports.isElement(j) then
            imports.destroyElement(j)
        end
    end
    createdResourceElements[sourceResource] = nil
    imports.collectgarbage()
    return true

end
function clearResourceUIElements() return __clearResourceUIElements() end


-----------------------------------------
--[[ Function: Retrieves UI's Parent ]]--
-----------------------------------------

function getUIParent(element)

    if element and not createdNonParentElements[element] and createdElements[element] then
        if createdElements[element].parentElement and createdElements[(createdElements[element].parentElement)] then
            return createdElements[element].parentElement, createdElements[element].parentReference
        end
    end
    return false

end


--------------------------------------------
--[[ Function: Retrieves UI's Ancestors ]]--
--------------------------------------------

function getUIAncestors(element)

    if element and not createdNonParentElements[element] and createdElements[element] then
        return createdElements[element].renderIndexReference[(createdElements[element].renderIndex)].ancestors
    end
    return false
    
end


------------------------------------------
--[[ Function: Retrieves UI's View RT ]]--
------------------------------------------

function getUIViewRT(element)

    if element and createdElements[element] and createdElements[element].gui.renderTarget and imports.isElement(createdElements[element].gui.renderTarget) then
        return createdElements[element].gui.renderTarget
    end
    return false

end


-----------------------------------------------
--[[ Functions: Updates/Reloads UI Element ]]--
-----------------------------------------------

function updateElement(element)

    if not element or not createdElements[element] then return false end
    
    createdElements[element].gui["__UI_CACHE__"].updateElement = true
    for i, j in pairs(UI_VALID_SCROLLERS) do
        if createdElements[element].gui[i] then
            createdElements[element].gui[i].updateComponent = true
        end
    end
    imports.manageElementForceRender(element, true)
    return true

end

function reloadElement(element)

    if not element or not createdElements[element] then return false end

    createdElements[element].gui["__UI_CACHE__"].reloadElement = true
    for i, j in pairs(UI_VALID_SCROLLERS) do
        if createdElements[element].gui[i] then
            createdElements[element].gui[i].reloadComponent = true
        end
    end
    imports.manageElementForceRender(element, true)
    return true

end


------------------------------------------------
--[[ Functions: Creates/Destroys UI Element ]]--
------------------------------------------------

function createUIElement(elementType, parentElement, sourceResource)

    if not elementType or not availableElements[elementType] or not sourceResource or (sourceResource == resource) then return false end

    local createdElement = imports.createElement(elementType)
    if createdElement and imports.isElement(createdElement) then 
        local isChildElement = false
        if parentElement and imports.isElement(parentElement) then
            local parentType = imports.getElementType(parentElement)
            if availableElements[parentType] and availableElements[parentType].allowedChildren and availableElements[parentType].allowedChildren[elementType] and (createdElements[parentElement].sourceResource == sourceResource) then
                isChildElement = true
            else
                imports.destroyElement(createdElement)
                return false
            end
        end
        local renderIndexReference = false
        local elementAncestorsReference = false
        if isChildElement then
            renderIndexReference = createdElements[parentElement].renderIndexReference[(createdElements[parentElement].renderIndex)].children
            createdElements[createdElement] = {
                parentElement = parentElement,
                rootElement = createdElements[parentElement].rootElement or parentElement
            }
            createdElements[parentElement].children[createdElement] = true
            local elementAncestors = {
                ancestorIndex = {},
                ancestors = {}
            }
            local elementAncestor = parentElement
            while (elementAncestor and imports.isElement(elementAncestor)) do
                imports.table.insert(elementAncestors.ancestorIndex, elementAncestor)
                elementAncestors.ancestors[elementAncestor] = {
                    ancestorIndex = #elementAncestors.ancestorIndex
                }
                elementAncestor = createdElements[elementAncestor].parentElement
            end
            elementAncestorsReference = elementAncestors
        else
            parentElement = nil
            renderIndexReference = createdRenderingPriority
            createdElements[createdElement] = {
                rootElement = false
            }
            createdNonParentElements[createdElement] = true
        end
        imports.table.insert(renderIndexReference, {
            element = createdElement,
            ancestors = elementAncestorsReference,
            children = {}
        })
        if not createdResourceElements[sourceResource] then
            createdResourceElements[sourceResource] = {}
        end
        createdElements[createdElement].sourceResource = sourceResource
        imports.table.insert(createdResourceElements[sourceResource], createdElement)
        createdElements[createdElement].renderIndex = #renderIndexReference
        createdElements[createdElement].renderIndexReference = renderIndexReference
        createdElements[createdElement].isValid = false
        createdElements[createdElement].isVisible = false
        createdElements[createdElement].isDraggable = false
        createdElements[createdElement].isDisabled = false
        createdElements[createdElement].elementType = elementType
        createdElements[createdElement].children = {}
        return createdElement, parentElement
    end
    return false

end

local function destroyUIElement(element)

    if not element or not imports.isElement(element) or not createdElements[element] then return false end

    local parentElement = createdElements[element].parentElement
    createdElements[element].isValid = false
    imports.destroyElementForceRender(element)
    for i, j in imports.pairs(createdElements[element].children) do
        imports.destroyElement(i)
    end
    if createdElements[element].gui then
        for i, j in imports.pairs(createdElements[element].gui) do
            if i and imports.isElement(i) then
                imports.destroyElement(i)
            end
        end
    end
    imports.table.remove(createdElements[element].renderIndexReference, createdElements[element].renderIndex)
    local totalChildren = #createdElements[element].renderIndexReference
    if totalChildren >= createdElements[element].renderIndex then
        for i = createdElements[element].renderIndex, totalChildren, 1 do
            createdElements[(createdElements[element].renderIndexReference[i].element)].renderIndex = createdElements[(createdElements[element].renderIndexReference[i].element)].renderIndex - 1
            imports.manageElementForceRender(createdElements[element].renderIndexReference[i].element, true)
            updateElement(createdElements[element].renderIndexReference[i].element)
        end
    end
    createdNonParentElements[element] = nil
    if parentElement and createdElements[parentElement] then
        createdElements[parentElement].children[element] = nil
    end
    createdElements[element] = nil
    imports.destroyElement(element)
    imports.collectgarbage()
    return true

end


-----------------------------------------------
--[[ Events: On Client Resource Start/Stop ]]--
-----------------------------------------------

imports.addEventHandler("onClientResourceStart", resource, function()
    imports.destroyElementForceRender = destroyElementForceRender
    imports.manageElementForceRender = manageElementForceRender
end)

local isLibraryResourceStopping = false
imports.addEventHandler("onClientResourceStop", root, function(stoppedResource)

    if source == resource then
        isLibraryResourceStopping = true
        imports.collectgarbage()
    else
        __clearResourceUIElements(stoppedResource)
        clearResourceUITemplates(stoppedResource)
    end

end)

imports.addEventHandler("onClientElementDestroy", resourceRoot, function()

    if not isLibraryResourceStopping then
        destroyUIElement(source)
    end

end)