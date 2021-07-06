import Array
import Html
import Html.Attributes
import Html.Events exposing (onInput, onClick)

myShapes model = -- to catch taps everywhere, draw a clear rect above all shapes
                [ 
                  rect 192 128 |> filled (rgba 0 0 0 0.01)
                    |> notifyMouseDownAt (LineMouseDownAt 9999)
                    -- |> notifyMouseMoveAt (LineMouseMoveAt 9999)  -- line_id create issue when on main big ghost it hovers and gets 9999 which is new line and finds first entry in list and start updating its ending point to remove this using global current selected line to update the point based on that
                    |> notifyMouseMoveAt LineMouseMoveAt
                    |> notifyMouseUp LineMouseUp
                ]
                ++(
                   -- List.map  
                   List.indexedMap 
                    (newElement model)
                    model.allIdeas -- for list + record type
                    --model.ideas -- for list + tuple type
                 )
                ++(
                   -- List.map  
                   List.indexedMap 
                    (newLine model)
                    model.allPoints -- for list + record type
                    --model.ideas -- for list + tuple type
                 )++
                [ 
                
                  {- newElement "data" model
                    -- |> move (85, -50)
                    |> move (0, 0)  -}
                  circle 10
                    |> filled model.defaultColor
                    -- (rgb 70 98 240)
                    |> move (85, -50)
                    |> notifyTap AddNewIdea

                  , text "+"
                    |> centered
                    |> filled white
                    -- |> scale 0.4
                    |> move (85, -54)
                    |> notifyTap AddNewIdea

                  --- default color
                  , circle 3
                    |> filled (rgb 227 72 64) -- red
                    |> move (71, -45)
                    |> notifyTap (UpdateDefaultColor (rgb 227 72 64))

                  , circle 3
                    |> filled (rgb 95 168 50) -- green
                    |> move (75, -39)
                    |> notifyTap (UpdateDefaultColor (rgb 95 168 50))

                  , circle 3
                    |> filled (rgb 70 98 240) -- blue
                    |> move (82, -36)
                    |> notifyTap (UpdateDefaultColor (rgb 70 98 240))

                  , circle 3
                    |> filled (rgb 209 207 65) -- yellow
                    |> move (90, -36)
                    |> notifyTap (UpdateDefaultColor (rgb 209 207 65))
                  -- default color ends

                  -- main actions
                  , group [
                      roundedRect 10 25 2
                      |> showActive model 0 -- filled (rgb 93 89 89)
                      -- |> move (-25, -34) -- for bottom actions
                      |> move (-25, 34) -- for top actions
                      -- |> scaleY 2
                      |> showHovered model 0
                    , text "Line"
                      |> centered
                      |> filled white
                      |> scale 0.3
                      |> move (-58, -26)
                      -- |> rotate (degrees -270)-- for bottom actions
                      |> rotate (degrees -90)-- for top actions
                    ] |> notifyTap ActivateLineDrawing
                    |> notifyEnter (MouseEnter 0)
                    |> notifyLeave MouseLeave
                    
                  , group [
                      roundedRect 10 25 2
                      |> showActive model 1 -- filled (rgb 93 89 89)
                      |> move (-10, 34)
                      -- |> scaleY 2
                      |> showHovered model 1
                    , text "Zoom in"
                      |> centered
                      |> filled white
                      |> scale 0.3
                      -- |> move (-54, 9)-- for bottom actions
                      |> move (-55, -11) -- for yop actions
                      -- |> rotate (degrees -270)-- for bottom actions
                      |> rotate (degrees -90)-- for yop actions
                    ] |> notifyTap ScaleIn
                    |> showHideZoomIn model.zoom
                    |> notifyEnter (MouseEnter 1)
                    |> notifyLeave MouseLeave

                  , group [
                      roundedRect 10 25 2
                      |> showActive model 2 -- filled (rgb 93 89 89)
                      -- |> move (5, -34) -- bottom action
                      |> move (5, 34) -- top action
                      -- |> scaleY 2
                      |> showHovered model 2
                    , text "Zoom out"
                      |> centered
                      |> filled white
                      |> scale 0.3
                      -- |> move (-54, -6) -- bottom action
                      |> move (-54, 4) -- top action
                      -- |> rotate (degrees -270) -- bottom action
                      |> rotate (degrees -90) -- top action
                  ] |> notifyTap ScaleOut
                  |> showHideZoomOut model.zoom
                  |> notifyEnter (MouseEnter 2)
                  |> notifyLeave MouseLeave
                  
                  , group [
                      roundedRect 10 25 2
                      |> showActive model 3 -- filled (rgb 93 89 89)
                      -- |> move (20, -34) -- bottom action
                      |> move (20, 34) -- top action
                      -- |> scaleY 2
                      |> showHovered model 3
                    , text "Font size +"
                      |> centered
                      |> filled white
                      |> scale 0.3
                      -- |> move (-54, -21) -- bottom action
                      |> move (-53, 19) -- top action
                      -- |> rotate (degrees -270) -- bottom action
                      |> rotate (degrees -90) -- top action
                  ] |> notifyTap IncreaseFontSize
                  |> showHideFontPlus model.defaultFontSize
                  |> notifyEnter (MouseEnter 3)
                  |> notifyLeave MouseLeave
                    
                  , group [
                      roundedRect 10 25 2
                      |> showActive model 4 -- filled (rgb 93 89 89)
                      -- |> move (35, -34) -- bottom action
                      |> move (35, 34) -- top action
                      -- |> scaleY 2
                      |> showHovered model 4
                    , text "Font size -"
                      |> centered
                      |> filled white
                      |> scale 0.3
                      -- |> move (-54, -36) -- bottom action
                      |> move (-53, 34) -- top action
                      -- |> rotate (degrees -270) -- bottom action
                      |> rotate (degrees -90) -- top action
                  ] |> notifyTap DecreaseFontSize
                  |> showHideFontMinus model.defaultFontSize
                  |> notifyEnter (MouseEnter 4)
                  |> notifyLeave MouseLeave
                  
                -- main actions ends
                    
                   -- , text ("debug " ++ model.debug) |> size 4 |> filled purple |> move ( -96, 30 )
                   -- , text ("Mind Mapping") |> sansserif |> size 6 |> filled blue |> move (-15, 55)
                   
                   -- showDuplicateMoveSection model
                   -- |> scale model.zoom , 
                  , showGhostSection model
                   |> scale model.zoom
                  , showEditIdeaSection model
                   |> scale model.zoom
                   
                   -- , showEditIdeaSection -40 18 0.5 -- normal scaling value to view and to show box in center position of the idea
                 ]

