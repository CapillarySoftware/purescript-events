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

    newEvent :: forall d. EventName -> {  | d } -> Event d

    eventDMap :: forall a b. ({  | a } -> {  | b }) -> Event a -> Event b

    eventNMap :: forall a. (EventName -> EventName) -> Event a -> Event a
    
    unwrapEventDetail :: forall d. Event d -> { | d}
    
    unwrapEventName :: forall d. Event d -> EventName  
    
    subscribeEvented :: forall a d eff. EventName -> (Event d -> EffR eff a) -> EffR eff Subscription
    
    subscribeEventedOn :: forall a d o eff. EventName -> (Event d -> EffR eff a) -> o -> EffR eff Subscription
    
    emit :: forall d eff. Event d -> EffR eff Context

    emitOn :: forall d o eff. Event d -> o -> EffR eff o 
    
    unsubscribe :: forall eff. Subscription -> Eff (reactive :: Reactive | eff) Unit
    




