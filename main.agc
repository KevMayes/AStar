
// Project: AStar 
// Created: 20-05-25

// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "AStar" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

type Vector2D
		X as integer
		Y as integer
endtype

type Square
		Node as Vector2D
		CamefromNode as Vector2D
		GCost as integer
		HCost as integer
		FCost as integer
		Blocked as integer
endtype


Global Debug=0
Global GridWidth = 63
Global GridHeight = 47

global dim Grid[GridWidth,GridHeight] as Square
global Text as Integer []
Global Start as Vector2D
Global Dest as Vector2D

Dest.X = gridWidth-1
Dest.Y = GridHeight-1


global GridScaleX as integer = 16
global GridScaleY as integer = 16
global GridOffsetX as integer = 0
global GridOffsetY as  integer = 0

global MOVE_STRAIGHT_COST as integer = 10
global MOVE_DIAGONAL_COST as integer = 14

Global OpenList as Vector2D []
Global CloseList as Vector2D []
global PathCalc as Vector2D[]

Function EmptyList(ListObject as Vector2D [] )
		while( ListObject.length)>-1
		ListObject.remove()
	endwhile
endfunction 


function PathFind(StartNode as Vector2D ,EndNode as Vector2D)
	CurrentNode as Vector2D
	OpenList as Vector2D[]
	CloseList as Vector2D[]
	PathCalc as Vector2D[]
	NeighList as Vector2D[]
	ClearGrid()
	GCost = 0
	HCost =  CalculateDistance(StartNode,EndNode)
	FCost = CalculateFCost(GCost,HCost)
	Grid[StartNode.X,StartNode.Y].GCost = 0
	grid[StartNode.X,StartNode.Y].HCost = HCost
	Grid[StartNode.X,StartNode.Y].FCost = FCost
	
	OpenList.insert(StartNode)
	//CalculatePath.insert(StartNode)


	while (OpenList.length>-1)
		CurrentNodeIdx = GettheLowestFCostNode(OpenList)
		CurrentNode = OpenList[CurrentNodeIdx]
		if (CurrentNode.X = EndNode.X) and (CurrentNode.Y = EndNode.Y) 
			CalculatePath(EndNode)
				while( OpenList.length)>-1
				OpenList.remove()
				endwhile
		else
		CloseList.Insert(OpenList[CurrentNodeIdx])
		openList.Remove(CurrentNodeIdx)
		NeighList = GetNeighbourList(CurrentNode)		
		for i=0 to NeighList.length
			if (onList(CloseList,NeighList[i]) = 0 )
				Blocked = Grid[NeighList[i].x,NeighList[i].y].Blocked
				if (Blocked = 1)
					CloseList.insert(NeighList[i])
				else
					Gcost = CalculateDistance(CurrentNode,NeighList[i])
					//Gcost = CalculateDistance(StartNode,NeighList[i])
					if (GCost<=Grid[NeighList[i].x,NeighList[i].Y].GCost) 
						Grid[NeighList[i].x,NeighList[i].y].CamefromNode = CurrentNode
						HCost = CalculateDistance(NeighList[i],EndNode)
						FCost = CalculateFCost(GCost,Hcost)
						Grid[NeighList[i].x,NeighList[i].y].Gcost = GCost
						Grid[NeighList[i].x,NeighList[i].y].HCost = HCost
						Grid[NeighList[i].x,NeighList[i].y].Fcost = FCost
						if (OnList(OpenList,NeighList[i])=0)
							OpenList.insert(NeighList[i])
						endif
					endif				
				endif
			endif
		next i
	endif
	endwhile
	
	// out of nodes on open list
	endfunction

Function Calculatepath(EndNode as Vector2D)
	TempPathCalc as Vector2D[]
	while( PathCalc.length)>-1
		PathCalc.remove()
	endwhile
	CurrentNode as Vector2D
	CurrentNode = EndNode
	While Grid[CurrentNode.X,CurrentNode.Y].CameFromNode.X >-1
		TempPathCalc.Insert (CurrentNode)
		CurrentNode = Grid[CurrentNode.x,CurrentNode.Y].CamefromNode
	endWhile
	// Add the last row to the list
	TempPathCalc.Insert (CurrentNode)
	for i=TempPathCalc.length to 0 step -1
		PathCalc.insert(TempPathCalc[i])
	next i
	
	
endfunction

Function OnList(List as Vector2D[], Node as Vector2D)
		result as integer = 0
		for i=0 to List.length
			if List[i].X = Node.X and List[i].Y = Node.Y 
				Result= 1
			endif
			next i
endfunction Result

