module Types.Direction exposing (Direction(..), toString)


type Direction
    = East
    | West
    | South
    | North


toString : Direction -> String
toString direction =
    case direction of
        North ->
            "North"

        West ->
            "West"

        East ->
            "East"

        South ->
            "South"
