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
-- 	functions for buttons
		local function fb_Post_Photo(event)
			fbCommand = POST_PHOTO
			facebook.login(appId,listner, {"publish_stream"})
		end
		
		local function fb_Show_Dialog(event)
			fbCommand = SHOW_DIALOG
			facebook.login(appId,listner, {"publish_stream"})
		end

		local function fb_Post_Message(event)
			fbCommand = POST_MSG
			facebook.login(appId,listner, {"publish_stream"})
		end

		local function fb_Get_User(event)
			fbCommand = GET_USER_INFO
			facebook.login(appId,listner, {"publish_stream"})
		end
		
		
		local function Fb_logOut( event )
			fbCommand = LOGOUT
			facebook.logout()
		end

		--buttons facebook
		
		local FbButton_logOut = widget.newButton{
			default = "fbButton.png",
			onRelease = Fb_logOut,
			label = "logout",
			left = 0 
		}	
		
		local FbButton_Show_Dialog = widget.newButton{
			default = "fbButton.png",
			onRelease =fb_Show_Dialog,
			label = "showDialog",
			left = 0,
			top=50
		}


		local FbButton_Post_Photo = widget.newButton{
			default = "fbButton.png",
			onRelease = fb_Post_Photo,
			label = "photo",
			left =0,
			top=100

		}
		
		local Fbbutton_Post_Message = widget.newButton{
			default = "fbButton.png",
			onRelease = fb_Post_Message,
			label = "msg_only",
			left =0,
			top=150

		}
			
		local FbButton_Get_User = widget.newButton{
			default = "fbButton.png",
			onRelease = fb_Get_User,
			label = "User info",
			left =0,
			top=200

		}
end