Function GetNeighbourList(CurrentNode as Vector2D)
	Neighbour as Vector2D[]

	if (CurrentNode.X-1 => 0) and (CurrentNode.Y-1 => 0) 
		Neighbour.insert(CurrentNode)
 		Neighbour[Neighbour.length].X=Neighbour[Neighbour.length].X-1
 		Neighbour[Neighbour.length].Y=Neighbour[Neighbour.length].Y-1
	endif	

	if (CurrentNode.X-1 => 0) and (CurrentNode.Y+1 <=GridHeight) 
		Neighbour.insert(CurrentNode)
 		Neighbour[Neighbour.length].X=Neighbour[Neighbour.length].X-1
 		Neighbour[Neighbour.length].Y=Neighbour[Neighbour.length].Y+1
	endif	
	
	if (CurrentNode.X+1 <=GridWidth) and (CurrentNode.Y-1 => 0) 
		Neighbour.insert(CurrentNode)
 		Neighbour[Neighbour.length].X=Neighbour[Neighbour.length].X+1
 		Neighbour[Neighbour.length].Y=Neighbour[Neighbour.length].Y-1
	endif		
	
	if (CurrentNode.X+1 <=GridWidth) and (CurrentNode.Y+1 <=GridHeight) 
		Neighbour.insert(CurrentNode)
 		Neighbour[Neighbour.length].X=Neighbour[Neighbour.length].X+1
 		Neighbour[Neighbour.length].Y=Neighbour[Neighbour.length].Y+1
	endif		
		if (CurrentNode.X-1 => 0) 
		Neighbour.insert(CurrentNode)
 		Neighbour[Neighbour.length].X=Neighbour[Neighbour.length].X-1 		 		
	endif
	if (CurrentNode.X+1 <=GridWidth) 
		Neighbour.insert(CurrentNode)
 		Neighbour[Neighbour.length].X=Neighbour[Neighbour.length].X+1
	endif
	if (CurrentNode.Y-1 => 0) 
		Neighbour.insert(CurrentNode)
 		Neighbour[Neighbour.length].Y=Neighbour[Neighbour.length].Y-1
	endif
	if (CurrentNode.Y+1 <= GridHeight) 
		Neighbour.insert(CurrentNode)
 		Neighbour[Neighbour.length].Y=Neighbour[Neighbour.length].Y+1
	endif
			
endfunction Neighbour

Function GettheLowestFCostNode(Nodes as Vector2D[])
	result as integer 
	//result = Grid[Nodes[0].x,Nodes[0].y].FCost
	result = 99999999999999999999999999999
	Idx = 0
	for i = 0 to Nodes.Length
			if Grid[Nodes[i].X,Nodes[i].Y].FCost < Result
				 Result = Grid[Nodes[i].X,Nodes[i].Y].FCost
				 Idx = i
			endif
	next
endfunction idx

function Min(a,b)
	R = A
	if (b<a) then R=B
endfunction R

Function CalculateDistance(a as Vector2D, b as Vector2D)
	XDistance = Abs(a.x - b.x)
	YDistance = abs(a.y - b.y)
	Remaining = abs(XDistance - YDistance)
	Cost = (MOVE_DIAGONAL_COST* Min(XDistance,yDistance))+ (MOVE_STRAIGHT_COST* Remaining)
	endfunction Cost

function CalculateFCost(G,H)
	Fcost = G + H
endfunction Fcost

function DrawGrid()
	GridCoordTxt as String 
	while( text.length)>-1
		deletetext(text[text.length])
		text.remove()
	endwhile
	Txt = 0
	for y = 0 to GridHeight
		for X = 0 to GridWidth
			xp = GridOffsetX+(x*GridScaleX)
			yp = GridOffsety+(y*GridScaleY)
			Endx = xp+GridScaleX
			Endy = yp+GridScaleY
			G = Grid[X,Y].GCost
			H = Grid[X,Y].HCost
			V = Grid[X,Y].FCost
			if Debug =1 
			GridCoordTxt = str(X) +":" +str(Y) 
			Text.insert( createText(GridCoordTxt))
			SetTextPosition(Text[txt],XP+5,YP+3)
			SetTextSize(Text[Txt],14)
			txt = txt +1			
			if (g<99999999) 
			Text.insert (CreateText("G:"+str(G)))
			SetTextPosition(Text[txt],XP+5,YP+16)
			SetTextSize(Text[Txt],14)
			setTextColor(Text[Txt],255,0,0,255)
			txt = txt +1			
			Text.insert (CreateText("H:"+str(H)))
			SetTextPosition(Text[txt],XP+5,YP+32)
			SetTextSize(Text[Txt],14)
			setTextColor(Text[Txt],0,255,0,255)
			txt = txt +1			
			Text.insert (CreateText("F:"+str(V)))
			SetTextPosition(Text[txt],XP+5,YP+48)
			SetTextSize(Text[Txt],14)
			setTextColor(Text[Txt],255,255,0,255)
			txt = txt +1			
			endif
			endif
			color=30
		 	drawline(xp,yp,EndX,yp,color,color,color)
		 	drawline(xp,yp,xp,EndY,color,color,color)
		 	drawline(xp,EndY,EndX,EndY,color,color,color)
		 	drawline(EndX,yp,EndX,Endy,color,color,color)
		 	if Grid[X,Y].Blocked = 1 
		 		color = MakeColor(0,0,255)
		 		drawbox(xp,yp,endx,endy,color,color,color,color,1)
		 	endif
		 	if X= Start.X and Y = Start.Y  