-- showActive action
showActive model actionType = 
  if actionType == 0 then -- if line and line draw status is true
    if model.lineDrawingStatus == True then
      filled green
    else 
      filled (rgb 93 89 89)
  else 
    if model.currentAction == actionType then
      filled green
    else 
      filled (rgb 93 89 89)
    
-- showHovered action
showHovered model actionType = 
  if model.currentHoverOn == actionType then
    scaleY 1.9
  else 
    scaleY 2
    
  {- case actionType of
    0 -> filled green
    1 -> filled green
    _ -> filled black-}
    
--font size restrictions
showHideFontPlus fontSizeLevel = 
  if fontSizeLevel > 0.4 then
    scale 0
  else 
    scale 1
    
showHideFontMinus fontSizeLevel = 
  if fontSizeLevel < 0.3 then
    scale 0
  else 
    scale 1

-- zoom actions restrictions
showHideZoomIn zoomlevel = 
  if zoomlevel > 1.3 then
    scale 0
  else 
    scale 1
    
showHideZoomOut zoomlevel = 
  if zoomlevel < 0.9 then
    scale 0
  else 
    scale 1

showDuplicateMoveSection model =  -- show ghost circle section
      group 
      [ 
        circle 13 -- main circle
          -- |> text "cir1"
          -- |> filled (rgb 230 125 50)
          -- |> makeTransparent model.sliderValue
          -- |> identifyAndLoad model.duplicateShowAction bgcolor
          
          |> identifyAndLoad model.duplicateShowAction model.duplicateBgColor
          
          |> move (model.duplicateX, model.duplicateY)
          -- |> scale model.default_scale -- creating issue with element text dragging
          |> scale 1
          |> notifyMouseDownAt (MouseDownAt model.duplicateId)
          |> notifyMouseMoveAt (MouseMoveAt model.duplicateId)
          |> notifyLeave MouseLeave
          |> notifyMouseUp MouseUp

        , text "title" -- main circle text
          |> sansserif
          |> centered
          |> identifyAndLoadText model.duplicateShowAction
          -- |> scale (model.default_scale - 0.9) -- creating issue with element dragging
          |> scale 0.3
          |> move (model.duplicateX, model.duplicateY-1)

          |> notifyMouseDownAt (MouseDownAt model.duplicateId)
          |> notifyMouseMoveAt (MouseMoveAt model.duplicateId)
          |> notifyLeave MouseLeave
          |> notifyMouseUp MouseUp
                  
      ] |> showActionsForIdea model.duplicateShowAction
        
