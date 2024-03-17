--- STEAMODDED HEADER
--- MOD_NAME: Test Deck
--- MOD_ID: TestDeck
--- MOD_AUTHOR: [Kenny Stone]
--- MOD_DESCRIPTION: trying to change card backs
----------------------------------------------
------------MOD CODE -------------------------

-- Config: DISABLE UNWANTED MODS HERE
local config = {
    -- Decks
    evenStevenDeck = true,
}

-- Helper functions
local function is_even(card)
    local id = card:get_id()
    return id <= 10 and id % 2 == 0
end

-- Local variables
--local lu = SMODS.CardBackInjection()

-- Initialize deck effect
local Backapply_to_runRef = Back.apply_to_run
function Back.apply_to_run(arg_56_0)
    Backapply_to_runRef(arg_56_0)

    -- Even Steven Deck
    if arg_56_0.effect.config.only_evens then
        G.E_MANAGER:add_event(Event({
            func = function()
                -- Loop over all cards
                for i = #G.playing_cards, 1, -1 do
                    -- Remove odd cards
                    if not is_even(G.playing_cards[i]) then
                        G.playing_cards[i]:start_dissolve(nil, true)
                    end
                end

                -- Add Even Steven Joker
                local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_even_steven', nil)
                card:add_to_deck()
                G.jokers:emplace(card)
                return true
            end
        }))
    end
end

-- Create Localization
local locs = {
    evenStevenDeck = {
        name = "Even Steven's Deck",
        text = {
            "Start run with only",
            "{C:attention}even cards{} and",
            "the {C:attention}Even Steven{} joker"
        }
    },
}

-- Create Decks
local decks = {
    evenStevenDeck = {
        name = "Even Steven's Deck",
        config = { only_evens = true },
        sprite = { x = 0, y = 5 }
    }
}

function SMODS.INIT.TestDeck()

    -- Initialize Decks
    for key, value in pairs(decks) do
        if config[key] then
            local newDeck = SMODS.Deck:new(value.name, key, value.config, value.sprite, locs[key])
            newDeck:register()
        end
    end
end

----------------------------------------------
------------MOD CODE END----------------------
