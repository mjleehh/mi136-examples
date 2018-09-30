module State exposing (..)

import Uuid exposing (Uuid)

type alias Entry =
    {
        id: Maybe Uuid,
        name: String,
        surname: Maybe String,
        company: Maybe String,
        email: String,
        phone: Maybe String,
        tags: List String
    }

type Tabs = LIST | CREATE

type alias UiState =
    {
        tab: Tabs,
        search: Maybe String,
        newEntry: Entry
    }

type alias DataState = {entries: List Entry}

type alias State =
    {
        ui: UiState,
        data: DataState
    }

initialEntry : Entry
initialEntry =
    {
        id = Nothing,
        name = "",
        surname = Nothing,
        company = Nothing,
        email = "",
        phone = Nothing,
        tags = []
    }

initialState : State
initialState =
    {
        ui = {
            tab = LIST,
            search = Nothing,
            newEntry = initialEntry
        },
        data = {
            entries = sampleList
        }
    }

sampleEntry name surname company phone email tags =
    {
        id = Nothing,
        name = name,
        surname = Just surname,
        company = Just company,
        email = email,
        phone = Just phone,
        tags = tags
    }

sampleList : List Entry
sampleList =
    [
        sampleEntry "Bob" "Rich" "Big Money Corp" "87143981" "bob.rich@bigmoney.com" ["biz", "job", "golf"],
        sampleEntry "Jeff" "Dollar" "World Petroleum Ltd" "239874893" "jeff@wp.com" ["headhunters", "newjob"]
    ]