//~		 		if Debug=1
		 			Text.insert (CreateText("S"))		 			
					SetTextPosition(Text[txt],xp+1,yp+1)
					SetTextSize(Text[Txt],13)
					setTextColor(Text[Txt],255,255,0,255)
					//SetTextAngle(text[txt],90)
					txt=txt+1
//~				endif
//~			 		drawLine(Xp+20,Yp+20,EndX-20,EndY-20,255,0,0)
//~		 			drawLine(XP+20,EndY-20,EndX-20,YP+20,255,0,0)
		 	endif
			 	if X= Dest.X and Y = Dest.Y
//~			 		if debug=1
		 			Text.insert (CreateText("E"))		 			
					SetTextPosition(Text[txt],xp+1,yp+1)
					SetTextSize(Text[Txt],13)
					setTextColor(Text[Txt],255,255,0,255)
					txt=txt+1
				endif
//~		 		drawLine(Xp+20,Yp+20,EndX-20,EndY-20,0,255,0)
//~		 		drawLine(XP+20,EndY-20,EndX-20,YP+20,0,255,0)
//~		 	endif	 	
		next x
	next y
endfunction

Function DrawPath()
	Xf = -1
	Yf = -1
	For i=0 to PathCalc.length
		if Xf<0 
			XF = GridOffsetX+ (PathCalc[i].X * GridScaleX) + (GridScaleX / 2)
			YF = GridOffsetY+ (PathCalc[i].Y * GridScaleY) + (GridScaleY / 2)
		else
			XP = GridOffsetX+ (PathCalc[i].X * GridScaleX)+ (GridScaleX / 2)
			YP = GridOffsetY+ (PathCalc[i].Y * GridScaleY)+ (GridScaleY / 2)
			DrawLine(XF,YF,XP,YP,255,0,255)
			XF=XP
			YF=YP
		endif
	next
Endfunction
			


Function ClearGrid()

	errorNode as Vector2D
	errorNode.X=-1
	errorNode.Y=-1
	for y = 0 to gridHeight
		for  x = 0 to GridWidth
				Grid[x,y].GCost = 99999999
				grid[x,y].Node.x = X
				Grid[x,y].Node.y = Y
				grid[x,y].CamefromNode = ErrorNode
			next x
	next y
endfunction

ClearGrid()
Wait=1

do
	drawgrid()
	MouseX as integer
	MouseY as integer
	MouseX = (GetPointerX()-GridOffsetX-(GridScaleX/2))/GridScaleX
	MouseY = (GetPointerY()-GridOffsetY-(GridScaleY/2))/GridScaleY
	If MouseX>-1 and MouseX<gridWidth and MouseY>-1 and MouseY<gridHeight
		if GetRawKeyPressed(83)=1 and (Grid[Mousex,MouseY].Blocked=0)
			Start.X = MouseX
			Start.Y = MouseY
			wait=10
		endif
		if GetRawKeyPressed(69)=1 and (Grid[Mousex,MouseY].Blocked=0)
			Dest.X = MouseX
			Dest.Y = MouseY
			wait=10
		endif
//~		Print (MouseX)
//~		Print (MouseY)
		endif
	if GetRawMouseLeftState()=1
			 Grid[MouseX,MouseY].Blocked = 1
		    WAIT=20
	endif
	if GetRawMouseRightState()=1
		 Grid[MouseX,MouseY].Blocked = 0
	WAIT=20
	endif
	if (Wait>0)
		Wait=Wait -1
		if Wait=0
			PathFind(Start,Dest)
		endif
	endif
			
	if (PathCalc.length>0) 
		drawPath()
//~		for i = 0 to pathCalc.length
//~			print (str(i) +" : "+str(PathCalc[i].X)+" x " + str(PathCalc[i].Y))		
//~		next i
		endif
//~	Print( ScreenFPS() )
    Sync()
loop
