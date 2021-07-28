function createCustomEdit(...)
    local edit=customedit.create(...)
    return edit
end

function editSetMasked(...)
    customedit.setMasked(...)
end

function editGetText(...)
    local edit_text=customedit.getText(...)
    return edit_text
end

function editSetText(...)
    customedit.setText(...)
end

function editSetVisible(...)
    customedit.visible(...)
end

function editMaxLength(...)
    customedit.maxLength(...)
end

function editChangePos(...)
    customedit.changePos(...)
end

function editSetProperty(...)
    customedit.property(...)
end


function destroyCustomEdit(...)
    customedit.destroy(...)
end


function editAutoDestroy(...)
    customedit.autoDestroy(...)
end