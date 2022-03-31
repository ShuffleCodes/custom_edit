local keys = {
    ["0"] = true, 
    ["1"] = true, 
    ["2"] = true, 
    ["3"] = true, 
    ["4"] = true, 
    ["5"] = true, 
    ["6"] = true, 
    ["7"] = true, 
    ["8"] = true, 
    ["9"] = true, 
    ["q"] = true, 
    ["w"] = true, 
    ["e"] = true, 
    ["r"] = true, 
    ["t"] = true, 
    ["z"] = true, 
    ["u"] = true, 
    ["i"] = true, 
    ["o"] = true, 
    ["p"] = true, 
    ["ő"] = true, 
    ["ú"] = true, 
    ["ö"] = true, 
    ["ü"] = true, 
    ["ó"] = true, 
    ["a"] = true, 
    ["s"] = true, 
    ["d"] = true, 
    ["f"] = true,  
    ["g"] = true, 
    ["h"] = true, 
    ["j"] = true, 
    ["k"] = true, 
    ["l"] = true, 
    ["é"] = true, 
    ["á"] = true, 
    ["ű"] = true, 
    ["í"] = true, 
    ["y"] = true, 
    ["x"] = true, 
    ["c"] = true, 
    ["v"] = true, 
    ["b"] = true, 
    ["n"] = true, 
    ["m"] = true, 
    [","] = true, 
    ["."] = true, 
    ["-"] = true, 
    ["!"] = true, 
    ["?"] = true, 
    ["#"] = true, 
    ["&"] = true, 
    ["@"] = true, 
    ["$"] = true, 
    ["'"] = true, 
    ["\""] = true, 
    ["%"] = true, 
    ["+"] = true, 
    ["="] = true, 
    ["("] = true, 
    [")"] = true, 
    ["~"] = true,
    ["ł"] = true,
    ["ć"] = true,
    ["ź"] = true,
    ["ż"] = true,
    ["ą"] = true,
    [" "] = true,
    ["/"] = true,
    ["_"] = true,
}


local events={
    "onCustomEditFocus",
    "onCustomEditLeave",
    "onCustomEditType",
}

for i=1,#events do
    addEvent(events[i],true) 
end 

function customedit.validChar (char)
    if (keys[string.lower(char)]) then
        return true
    else
        return false
    end
end

function isMouseInPosition (x, y, width, height)
    if (not isCursorShowing()) then
          return false
     end
    local cx, cy = getCursorPosition ()
    local cx, cy = (cx * s["x"]), (cy * s["y"])
    return ((cx >= x and cx <= x + width) and (cy >= y and cy <= y + height))
end


function customedit.active()
    for k,v in ipairs(edits)do
        if v["active"] then
            return k
        end
    end
    return false
end




function customedit.freeID()
    if #edits==0 then
        return 1
    end
    local count=0
    local rnd=math.random(1,1000)
    for _,v in ipairs(edits)do
        if rnd==v["id"] then
            count=count+1
        end
    end
    if count>0 then
        customedit.freeID()
    elseif count==0 then
        return rnd
    end
end


edit={}

function customedit.create(txt,x,y,w,h,postgui,placeholder,masked,font,activecolor,fontcolor,bgcolor,caret,visible,length,fontsize,blockspace)
    if postgui~=true and postgui~=false then
        postgui=false
    end
    if not fontsize then
        variable.size=h/1.5
    else
        variable.size=fontsize
    end
    if not font then
        font="arial"
    else
        font=dxCreateFont("fonts/"..font..".ttf",(variable.size/1920)*s.x)
    end
    if placeholder then
        variable.testWidth=dxGetTextWidth(placeholder,1,font,false)
        if variable.testWidth > w-(10/1920)*s.x then
            placeholder=false
            outputDebugString("Placeholder is too long for this edit",1)
        end
    end
    if not activecolor then
        activecolor={255,0,0,255}
    end
    if not fontcolor then
        fontcolor={255,255,255,255}
    end
    if not bgcolor then
        bgcolor={0,0,0,255}
    end
    if not caret then
        caret={255,255,255,255}
    end
    if not length then
        length=40
    end
    if not visible and visible~=false then
        visible=true
    end
    if not blockspace then
        blockspace=false
    end
    variable.id=customedit.freeID()
    --table.insert(resources,{id=variable.id,resource=getResourceName(sourceResource)})
    table.insert(edits,{
        id=variable.id,
        txt=txt or "",
        x=x,
        y=y,
        w=w,
        h=h,
        resource=sourceResource,
        postgui=postgui,
        placeholder=placeholder,
        masked=masked or false,
        font=font,
        size=variable.size,
        active=false,
        activecolor=activecolor,
        fontcolor=fontcolor,
        bgcolor=bgcolor,
        caret=caret,
        visible=visible,
        cursor=0,
        maxLength=length,
        click=0,
        alpha=0,
        readOnly=false,
        blockspace=blockspace,
    })
    return variable.id
