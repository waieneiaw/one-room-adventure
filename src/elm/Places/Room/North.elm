module Places.Room.North exposing (Model, init, update, view)

import Images.Door
import Images.Paper
import Images.Wall
import Svg exposing (Svg)
import Types.Argument
import Types.Command
import Types.Command.Noun
import Types.Command.Verb
import Types.Door
import Types.Item
import Types.Object


type alias Model =
    { door : Types.Door.Door
    , paper : Types.Object.Object
    }


init : Model
init =
    let
        door =
            Types.Door.Locked

        paper =
            Types.Object.Exist
                { type_ = Types.Item.Paper
                , name = "紙（PAPER）"
                , weight = 1
                }
    in
    Model
        door
        paper


update :
    Types.Argument.UpdateDirectionArgs Model
    -> ( Model, Types.Command.Result )
update { items, model, command } =
    let
        message : String -> ( Model, Types.Command.Result )
        message text =
            ( model, Types.Command.resultWithoutItem text )

        noop =
            ( model, Types.Command.noResults )
    in
    case ( command.noun, command.verb ) of
        ------------
        -- ONLY VERB
        ------------
        ( Types.Command.Noun.None, Types.Command.Verb.Look ) ->
            case model.paper of
                Types.Object.Exist _ ->
                    message "目の前にドア(DOOR)と紙(PAPER)があります。"

                _ ->
                    message "目の前にドア(DOOR)があります。"

        ------------
        -- Door
        ------------
        ( Types.Command.Noun.Door, Types.Command.Verb.Open ) ->
            case model.door of
                Types.Door.Locked ->
                    message
                        "鍵がかかっているようです。"

                Types.Door.Unlocked _ ->
                    ( { model
                        | door = Types.Door.Unlocked { opened = True }
                      }
                    , Types.Command.resultWithoutItem
                        "ドアを開けました。"
                    )

        ( Types.Command.Noun.Door, Types.Command.Verb.Close ) ->
            ( { model
                | door = Types.Door.Unlocked { opened = False }
              }
            , Types.Command.resultWithoutItem
                "ドアを閉めました。"
            )

        ( Types.Command.Noun.Door, Types.Command.Verb.Look ) ->
            message "何の変哲もないドアです。"

        ( Types.Command.Noun.Door, Types.Command.Verb.Take ) ->
            message "さすがに無理です。"

        ------------
        -- Paper
        ------------
        ( Types.Command.Noun.Paper, Types.Command.Verb.Look ) ->
            case model.paper of
                Types.Object.Exist _ ->
                    message "壁に貼り付けられています。取れそうです。"

                _ ->
                    noop

        ( Types.Command.Noun.Paper, Types.Command.Verb.Take ) ->
            case model.paper of
                Types.Object.Exist item ->
                    ( { model
                        | paper = Types.Object.NotExist
                      }
                    , Types.Command.resultWithItem item
                    )

                _ ->
                    noop

        ------------
        -- Key
        ------------
        ( Types.Command.Noun.Key, Types.Command.Verb.Use ) ->
            let
                key =
                    Types.Item.getItem items Types.Item.Key
            in
            case model.door of
                Types.Door.Locked ->
                    case key of
                        Just _ ->
                            ( { model
                                | door = Types.Door.Unlocked { opened = False }
                              }
                            , Types.Command.resultWithoutItem "鍵が開きました。"
                            )

                        _ ->
                            noop

                _ ->
                    noop

        _ ->
            noop


view : Model -> List (Svg msg)
view model =
    [ Images.Wall.view
    , Images.Door.view model.door { x = 360, y = 196 }
    , Images.Paper.view model.paper { x = 100, y = 200 }
    ]
