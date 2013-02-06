-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local widget = require ("widget")
local facebook = require ("facebook")
local json = require ("Json")

local appId  = "264918200296425"	

local fbCommand		
local LOGOUT = 1
local SHOW_DIALOG = 2
local POST_MSG = 3
local GET_USER_INFO = 5
local POST_PHOTO = 4



local event_status = display.newText("Session Status",190,20,nil,18)
local event_token = display.newText("",50,250,nil,10)
local usr_info = display.newText("",50,300,nil,10)



local function listner (event)
	if ("session" == event.type) then
		event_status.text = event.phase
		event_token.text = event.token
		
		if event.phase ~= "login" then
			return
		end
		
		if fbCommand == GET_USER_INFO then
			facebook.request( "me" )
		end
		
		if fbCommand == POST_PHOTO then
			local attachment = {
				name = "Jump",
				link = "http://www.coronalabs.com/",
				caption = "Link caption",
				description = "jump jump",
				picture = "https://www.dropbox.com/s/2gplr60oig3650b/ff.jpg",
				actions = json.encode( { { name = "Learn More", link = "http://coronalabs.com" } } )
			}
			facebook.request( "me/feed", "POST", attachment )
		end
			
		if fbCommand == SHOW_DIALOG then
			facebook.showDialog( "feed", {
				name = "picture",
				description = "picture",
				link = "https://www.dropbox.com/s/2gplr60oig3650b/ff.jpg"
			})
		end
		
		if fbCommand == POST_MSG then
			local Msg = {message = "it's worked"}
			facebook.request("me/feed","POST", Msg)
		end
		
	elseif ( "request" == event.type ) then 
		local response = event.response
		if (not event.siError) then 
			response = json.decode(event.response)
			
			if fbCommand == GET_USER_INFO then
				usr_info.text = response.name
					
			elseif fbCommand == POST_PHOTO then
				 native.showAlert( "Success", "The photo has been uploaded.", { "OK" } )
							
			elseif fbCommand == POST_MSG then
				 native.showAlert( "Success", "The message posted", { "OK" } )
				
			else
				 native.showAlert( "fail", "Unknown command response", { "OK" } )
			end
		
		end
	end
end


--login
if (appId) then 

		local function fbphoto(event)
			fbCommand = POST_PHOTO
			facebook.login(appId,listner, {"publish_stream"})
		end
		
		local function showD(event)
			fbCommand = SHOW_DIALOG
			facebook.login(appId,listner, {"publish_stream"})
		end

		local function fbMsg(event)
			fbCommand = POST_MSG
			facebook.login(appId,listner, {"publish_stream"})
		end

		local function fbUsr(event)
			fbCommand = GET_USER_INFO
			facebook.login(appId,listner, {"publish_stream"})
		end
		
		
		local function FblogOut( event )
			fbCommand = LOGOUT
			facebook.logout()
		end

		
		local FbButton = widget.newButton{
			default = "fbButton.png",
			onRelease = FblogOut,
			label = "logout",
			left = 0 
		}	
		
		local FbButton = widget.newButton{
			default = "fbButton.png",
			onRelease = showD,
			label = "showDialog",
			left = 0,
			top=50
		}


		local Fbphoto = widget.newButton{
			default = "fbButton.png",
			onRelease = fbphoto,
			label = "photo",
			left =0,
			top=100

		}
		
		local Fbget_msg = widget.newButton{
			default = "fbButton.png",
			onRelease = fbMsg,
			label = "msg_only",
			left =0,
			top=150

		}
			
		local Fbget_msg = widget.newButton{
			default = "fbButton.png",
			onRelease = fbUsr,
			label = "User info",
			left =0,
			top=200

		}
end