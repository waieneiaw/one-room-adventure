module Types.Object exposing (Object(..))

import Types.Item


type Object
    = Exist Types.Item.Item
    | NotExist