showGhostSection model =  -- show ghost square area section
       group [
            -- rect 75 75
            circle 14
              |> ghost -- transparent
              -- |> filled (rgb 0 66 55)
              --|> scale model.global_edit_action_ghost_values_scale
              -- global_edit_form_values
              -- showEditIdeaSection (0 0 0.5)
              --, showGhostSection 0 0 0
              -- , showEditIdeaSection -40 18 0.5
              |> move (model.global_edit_action_ghost_values_x, model.global_edit_action_ghost_values_y+1)
              |> notifyMouseMoveAt (MouseMoveAt model.duplicateId)
              |> notifyLeave MouseLeave
              |> notifyMouseUp MouseUp
              |> notifyMouseDownAt (MouseDownAt model.duplicateId)

            , circle 3 -- circle for new line - right side
              -- |> filled (rgb 0 0 225)
              |> filled (rgb 255 255 255)
              |> move (model.duplicateX + 18, model.duplicateY)
              -- |> move (x + 12, y+11) -- for showing action on top right
              -- |> notifyMouseDownAt (ShowEditIdeaBox model.duplicateId)
            
           , text "✎"
             |> centered
             -- |> filled white -- for filled (rgb 0 0 225) in circle
             |> filled black
             |> scale 0.4
             |> move (model.duplicateX + 18, model.duplicateY-1)
             -- |> move (x + 12, y+10) -- for showing action on top right
             |> notifyMouseDownAt (ShowEditIdeaBox model.duplicateId)
            
            -- remove option
            {- , circle 3 -- circle for new line - right side
            -- |> filled (rgb 0 0 225)
            |> filled (rgb 255 255 255)
            |> move (x + 13, y+14)
            -- |> move (x + 12, y+11) -- for showing action on top right
            |> notifyTap (RemoveFromList idea_id) -}
            -- , text "x"
            , text "🗑️"
              |> centered
              |> filled white
              |> scale 0.3
              -- |> move (x + 13, y+13) -- earlier
              |> move (model.duplicateX + 18, model.duplicateY+8)
              -- |> move (x + 12, y+10) -- for showing action on top right
              |> notifyTap (RemoveFromList model.duplicateId)
              -- remove option ends
            
            , circle 2
              |> filled (rgb 227 72 64) -- red
              |> move (model.duplicateX - 14, model.duplicateY - 16)
              |> notifyTap (UpdateMyColor (rgb 227 72 64) model.duplicateId)

            , circle 2
              |> filled (rgb 95 168 50) -- green
              |> move (model.duplicateX - 7, model.duplicateY - 16)
              |> notifyTap (UpdateMyColor (rgb 95 168 50) model.duplicateId)

            , circle 2
              |> filled (rgb 70 98 240) -- blue
              |> move (model.duplicateX, model.duplicateY - 16)
              |> notifyTap (UpdateMyColor (rgb 70 98 240) model.duplicateId)
            
            , circle 2
              |> filled (rgb 230 125 50) -- orange
              |> move (model.duplicateX + 7, model.duplicateY - 16)
              |> notifyTap (UpdateMyColor (rgb 230 125 50) model.duplicateId)
            
            , circle 2
              |> filled (rgb 209 207 65) -- yellow
              |> move (model.duplicateX + 14, model.duplicateY - 16)
              |> notifyTap (UpdateMyColor (rgb 209 207 65) model.duplicateId)
          ] |> showActionsForIdea model.duplicateShowAction
          

      {- |> notifyMouseDownAt (MouseDownAt idea_id)
      |> notifyMouseMoveAt (MouseMoveAt idea_id)
      |> notifyLeave MouseLeave
      |> notifyMouseUp MouseUp-}

showEditIdeaSection model = -- show ghost section
  (html 82 45 <| 
    Html.div [
      Html.Attributes.style "background-color" "#fff"
      , Html.Attributes.style "border" "2px solid #ddd"
      , Html.Attributes.style "height" "40px"
      -- , Html.Attributes.style "width" "100%"
      , Html.Attributes.style "padding" "0 5px"
    ]
    [ Html.input 
      [ Html.Attributes.placeholder "Text to reverse"
        , Html.Attributes.type_ "text"
        , Html.Attributes.style "width" "90%"
        , Html.Attributes.style "font-size" "5px"
        -- , Html.Attributes.value "title"
        , Html.Attributes.value (getEditingIdeaTitle model)
        , onInput (Change model.duplicateId)
      ] []
      , Html.br [] []
      , Html.input 
      [ Html.Attributes.type_ "button"
        , Html.Attributes.style "border" "1px solid #ddd"
        , Html.Attributes.style "font-size" "5px"
        , Html.Attributes.style "width" "100%"
        , Html.Attributes.value "Close"
        , onClick (CloseAction model.duplicateId)
      ] []
    ]
    -- [text "Hello!"]
    {- [ Html.button 
    --  [ onClick Decrement ] 
    [ Html.Attributes.text "Close" ] 
    ]-}
    --[ Html.a [ Html.Attributes.href "#", onClick Logout ] [ text "Close"] ]
    --[ Html.a [ Html.Attributes.href "#"] [ Html.text "Close"] ]
    ) -- |> scale model.global_edit_form_values_scale
    |> move (model.duplicateX - 45, model.duplicateY + 25)
    |> showActionsForEditIdea model.duplicateShowEditAction
    -- |> identifyAndLoadEdit showEditAction
    -- |> move (-40, 20)
    -- |> move (x - 40, y + 18)
         
getEditingIdeaTitle model = 
  let 
    selectedText = List.map -- for list + record type
                        getCurrentValue
                        model.allIdeas
    finalText = List.foldr (++)  ""  selectedText
  in
    finalText

