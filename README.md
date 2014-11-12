# Module Documentation

[![Build Status](https://travis-ci.org/CapillarySoftware/purescript-events.svg?branch=master)](https://travis-ci.org/CapillarySoftware/purescript-events)
[![Bower version](https://badge.fury.io/bo/purescript-events.svg)](http://badge.fury.io/bo/purescript-events)
[![Dependency Status](https://www.versioneye.com/user/projects/54701aa5810106ab5d0004a1/badge.svg?style=flat)](https://www.versioneye.com/user/projects/54701aa5810106ab5d0004a1)

## Module Control.Reactive.Event

### Types

    data Event d where
      Event :: EventName -> { detail :: {  | d }, cancelable :: Boolean, bubbles :: Boolean } -> Event

    type EventName  = String


### Values

    eventDMap :: forall a b. ({  | a } -> {  | b }) -> Event a -> Event b

    eventNMap :: forall a. (EventName -> EventName) -> Event a -> Event a

    newEvent :: forall d. EventName -> {  | d } -> Event d

    unsubscribe :: forall eff. Subscription -> Eff (reactive :: Reactive | eff) Unit



