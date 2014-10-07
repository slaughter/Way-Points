if SERVER then return end
---------
--FONTS--
---------
surface.CreateFont( "font", {font = "Myriad Pro", size = 28, antialias = true, } )



-------------
--VARIABLES--
-------------

ply = LocalPlayer()
waypoints = {} --We we use this table to grab vectors.
w = ScrW()
h = ScrH()

-------------
--DRAW MENU--
-------------
function menu()


	-- BACKGROUND	
	local background = vgui.Create("DFrame")
	background:SetSize(370, 340)
	background:MakePopup()
	background:SetPos(w / 2 - 250, h / 2 - 250)
	background:SetTitle("Waypoints by fghdx | github.com/fghdx/Way-Points")
	--

	--List that displays all Waypoints.
	local wayPointList = vgui.Create( "DListView", background )
	wayPointList:SetSize(250, 300)
	wayPointList:SetPos(10, 30)
	wayPointList:AddColumn("Name")
	wayPointList:AddColumn("Location")
	wayPointList:AddColumn("Color")
	--

	--Function to refresh items on wayPointList.
	function refresh_list()
		wayPointList:Clear()
		for k, v in pairs(waypoints) do
			wayPointList:AddLine(v['name'], v['pos'], v['color'])
		end
	end

	-- Button to add waypoint.
	local addWP = vgui.Create("DButton", background)
	addWP:SetPos(265, 30)
	addWP:SetSize(100, 25)
	addWP:SetText("Add Way Point")
	addWP.DoClick = function()
		
		--We need to create a window
		--All this needs is a text entery for the name,
		--and a button to add the entry to the waypoint list..
		local frame = vgui.Create("DFrame")
		frame:SetSize(300, 280)
		frame:SetPos(w / 2 - 150, h / 2 - 27.5)
		frame:MakePopup()
		frame:SetTitle("Create Waypoint")

		-- Name Label. Will be useless once I create the theme.
		local nameLbl = vgui.Create("DLabel", frame)
		nameLbl:SetText("Name:")
		nameLbl:SetPos(5, 25)

		--Name text box
		local text = vgui.Create("DTextEntry", frame)
		text:SetPos(5, 45)
		text:SetSize(290, 20)

		--color label. Will be useless once I create the theme.
		local colorLbl = vgui.Create("DLabel", frame)
		colorLbl:SetText("Color:")
		colorLbl:SetPos(5, 68)
	
		--Create Color Selector
		local color = vgui.Create( "DColorMixer", frame);
		color:SetSize( 290, 160);
		color:SetPos( 5, 87 );

		--Button to insert waypoint into table.
		local button = vgui.Create("DButton", frame)
		button:SetPos(5, 250)
		button:SetSize(290, 20)
		button:SetText("Add Way Point")
		button.DoClick = function()
			
			--Only insert into table if there is text in the text box.
			--If not display an error message.
			if text:GetText() != "" then
				--Insert into waypoints table the name and vector for waypoint.
				table.insert(waypoints, {name=text:GetText(), pos=Vector(ply:GetPos()[1], ply:GetPos()[2], ply:GetPos()[3]), color=Color(color:GetColor().r, color:GetColor().g, color:GetColor().b, color:GetColor().a)})

				--Refresh the list to add the new item.
				refresh_list()
				frame:Remove()
			else
				--Error message. 
				Derma_Message("Please add a name!", "Error:", "Close")
			end

			end
	end
	--

	--Remove waypoint button.
	local removeWP = vgui.Create("DButton", background)
	removeWP:SetPos(265, 57)
	removeWP:SetSize(100, 25)
	removeWP:SetText("Remove Selected")
	removeWP.DoClick = function()

		
		line = wayPointList:GetSelectedLine() --Get selected line number
		name = wayPointList:GetLine(line):GetValue(1) --Get name
		pos = wayPointList:GetLine(line):GetValue(2) --Get Pos

		--Go through each item of the Waypoint list.
		for k, v in pairs(waypoints) do
			--If the name and pos are the same as the line
			--remove them.
			if v['name'] == name and v['pos'] == pos then
				table.remove(waypoints, k)
			end
		end
		--Refresh the list to get the new values.
		refresh_list()

	end
	--



	--Refresh list to get items.
	refresh_list()
end
concommand.Add("waypoint_menu", menu) --Add console command to open the menu.

-------------------------
--DRAWING THE WAYPOINTS--
-------------------------

function draw_waypoints()

	for k, v in pairs(waypoints) do

		name = v['name']
		pos = v['pos']
		color = v['color']
		--pos + 40z to make it elevated off the ground.
		drawPos = (pos + Vector( 0,0,40 )):ToScreen()

		--draw the name
		draw.SimpleText(name, font, drawPos.x + 5, drawPos.y - 10, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		--draw the box
		draw.RoundedBox(0, drawPos.x, drawPos.y, 10, 10, color)
	end
end
hook.Add("HUDPaint", "draw_waypoints", draw_waypoints)