getCurrentValue currentData = 
  if currentData.showEditAction == True then
    currentData.title
  else
    ""

        
updatepan: (Float, Float) -> (Float, Float)
updatepan (x,y) = (x + 30, y)

-- showActions
showActionsForEditIdea showAction = 
  if showAction == False then
    -- makeTransparent 0.8
    scale 0
  else
    -- makeTransparent 1
    scale 1
    
showActionsForIdea showAction = 
  if showAction == False then
    -- makeTransparent 0.8
    scale 0
  else
    -- makeTransparent 1
    scale 1

-- change background on selection of idea
identifyAndLoad showAction bgColor = 
  if showAction == False then
    -- makeTransparent 0.8
    filled bgColor
    -- (rgb 230 125 50)
  else
    -- makeTransparent 1
    -- outlined (solid 1) bgColor
    filled bgColor
    -- (rgb 230 125 50)

-- change color on selection of any idea text
identifyAndLoadText showAction = 
  if showAction == False then
    -- makeTransparent 0.8
    filled white
  else
    -- makeTransparent 1
    filled black

-- show edit box popup
identifyAndLoadEdit showEditAction = 
  if showEditAction == False then
    scale 0
  else
    scale 0.5

--newPoints model idea_id {x, y, title, showAction} =  -- for list + record type
  --line x y

processIfSelected model line_id = 
  if model.selectedLine == line_id then
    filled green
  else 
    filled gray
    -- outlined (solid 0.5) black

newLine model line_id {startX, startY, endX, endY} =  -- for list + record type
  group 
      [ 
        line (startX,startY) (endX,endY)
          |> outlined (solid 1) black
          |> notifyMouseDownAt (LineToBeSelected line_id 1) -- 1- left line starting, 2- right line ending

        , circle 1.2 -- starting point left side circle 
            -- |> filled red
            |> processIfSelected model line_id
            
            |> move (startX, startY)
            |> scale 1
            -- |> notifyTap 
            |> notifyMouseDownAt (LineToBeSelected line_id 1) -- 1- left line starting, 2- right line ending
            -- |> notifyMouseMoveAt (LineMouseMoveAt line_id) -- line_id create issue when on main big ghost it hovers and gets 9999 which is new line and finds first entry in list and start updating its ending point to remove this using global current selected line to update the point based on that
            |> notifyMouseMoveAt LineMouseMoveAt
            
         , circle 1.2 -- ending point right side circle 
            --|> filled green
            |> processIfSelected model line_id
            |> move (endX, endY)
                -- outlined (solid 1) bgColor
            |> scale 1
            |> notifyMouseDownAt (LineToBeSelected line_id 2) -- 1- left line starting, 2- right line ending
            -- |> notifyMouseMoveAt (LineMouseMoveAt line_id) -- line_id create issue when on main big ghost it hovers and gets 9999 which is new line and finds first entry in list and start updating its ending point to remove this using global current selected line to update the point based on that
            |> notifyMouseMoveAt LineMouseMoveAt
            
      ] |> scale model.zoom

newElement model idea_id {x, y, title, showAction, showEditAction, bgcolor} =  -- for list + record type
--newElement idea_id (x, y, title) =  -- for list + tuple type
    {- if model.selectedIdea == idea_id then
        model.default_scale = 1.5
    else
        model.default_scale = 1 -}
  -- in
    group 
      [ 
        circle 12 -- main circle
          -- |> text "cir1"
          -- |> filled (rgb 230 125 50)
          -- |> makeTransparent model.sliderValue
          |> identifyAndLoad showAction bgcolor
          |> move (x,y)
          -- |> scale model.default_scale -- creating issue with element text dragging
          |> scale 1
          |> notifyMouseDownAt (MouseDownAt idea_id)
          |> notifyMouseMoveAt (MouseMoveAt idea_id)
          |> notifyLeave MouseLeave
          |> notifyMouseUp MouseUp

        , text title -- main circle text
          |> sansserif
          |> centered
          |> identifyAndLoadText showAction
          -- |> scale (model.default_scale - 0.9) -- creating issue with element dragging
          |> scale model.defaultFontSize
          -- |> scale 0.3
          |> move (x,y-1)

          |> notifyMouseDownAt (MouseDownAt idea_id)
          |> notifyMouseMoveAt (MouseMoveAt idea_id)
          |> notifyLeave MouseLeave
          |> notifyMouseUp MouseUp        
         
      ] |> scale model.zoom
-- right action button
updateRightAction: (Float, Float) -> (Float, Float)
updateRightAction (x,y) = (x + 15.0, y)

updateRightActionText: (Float, Float) -> (Float, Float)
updateRightActionText (x,y) = (x + 15.0, y - 2.0)

-- left action buttons
updateLeftAction: (Float, Float) -> (Float, Float)
updateLeftAction (x,y) = (x - 15.0, y)

