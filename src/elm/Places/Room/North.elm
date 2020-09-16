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


noResults : Model -> ( Model, Types.Command.Result )
noResults model =
    ( model, Types.Command.noResults )


update :
    Types.Argument.UpdateDirectionArgs Model
    -> ( Model, Types.Command.Result )
update { items, model, command } =
    case ( command.verb, command.noun ) of
        ( Types.Command.Verb.Open, Types.Command.Noun.Door ) ->
            case model.door of
                Types.Door.Locked ->
                    ( model
                    , Types.Command.resultWithoutItem
                        "鍵がかかっているようです。"
                    )

                Types.Door.Unlocked _ ->
                    ( { model
                        | door = Types.Door.Unlocked { opened = True }
                      }
                    , Types.Command.resultWithoutItem
                        "ドアを開けました。"
                    )

        ( Types.Command.Verb.Close, Types.Command.Noun.Door ) ->
            ( { model
                | door = Types.Door.Unlocked { opened = False }
              }
            , Types.Command.resultWithoutItem
                "ドアを閉めました。"
            )

        ( Types.Command.Verb.Look, Types.Command.Noun.Door ) ->
            ( model
            , Types.Command.resultWithoutItem
                "何の変哲もないドアです。"
            )

        ( Types.Command.Verb.Look, Types.Command.Noun.Paper ) ->
            case model.paper of
                Types.Object.Exist _ ->
                    ( model
                    , Types.Command.resultWithoutItem
                        "壁に貼り付けられています。取れそうです。"
                    )

                _ ->
                    noResults model

        ( Types.Command.Verb.Look, Types.Command.Noun.None ) ->
            let
                paper =
                    case model.paper of
                        Types.Object.Exist _ ->
                            "、紙切れ(PAPER)"

                        _ ->
                            ""
            in
            ( model
            , Types.Command.resultWithoutItem
                ("目の前にドア(DOOR)"
                    ++ paper
                    ++ "があります。"
                )
            )

        ( Types.Command.Verb.Take, Types.Command.Noun.Door ) ->
            ( model
            , Types.Command.resultWithoutItem
                "さすがに無理です。"
            )

        ( Types.Command.Verb.Take, Types.Command.Noun.Paper ) ->
            case model.paper of
                Types.Object.Exist item ->
                    ( { model
                        | paper = Types.Object.NotExist
                      }
                    , Types.Command.resultWithItem "紙を取りました。"
                        item
                    )

                _ ->
                    noResults model

        ( Types.Command.Verb.Use, Types.Command.Noun.Key ) ->
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
                            noResults model

                _ ->
                    noResults model

        _ ->
            noResults model


view : Model -> List (Svg msg)
view model =
    [ Images.Wall.view
    , Images.Door.view model.door { x = 360, y = 196 }
    , Images.Paper.view model.paper { x = 100, y = 200 }
    ]
