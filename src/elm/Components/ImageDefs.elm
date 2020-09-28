module Components.ImageDefs exposing (defs)

import Images.Board
import Images.Box
import Images.BoxDoor
import Images.BronzeKey
import Images.Cushion
import Images.Desk
import Images.Door
import Images.GoldKey
import Images.Hole
import Images.LowerDrawer
import Images.Machine
import Images.Notebook
import Images.Paper
import Images.Rack
import Images.Safe
import Images.SafeDoor
import Images.Screwdriver
import Images.Sofa
import Images.UpperDrawer
import Images.Wall
import Svg


defs : Svg.Svg msg
defs =
    Svg.defs []
        [ Images.Wall.defs
        , Images.Board.defs
        , Images.Box.defs
        , Images.BoxDoor.defs
        , Images.BronzeKey.defs
        , Images.Cushion.defs
        , Images.Desk.defs
        , Images.Door.defs
        , Images.GoldKey.defs
        , Images.Notebook.defs
        , Images.LowerDrawer.defs
        , Images.Machine.defs
        , Images.Paper.defs
        , Images.Rack.defs
        , Images.Hole.defs
        , Images.Safe.defs
        , Images.SafeDoor.defs
        , Images.Screwdriver.defs
        , Images.Sofa.defs
        , Images.UpperDrawer.defs
        ]