updateLeftActionText: (Float, Float) -> (Float, Float)
updateLeftActionText (x,y) = (x - 15.0, y - 2.0)

-- type for all messages
type Msg 
  = Tick Float GetKeyState
  -- pan/zoom messages
  | MouseDownAt Int (Float,Float)
  | MouseMoveAt Int (Float,Float)
  | MouseLeave
  | MouseEnter Int
  | MouseUp
  
  {-  IDEA for TREE STRUCTURE| NewRightIdea (Float, Float)
  | NewLeftIdea (Float, Float) -}
  -- | AddNewIdea (Float, Float)
  | AddNewIdea
  | UpdateMyColor Color Int
  | UpdateDefaultColor Color
  | ScaleIn
  | ScaleOut
  | IncreaseFontSize
  | DecreaseFontSize
  | RemoveFromList Int

  -- | LineMouseAt (Float,Float)
  | ActivateLineDrawing
  | LineToBeSelected Int Int (Float, Float)
  | LineMouseDownAt Int (Float, Float)
  -- | LineMouseMoveAt Int (Float, Float)  -- line_id create issue when on main big ghost it hovers and gets 9999 which is new line and finds first entry in list and start updating its ending point to remove this using global current selected line to update the point based on that
  | LineMouseMoveAt (Float, Float)
  | LineMouseUp
  
  -- updating context
  | Change Int String
  | CloseAction Int
  | ShowEditIdeaBox Int (Float, Float)
  
-- is the line creating
type LineState
  = Static
  | LineMovingDownLast (Float, Float)
  -- | NewLineMovingDownLast (Float, Float)
  
type MouseState
  = Waiting
  | MouseDownLast (Float,Float)

