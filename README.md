# Module Documentation

[![Build Status](https://travis-ci.org/CapillarySoftware/purescript-events.svg?branch=master)](https://travis-ci.org/CapillarySoftware/purescript-events)

## Module Control.Reactive.Event

### Types

    data Event d where
      Event :: EventName -> { detail :: {  | d }, cancelable :: Boolean, bubbles :: Boolean } -> Event d

    type EventName  = String


### Values

    eventDMap :: forall a b. ({  | a } -> {  | b }) -> Event a -> Event b

    eventNMap :: forall a. (EventName -> EventName) -> Event a -> Event a

    newEvent :: forall d. EventName -> {  | d } -> Event d

    unsubscribe :: forall eff. Subscription -> Eff (reactive :: Reactive | eff) Unit