end


function customedit.isactive(edit)
    for k,v in ipairs(edits)do
        if v["active"] then
            if k==edit then
                return true
            end
        end
    end
    return false
end

function customedit.getActive()
    for k,v in ipairs(edits)do
        if v["active"] then
            return k
        end
    end
    return false
end



function customedit.convertMasked(string)
    variable.lenght=string.len(string)
    return string.rep("*",variable.lenght)
end

function customedit.setMasked(edit,masked)
    if edit then
        for k,v in ipairs(edits)do
            if v["id"]==edit then
                edits[k]["masked"]=masked
                return true
            end
        end
    end
    return false
end


function customedit.getText(edit)
    if edit then
        for k,v in ipairs(edits)do
            if v["id"]==edit then
                return v["txt"]
            end
        end
        return ""
    end
end


function customedit.getLength(edit)
    if edit then
        for k,v in ipairs(edits)do
            if v["id"]==edit then
                return string.len(v["txt"])
            end
        end
        return ""
    end
end

function customedit.setText(edit,txt)
    if edit then
        if txt then
            for k,v in ipairs(edits)do
                if v["id"]==edit then
                    v["txt"]=txt
                    return true
                end
            end
        end
    end
    return false
end

function customedit.destroy(edit)
    if edit then
        for k,v in ipairs(edits)do
            if v["id"]==edit then
                table.remove(edits,k)
                return true
            end
        end
    end
    return false
end




--[[function customedit.setCaretColor(edit,color)
    if edit and color then
        if type(color)=="table" then
            for k,v in ipairs(edits)do
                if k==edit then
                    v["caret"]=color
                end
            end
        end
    end
end]]--

function customedit.visible(edit,state)
    if edit then
        if state==true or state==false then
            for k,v in ipairs(edits)do
                if v["id"]==edit then
                    v["visible"]=state
                    return true
                end
            end
        end
    end
    return false
end


function customedit.maxLength(edit,value)
    if edit and value then
        if tonumber(value) then
            if value>0 then
                for k,v in ipairs(edits)do
                    if v["id"]==edit then
                        v["maxLength"]=value
                        return true
                    end
                end
            end
        end
    end
    return false
end

function customedit.changePos(edit,x,y)
    if edit and x and y then
        if tonumber(x) and tonumber(y) then
            for k,v in ipairs(edits)do
                if v["id"]==edit then
                    v["x"]=x
                    v["y"]=y
                    return true
                end
            end
        end
    end
    return false
end


function customedit.clear(res)
    for k,v in ipairs(edits)do
        if v["resource"]==res then
            table.remove(edits,k)
            customedit.clear(res)
            break
        end
    end
end
addEventHandler("onClientResourceStop",root,customedit.clear)


function customedit.property(edit,data,value)
    if edit and data and value then
        for k,v in ipairs(edits)do
            if v["id"]==edit then
                v[data]=value
                return true
            end
        end
    end
    return false
end


function customedit.focus(edit)
    if edit then
        for k,v in ipairs(edits)do
            if v["id"]==edit then
                v["active"]=true
                return true
            end
        end
    end
    return false
end