update msg model 
  = case msg of
      Tick t (keyQuery,_,_) -> 
        { model | time = t
                  , isZooming = Down == keyQuery Shift
                  , allPoints = 
                      if JustUp == keyQuery Delete then 
                        --deleteLine model
                        if model.selectedLine /= 9999 then
                          if model.lineDrawingStatus == True then
                            (List.take model.selectedLine model.allPoints) ++ (List.drop (model.selectedLine+1) model.allPoints)
                          else 
                            model.allPoints
                        else 
                          model.allPoints
                      else 
                        model.allPoints
                   , lineDragState = 
                       if JustUp == keyQuery Delete then 
                         Static
                       else 
                         model.lineDragState
                   
                   , selectedLine = 
                       if JustUp == keyQuery Delete then 
                         9998
                       else 
                         model.selectedLine
        }
        
      MouseDownAt idea_id (newx, newy) ->
        { model | mouseState = MouseDownLast (newx, newy)
          --, debug = "mouse clicked" ++ Debug.toString idea_id
          , selectedIdea = idea_id
          , allIdeas = List.indexedMap -- for list + record type
                        (updateDisplayValues idea_id model)
                        model.allIdeas
          
          , global_edit_action_ghost_values_scale = 0.5
          , global_edit_action_ghost_values_x = newx
          , global_edit_action_ghost_values_y = newy
          
          , duplicateShowAction = True
          , duplicateX = newx
          , duplicateY = newy
          , duplicateId = idea_id
        }
          --, selectedIdeaData = List.take idea_id model.ideas } -- tuple + list
          -- , selectedIdeaData = List.take idea_id model.allIdeas } -- recort + list
      MouseLeave ->
        { model | mouseState = Waiting --, debug = "leave: "
        -- ++ Debug.toString model.selectedIdea 
        -- ++ Debug.toString model.selectedIdeaData 
        -- ++ ", leave:" ++ Debug.toString model.ideas } -- tuple + list
        -- ++ ", lstatus:"++Debug.toString model.lineDrawingStatus++" leave:" ++ Debug.toString model.allIdeas 
        } -- recort + list
        
      MouseEnter id->
        { model | mouseState = Waiting, currentHoverOn = id
          -- , debug = "Enter: " ++ String.fromInt(id)
        -- ++ Debug.toString model.selectedIdea 
        -- ++ Debug.toString model.selectedIdeaData 
        -- ++ ", leave:" ++ Debug.toString model.ideas } -- tuple + list
        -- ++ ", lstatus:"++Debug.toString model.lineDrawingStatus++" leave:" ++ Debug.toString model.allIdeas 
        } -- recort + list
        
      MouseUp ->
        { model | mouseState = Waiting
          -- , debug = "moue up" 
        }
      
      MouseMoveAt idea_id (newx,newy) ->
        case model.mouseState of
          MouseDownLast (xLast,yLast) ->
            case model.isZooming of
              True -> { model | zoom = model.zoom * ( 1 + (newy-yLast)/64.0 )
                              , mouseState = MouseDownLast (newx,newy)
                      }
              False -> { model | allIdeas = List.indexedMap -- for list + record type
                        (udpateCurrentIdeaDragPos model.selectedIdea newx newy)
                        model.allIdeas 
                        
                        -- , debug = "Selected: " ++ Debug.toString model.selectedIdea ++ " Zoom: " ++ Debug.toString model.zoom
                        , duplicateShowAction = True
                        , duplicateX = newx
                        , duplicateY = newy
                        , duplicateId = idea_id

                        , global_edit_action_ghost_values_scale = 0.5
                        , global_edit_action_ghost_values_x = newx
                        , global_edit_action_ghost_values_y = newy
                        
                      }

          Waiting -> model

      AddNewIdea -> 
        { model | allIdeas = {x=50.0, y=-50.0, title="New", showAction=False, showEditAction=False, bgcolor=model.defaultColor, defaultFontSize=model.defaultFontSize} :: model.allIdeas } -- for list + record type
        -- (rgb 70 98 240)
      
      IncreaseFontSize -> 
        { model | defaultFontSize = model.defaultFontSize + 0.1, currentAction = 3 }
        
      DecreaseFontSize -> 
        { model | defaultFontSize = model.defaultFontSize - 0.1, currentAction = 4 }
        
      ScaleIn -> 
        { model | zoom = model.zoom + 0.1, currentAction = 1 }
        
      ScaleOut ->
        { model | zoom = model.zoom - 0.1, currentAction = 2 }

      UpdateDefaultColor newColor -> 
        { model | defaultColor = newColor}
        
      UpdateMyColor newColor idea_id -> 
        { model | allIdeas = List.indexedMap -- for list + record type
                        (updateColor newColor idea_id)
                        model.allIdeas 
                      }
      RemoveFromList idea_id ->
        {model | allIdeas = (List.take idea_id model.allIdeas) ++ (List.drop (idea_id+1) model.allIdeas) 
          , duplicateShowAction = False
          , duplicateShowEditAction = False
          , duplicateX = 0
          , duplicateY = 0
          , duplicateId = 9999
        }
        
      -- line 
      ActivateLineDrawing ->
        {model | lineDrawingStatus = (
          if model.lineDrawingStatus == True then
            False
          else 
            True
        ), lineDragState = if model.lineDrawingStatus == True then
            Static
          else 
            model.lineDragState, currentAction = 0 }
      
      LineToBeSelected line_id line_end_point (x, y) -> -- line_end_point -- 1-left (starting of line), 2-right (ending of line)
        { model | selectedLine = if model.lineDrawingStatus == True then
                      line_id
                    else
                      9999
                  -- , debug = "line #selected#" ++ Debug.toString line_id
                  , lineDragState = if model.lineDrawingStatus == True then
                      LineMovingDownLast (x, y)
                    else
                      Static
                  , selectedPoints = line_id
                  , selectedLineEndPoint = line_end_point

                  , allIdeas = List.indexedMap -- for list + record type
                                (checkAndHideEveryAction line_id)
                                model.allIdeas

        }
        
      LineMouseDownAt line_id (x, y) ->
        { model | lineDragState = if model.lineDrawingStatus == True then
              LineMovingDownLast (x, y)
            else 
              Static
          -- , debug = "mouse clicked for line, points"++Debug.toString model.allPoints
          , selectedLine = 9999
          , allPoints = (
              if model.lineDrawingStatus == True then
                if model.lineDragState == Static then
                  {startX=x, startY=y, endX=x, endY=y} :: model.allPoints-- for list + record type 
                else 
                  model.allPoints
              else 
                model.allPoints
            )
          
          , allIdeas = List.indexedMap -- for list + record type
                        (checkAndHideEveryAction line_id)
                        model.allIdeas
                        
          , duplicateShowAction = False
          , duplicateShowEditAction = False
          , duplicateX = 0
          , duplicateY = 0
          , duplicateId = 9999
          , currentHoverOn = 9999
          , currentAction = 9999
          , selectedLineEndPoint = 9999
          , selectedPoints = 9999
        }
        
      LineMouseUp ->
        { model | lineDragState = Static
          -- , debug = "line moue up" 
        }

      -- LineMouseMoveAt line_id (newx,newy) -> -- line_id create issue when on main big ghost it hovers and gets 9999 which is new line and finds first entry in list and start updating its ending point to remove this using global current selected line to update the point based on that
      LineMouseMoveAt (newx,newy) ->
        case model.lineDragState of
          LineMovingDownLast (xLast,yLast) ->
            { model | 
                    -- debug = "line "++Debug.toString model.lineDrawingStatus++" - "++Debug.toString model.lineDragState++" mouse moving at: "++String.fromFloat(newx)++"--"++String.fromFloat(newy), 
                    allPoints = 
                          if model.selectedLine /= 9999 then
                            if model.lineDrawingStatus == True then
                              if model.selectedLineEndPoint == 2 then
                                List.indexedMap -- for list + record type
                                  (updateSpecificLineRightPointValuesIndex newx newy model.selectedLine)
                                  model.allPoints 
                              else
                                List.indexedMap -- for list + record type
                                  (updateSpecificLineLeftPointValuesIndex newx newy model.selectedLine)
                                  model.allPoints 
                            else 
                              model.allPoints
                          else 
                            List.indexedMap -- for list + record type
                                (setNewLineEndPoint newx newy 9999)
                                model.allPoints
            }

          Static -> model
      -- line ends      
      
      -- updating context
      Change idea_id newContent ->
        { model | allIdeas = List.indexedMap -- for list + record type
                        (udpateCurrentIdeaText idea_id newContent)
                        model.allIdeas 
        }
      
      -- opening popup
      ShowEditIdeaBox idea_id (newx, newy) ->
        { model | allIdeas = List.indexedMap -- for list + record type
                        (openMyPopup idea_id)
                        model.allIdeas 
                  , duplicateShowEditAction = True
                  {-LAST TRY TO GET SELECTED ELEMENT TEXT TO POPULATE IT TO EDIT TEXTBOX, duplicateText = String.fromList List.indexedMap -- for list + record type
                        (getOpenMyPopup idea_id)
                        model.allIdeas -}
        }
        
      -- closing popup
      CloseAction idea_id ->
        { model | allIdeas = List.indexedMap -- for list + record type
                        (closeMyPopup idea_id)
                        model.allIdeas 
                  , duplicateShowEditAction = False
        }
      -- updating context ends

