module Places.Room.West exposing (Model, init, update, view)

import Images.Wall
import Svg exposing (Svg)
import Types.Command
import Types.Command.Noun
import Types.Command.Verb
import Types.Payload


type alias Model =
    {}


init : Model
init =
    Model


noResults : Model -> ( Model, Types.Command.Result )
noResults model =
    ( model, Types.Command.noResults )


update :
    Types.Payload.UpdateDirectionPayload Model
    -> ( Model, Types.Command.Result )
update { model, command } =
    case ( command.verb, command.noun ) of
        ( Types.Command.Verb.Look, Types.Command.Noun.None ) ->
            ( model
            , Types.Command.resultWithoutItem
                "西を向いています。何もありません。"
            )

        _ ->
            noResults model


view : Model -> List (Svg msg)
view _ =
    [ Images.Wall.view
    ]
