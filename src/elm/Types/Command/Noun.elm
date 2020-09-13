module Types.Command.Noun exposing (Noun(..), fromString)


type Noun
    = None
    | Never
    | Door
    | Paper
    | Desk


fromString : Maybe String -> Noun
fromString value =
    let
        noun =
            value
                |> Maybe.map (\value_ -> String.toLower value_)
    in
    case noun of
        Just "door" ->
            Door

        Just "paper" ->
            Paper

        Just "desk" ->
            Desk

        Nothing ->
            None

        _ ->
            Never