-- updating selected point start value
setNewLineEndPoint newX newY updating_line_id current_id pointRecord = 
  if updating_line_id == 9999 then -- updating newly created line
    if current_id == 0 then
      {startX=newX - 1, startY=newY + 1, endX=pointRecord.endX, endY=pointRecord.endY} -- update current selected entry
    else 
      {startX=pointRecord.startX, startY=pointRecord.startY, endX=pointRecord.endX, endY=pointRecord.endY} -- update current selected entry
  else if current_id == updating_line_id then
    {startX=newX-1, startY=newY+1, endX=pointRecord.endX, endY=pointRecord.endY} -- update current selected entry
  else
    {startX=pointRecord.startX, startY=pointRecord.startY, endX=pointRecord.endX, endY=pointRecord.endY} -- update current selected entry

-- updating selected point start value
updateSpecificLineLeftPointValuesIndex newX newY updating_line_id current_id pointRecord = 
  if current_id == updating_line_id then
    {startX=newX-1, startY=newY+1, endX=pointRecord.endX, endY=pointRecord.endY} -- update current selected entry
  else
    {startX=pointRecord.startX, startY=pointRecord.startY, endX=pointRecord.endX, endY=pointRecord.endY} -- update current selected entry

-- updating selected point end value
updateSpecificLineRightPointValuesIndex newX newY updating_line_id current_id pointRecord = 
  if current_id == updating_line_id then
    {startX=pointRecord.startX, startY=pointRecord.startY, endX=newX-1, endY=newY+1} -- update current selected entry
  else
    {startX=pointRecord.startX, startY=pointRecord.startY, endX=pointRecord.endX, endY=pointRecord.endY} -- update current selected entry


{- lastElem =
    List.foldl (Just >> always) Nothing -}
    
-- update my color action
updateColor newColor idea_id current_id ideaRecord =
  if current_id == idea_id then 
    {x=ideaRecord.x, y=ideaRecord.y, title=ideaRecord.title, showAction = ideaRecord.showAction, showEditAction = False, bgcolor = newColor, defaultFontSize = ideaRecord.defaultFontSize}
  else
    {x=ideaRecord.x, y=ideaRecord.y, title=ideaRecord.title, showAction = False, showEditAction = False, bgcolor = ideaRecord.bgcolor, defaultFontSize = ideaRecord.defaultFontSize}

-- check and hide every action
checkAndHideEveryAction idea_id current_id ideaRecord =
  if current_id == idea_id then 
    {x=ideaRecord.x, y=ideaRecord.y, title=ideaRecord.title, showAction = ideaRecord.showAction, showEditAction = True, bgcolor = ideaRecord.bgcolor, defaultFontSize = ideaRecord.defaultFontSize}
  else
    {x=ideaRecord.x, y=ideaRecord.y, title=ideaRecord.title, showAction = False, showEditAction = False, bgcolor = ideaRecord.bgcolor, defaultFontSize = ideaRecord.defaultFontSize}

-- open popup
openMyPopup idea_id current_id ideaRecord =
  if current_id == idea_id then 
    {x=ideaRecord.x, y=ideaRecord.y, title=ideaRecord.title, showAction = ideaRecord.showAction, showEditAction = True, bgcolor = ideaRecord.bgcolor, defaultFontSize = ideaRecord.defaultFontSize}
  else
    {x=ideaRecord.x, y=ideaRecord.y, title=ideaRecord.title, showAction = ideaRecord.showAction, showEditAction = ideaRecord.showEditAction, bgcolor = ideaRecord.bgcolor, defaultFontSize = ideaRecord.defaultFontSize}
    
