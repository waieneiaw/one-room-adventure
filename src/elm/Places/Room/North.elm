module Places.Room.North exposing (Model, init, update, view)

import Images.Board
import Images.Door
import Images.Hole
import Images.Paper
import Images.Wall
import Svg exposing (Svg)
import Types.Argument
import Types.Command
import Types.Command.Noun
import Types.Command.Verb
import Types.Item
import Types.Object


type alias Model =
    { door : Types.Object.Openable
    , board : Types.Object.Plain
    , hole : Types.Object.Openable
    , screw : Types.Object.Plain
    , paper2 : Types.Object.Plain
    }


init : Model
init =
    { door =
        Types.Object.Locked
            { feature =
                { type_ = Types.Item.None
                , name = "ドア（DOOR）"
                }
            }
    , board =
        { status = Types.Object.Exist
        , feature =
            { type_ = Types.Item.None
            , name = "板（BOARD）"
            }
        }
    , hole =
        Types.Object.Locked
            { feature =
                { type_ = Types.Item.None
                , name = "壁の穴（HOLE）"
                }
            }
    , screw =
        { status = Types.Object.Exist
        , feature =
            { type_ = Types.Item.None
            , name = "ねじ（SCREW）"
            }
        }
    , paper2 =
        { status = Types.Object.Exist
        , feature =
            { type_ = Types.Item.PaperOfMachineTips
            , name = "紙2（PAPER2）"
            }
        }
    }


update :
    Types.Argument.UpdateDirectionArgs Model
    -> ( Model, Types.Command.Result )
update { items, model, command } =
    let
        message : String -> ( Model, Types.Command.Result )
        message text =
            ( model, Types.Command.resultWithMessage text )

        noop =
            ( model, Types.Command.resultNg )
    in
    case command.noun of
        ------------
        -- ONLY VERB
        ------------
        Types.Command.Noun.None ->
            case command.verb of
                Types.Command.Verb.Look ->
                    let
                        door =
                            Types.Object.getOpenableState model.door

                        hole =
                            Types.Object.getOpenableState model.hole
                    in
                    case model.hole of
                        Types.Object.Opened _ ->
                            message
                                (door.feature.name
                                    ++ "と"
                                    ++ hole.feature.name
                                    ++ "があります。"
                                )

                        _ ->
                            message
                                (door.feature.name
                                    ++ "と"
                                    ++ model.board.feature.name
                                    ++ "があります。"
                                )

                _ ->
                    noop

        ------------
        -- Board
        ------------
        Types.Command.Noun.Board ->
            let
                target =
                    model.board
            in
            case command.verb of
                Types.Command.Verb.Look ->
                    if target.status == Types.Object.Exist then
                        message
                            ("金属の板です。"
                                ++ "ネジでしっかり固定されています。"
                            )

                    else
                        noop

                _ ->
                    noop

        ------------
        -- Door
        ------------
        Types.Command.Noun.Door ->
            let
                target =
                    model.door
            in
            case command.verb of
                Types.Command.Verb.Look ->
                    case target of
                        Types.Object.Locked _ ->
                            message
                                ("妙に背の低いドアです。"
                                    ++ "鍵がかかっているようです。"
                                )

                        Types.Object.Closed state ->
                            ( { model
                                | door =
                                    Types.Object.Opened state
                              }
                            , Types.Command.resultOk
                            )

                        _ ->
                            message
                                "妙に背の低いドアです。"

                Types.Command.Verb.Close ->
                    case target of
                        Types.Object.Opened state ->
                            ( { model
                                | door = Types.Object.Closed state
                              }
                            , Types.Command.resultOk
                            )

                        _ ->
                            noop

                Types.Command.Verb.Open ->
                    case target of
                        Types.Object.Closed state ->
                            ( { model
                                | door = Types.Object.Opened state
                              }
                            , Types.Command.resultOk
                            )

                        _ ->
                            noop

                Types.Command.Verb.Take ->
                    message "さすがに無理です。"

                _ ->
                    noop

        ------------
        -- Hole
        ------------
        Types.Command.Noun.Hole ->
            let
                target =
                    model.hole

                item =
                    model.paper2
            in
            case command.verb of
                Types.Command.Verb.Look ->
                    case target of
                        Types.Object.Opened _ ->
                            if item.status == Types.Object.Exist then
                                message
                                    (item.feature.name
                                        ++ "が置いてあります。"
                                    )

                            else
                                message
                                    "何もありません。"

                        _ ->
                            noop

                _ ->
                    noop

        ------------
        -- Paper2
        ------------
        Types.Command.Noun.PaperOfMachineTips ->
            let
                place =
                    model.hole
            in
            case command.verb of
                Types.Command.Verb.Look ->
                    case place of
                        Types.Object.Opened _ ->
                            if model.paper2.status == Types.Object.Exist then
                                message
                                    "何か書かれています。"

                            else
                                noop

                        _ ->
                            noop

                Types.Command.Verb.Read ->
                    case place of
                        Types.Object.Opened _ ->
                            if model.paper2.status == Types.Object.Exist then
                                message
                                    ("何かの暗号のようなものが書かれていますが、"
                                        ++ "取らないと読めません。"
                                    )

                            else
                                noop

                        _ ->
                            noop

                Types.Command.Verb.Take ->
                    case place of
                        Types.Object.Opened _ ->
                            if model.paper2.status == Types.Object.Exist then
                                ( { model
                                    | paper2 =
                                        { status = Types.Object.Lost
                                        , feature = model.paper2.feature
                                        }
                                  }
                                , Types.Command.resultWithItem model.paper2
                                )

                            else
                                noop

                        _ ->
                            noop

                _ ->
                    noop

        ------------
        -- ITEM
        ------------
        Types.Command.Noun.GoldKey ->
            case command.verb of
                Types.Command.Verb.Use ->
                    let
                        goldKey =
                            Types.Item.getItem items Types.Item.GoldKey
                    in
                    case model.door of
                        Types.Object.Locked state ->
                            case goldKey of
                                Just _ ->
                                    ( { model
                                        | door = Types.Object.Opened state
                                      }
                                    , Types.Command.resultWithMessage "ドアの鍵が開きました。"
                                    )

                                _ ->
                                    noop

                        _ ->
                            noop

                _ ->
                    noop

        Types.Command.Noun.Screwdriver ->
            case command.verb of
                Types.Command.Verb.Use ->
                    let
                        screwdriver =
                            Types.Item.getItem items Types.Item.Screwdriver
                    in
                    case model.hole of
                        Types.Object.Locked state ->
                            case screwdriver of
                                Just _ ->
                                    ( { model
                                        | hole = Types.Object.Opened state
                                        , board =
                                            { status = Types.Object.Broken
                                            , feature = state.feature
                                            }
                                      }
                                    , Types.Command.resultWithMessage "板が外れました。"
                                    )

                                _ ->
                                    noop

                        _ ->
                            noop

                _ ->
                    noop

        ------------
        -- NoOp
        ------------
        _ ->
            noop


view : Model -> List (Svg msg)
view model =
    [ Images.Wall.view
    , Images.Door.view model.door { x = 360, y = 196 }
    , Images.Hole.view { x = 120, y = 180 }
    , Images.Paper.view model.paper2 { x = 160, y = 275 }
    , Images.Board.view model.board { x = 120, y = 180 }
    ]
