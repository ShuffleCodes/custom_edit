customedit={}
local fonts={}
edits={}
variable={}
resources={}
s=Vector2(guiGetScreenSize())



style = "1"


addEventHandler("onClientRender",root,function()
    for k,v in ipairs(edits)do
        if v["visible"] then
            dxDrawRectangle(v["x"],v["y"],v["w"],v["h"],tocolor(v["bgcolor"][1],v["bgcolor"][2],v["bgcolor"][3],v["bgcolor"][4]),v["postgui"])
            if v["masked"] then
                variable.width=dxGetTextWidth(customedit.convertMasked(v["txt"]),1,v["font"],false)
            else
                variable.width=dxGetTextWidth(v["txt"],1,v["font"],false)
            end
            variable.cursor = 0
            if variable.width < (v["w"]-(15/1920)*s.x) then 
            	variable.cursor = variable.width+(6/1920)*s["x"]
            else
            	variable.cursor = v["w"]-(20/1920)*s["x"]
            end
            if v["active"] then
                --[[if isCursorShowing() then
                    if getKeyState("backspace") then
                        v["txt"] = string.sub(v["txt"], 1, #v["txt"] - 1)
                    end
                end]]--
                v["alpha"] = interpolateBetween(0, 0, 0, 75, 0, 0, (getTickCount() - v["click"]) / 200, "Linear")
                if v["activecolor"][4]>0 then
                --bottom line
                    dxDrawLine(v["x"],v["y"]+v["h"],v["x"]+v["w"],v["y"]+v["h"],tocolor(v["activecolor"][1],v["activecolor"][2],v["activecolor"][3],v["alpha"]/75*200),2,v["postgui"])

                    --left line
                    dxDrawLine(v["x"],v["y"]+v["h"]/1.5,v["x"],v["y"]+v["h"],tocolor(v["activecolor"][1],v["activecolor"][2],v["activecolor"][3],v["alpha"]/75*200),2,v["postgui"])

                    --right line
                    dxDrawLine(v["x"]+v["w"],v["y"]+v["h"]/1.5,v["x"]+v["w"],v["y"]+v["h"],tocolor(v["activecolor"][1],v["activecolor"][2],v["activecolor"][3],v["alpha"]/75*200),2,v["postgui"])
                end

                variable.alpha = interpolateBetween(0, 0, 0, 255, 0, 0, (getTickCount() - v["cursor"]) / 1000, "SineCurve")
                dxDrawRectangle(v["x"]+variable.cursor+(10/1920)*s.x,v["y"]+v["h"]/2-(v["h"]-(12/1080)*s["y"])/2,(1/1920)*s["x"],v["h"]-(12/1080)*s["y"],tocolor(v["caret"][1],v["caret"][2],v["caret"][3],variable.alpha),true)
            else
                v["alpha"] = interpolateBetween(v["alpha"], 0, 0, 0, 0, 0, (getTickCount() - v["click"]) / 200, "Linear")
            end
           
            if v["placeholder"] and string.len(v["txt"])==0 and not v["active"] then
                dxDrawText(v["placeholder"],v["x"]+(10/1920)*s["x"],v["y"],v["w"]+v["x"]+(10/1920)*s["x"],v["h"]+v["y"],tocolor(v["fontcolor"][1],v["fontcolor"][2],v["fontcolor"][3],v["fontcolor"][4]),1,v["font"],"left","center",true,false,v.postgui)
            else
                if variable.width>(v.w)-(10/1920)*s.x then
                    if v["masked"] then
                        dxDrawText(customedit.convertMasked(v["txt"]),v["x"]+(10/1920)*s["x"],v["y"]+(7/1080)*s.y,v["w"]+v["x"]-(10/1920)*s["x"],v["h"]+v["y"],tocolor(v["fontcolor"][1],v["fontcolor"][2],v["fontcolor"][3],v["fontcolor"][4]),1,v["font"],"right","center",true,false,v.postgui)
                    else
                        dxDrawText(v["txt"],v["x"]+(10/1920)*s["x"],v["y"],v["w"]+v["x"]-(10/1920)*s["x"],v["h"]+v["y"],tocolor(v["fontcolor"][1],v["fontcolor"][2],v["fontcolor"][3],v["fontcolor"][4]),1,v["font"],"right","center",true,false,v.postgui)
                    end
                else
                    if v["masked"] then
                        dxDrawText(customedit.convertMasked(v["txt"]),v["x"]+(10/1920)*s["x"],v["y"]+(7/1080)*s.y,v["w"]+v["x"]+(10/1920)*s["x"],v["h"]+v["y"],tocolor(v["fontcolor"][1],v["fontcolor"][2],v["fontcolor"][3],v["fontcolor"][4]),1,v["font"],"left","center",true,false,v.postgui)
                    else
                        dxDrawText(v["txt"],v["x"]+(10/1920)*s["x"],v["y"],v["w"]+v["x"]+(10/1920)*s["x"],v["h"]+v["y"],tocolor(v["fontcolor"][1],v["fontcolor"][2],v["fontcolor"][3],v["fontcolor"][4]),1,v["font"],"left","center",true,false,v.postgui)
                    end
                end
            end
        end
    end
end)





bindKey("f3","down",function()
    showCursor(not isCursorShowing())
end)

addEventHandler("onClientClick",root,function(key,state)
    if key=="left" and state=="down" then
        for k,v in ipairs(edits)do
            if isMouseInPosition(v["x"],v["y"],v["w"],v["h"]) then
                if not v["readOnly"] then
                    if not v["active"] then
                        v["active"]=true
                        v["click"] = getTickCount()
                        guiSetInputMode("no_binds")      
                        triggerEvent("onCustomEditFocus",localPlayer,v["id"])
                    end
                end
            else
                if v["active"] then
                    triggerEvent("onCustomEditLeave",localPlayer,v["id"])
                end
                v["active"]=false
                v["click"] = getTickCount()
                guiSetInputMode("allow_binds")
            end
        end
    end
end)


function nextEdit()
    if customedit.getActive() then
        if customedit.getActive()<#edits then
            edits[customedit.getActive()+1]["active"]=true
            edits[customedit.getActive()]["active"]=false
            if not edits[customedit.getActive()]["visible"] then
                nextEdit()
                return
            end
            triggerEvent("onCustomEditFocus",localPlayer,edits[customedit.getActive()]["id"])
            if (customedit.getActive()-1)==0 then
                triggerEvent("onCustomEditLeave",localPlayer,edits[#edits]["id"])
            else
                triggerEvent("onCustomEditLeave",localPlayer,edits[customedit.getActive()-1]["id"])
            end
        elseif customedit.getActive()==#edits then
            edits[customedit.getActive()]["active"]=false
            edits[1]["active"]=true
            if not edits[1]["visible"] then
                nextEdit()
                return
            end
            triggerEvent("onCustomEditFocus",localPlayer,edits[customedit.getActive()]["id"])
            if (customedit.getActive()-1)==0 then
                triggerEvent("onCustomEditLeave",localPlayer,edits[#edits]["id"])
            else
                triggerEvent("onCustomEditLeave",localPlayer,edits[customedit.getActive()-1]["id"])
            end
        end
    end
end

addEventHandler("onClientKey",root,function(key, state)
    if key=="backspace" and state then
        if isCursorShowing() then
            for k,v in ipairs(edits)do
                if v["active"] then
                    v["txt"] = string.sub(v["txt"], 1, #v["txt"] - 1)
                    triggerEvent("onCustomEditType",localPlayer,v["id"])
                end
            end
        end
    elseif key=="tab" and state then
        if isCursorShowing() then
            nextEdit()
        end
    elseif key=="a" and state then
        if isCursorShowing() then
            if getKeyState("lctrl") then
                for k,v in ipairs(edits)do
                    if v["active"] then
                        v["txt"] = ""
                    end
                end
            end
        end
    end
end)


addEventHandler("onClientCharacter",root,function(char)
    if char then
        if isCursorShowing() then
            if customedit.validChar(char) then
                for k,v in ipairs(edits)do
                    if v["active"] then
                        if tonumber(string.len(customedit.getText(v["id"])))<tonumber(v["maxLength"]) then
                         if char==" " then
                           if v["blockspace"] then
                              return
                            else
                                v["txt"]=v["txt"]..char
                                v["cursor"]=getTickCount()
                                triggerEvent("onCustomEditType",localPlayer,v["id"])
                           end
                         else
                            v["txt"]=v["txt"]..char
                            v["cursor"]=getTickCount()
                            triggerEvent("onCustomEditType",localPlayer,v["id"])
                         end
                        end
                    end
                end
            end
        end
    end
end)