getOpenMyPopup idea_id current_id ideaRecord =
  if current_id == idea_id then 
    ideaRecord.title
  else
    ideaRecord.title
    
-- closing popup
closeMyPopup idea_id current_id ideaRecord =
  if current_id == idea_id then 
    {x=ideaRecord.x, y=ideaRecord.y, title=ideaRecord.title, showAction = ideaRecord.showAction, showEditAction = False, bgcolor = ideaRecord.bgcolor, defaultFontSize = ideaRecord.defaultFontSize}
  else
    {x=ideaRecord.x, y=ideaRecord.y, title=ideaRecord.title, showAction = ideaRecord.showAction, showEditAction = ideaRecord.showEditAction, bgcolor = ideaRecord.bgcolor, defaultFontSize = ideaRecord.defaultFontSize}

-- update text of idea
udpateCurrentIdeaText idea_id newContent current_id ideaRecord =
  if current_id == idea_id then 
    {x=ideaRecord.x, y=ideaRecord.y, title=newContent, showAction = ideaRecord.showAction, showEditAction = ideaRecord.showEditAction, bgcolor = ideaRecord.bgcolor, defaultFontSize = ideaRecord.defaultFontSize}
  else
    {x=ideaRecord.x, y=ideaRecord.y, title=ideaRecord.title, showAction = ideaRecord.showAction, showEditAction = ideaRecord.showEditAction, bgcolor = ideaRecord.bgcolor, defaultFontSize = ideaRecord.defaultFontSize}
    
-- update drag position
udpateCurrentIdeaDragPos idea_id x1 y1 current_id ideaRecord =
  if current_id == idea_id then 
    {x=x1, y=y1, title=ideaRecord.title, showAction = ideaRecord.showAction, showEditAction = ideaRecord.showEditAction, bgcolor = ideaRecord.bgcolor, defaultFontSize = ideaRecord.defaultFontSize}
  else
    {x=ideaRecord.x, y=ideaRecord.y, title=ideaRecord.title, showAction = ideaRecord.showAction, showEditAction = ideaRecord.showEditAction, bgcolor = ideaRecord.bgcolor, defaultFontSize = ideaRecord.defaultFontSize}

-- show current selection
updateDisplayValues idea1_id model current1_id ideaRecord = 
  if current1_id == idea1_id then 
    {x=ideaRecord.x, y=ideaRecord.y, title=ideaRecord.title, showAction = True, showEditAction = ideaRecord.showEditAction, bgcolor = ideaRecord.bgcolor, defaultFontSize = ideaRecord.defaultFontSize}
  else
    {x=ideaRecord.x, y=ideaRecord.y, title=ideaRecord.title, showAction = False, showEditAction = ideaRecord.showEditAction, bgcolor = ideaRecord.bgcolor, defaultFontSize = ideaRecord.defaultFontSize}


type alias MyIdeas = 
  {
    x: Float,
    y: Float,
    ideaName: String,
    showAction: Bool,  -- to show action buttons if selected
    showEditAction: Bool,
    bgcolor: Color
  }
 
firstIdea = [{x=0,
              y=0,
              --title="Mind Mapping",
              title="Problem",
              -- title="Main Problem",
              showAction=False,
              showEditAction=False,
              bgcolor=(rgb 70 98 240),
              defaultFontSize=5
             }]

init =  { time = 0, 
        pan = (0,0), 
        zoom = 1, 
        isZooming = False, 
        mouseState = Waiting,
        debug = "",
        defaultColor = (rgb 70 98 240),
        defaultFontSize = 0.3,

        -- ideas
          selectedIdeaData = [],
          selectedIdea = 0, -- list index id from the "ideas" - default 0 as first index will be 0
          selectedLine = 0, -- list index id from the "ideas" - default 0 as first index will be 0
          selectedLineEndPoint = 9999, -- 9999- initialized, 1- left starting of line, 2-line end point
           
          default_scale = 1.2,
          
          duplicateBgColor = (rgb 70 98 240),
          duplicateShowAction = False,
          duplicateShowEditAction = False,
          duplicateX = 0,
          duplicateY = 0,
          duplicateText = "",
          duplicateId = 9999,
          
          currentHoverOn = 9999, -- currentAction -> 0- line, 1- zoom in, 2- zoom out, 3- Font++, 4- Font--
          currentAction = 9999, -- currentAction -> 1- zoom in, 2- zoom out, 3- Font++, 4- Font--
          
          global_edit_action_ghost_values_x = 0,
          global_edit_action_ghost_values_y = 0,
          global_edit_action_ghost_values_scale = 0.0,

          ideas = [(0, 0, "data"), (15, 15, "data")], -- tuple list
          allIdeas = firstIdea, -- record list - inuse
        
        -- lines 
          allPoints = [], -- record list - inuse
          selectedPoints = 0, -- list index id from the "ideas" - default 0 as first index will be 0
          lineDragState = Static,
          lineDrawingStatus = False,

        -- updating context
        content= ""
        }
