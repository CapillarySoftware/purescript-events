module Control.Reactive.Event.Spec where

import Control.Monad.ST
import Control.Reactive.Event
import Control.Timer
import Test.Mocha
import Test.Chai
import Context

d'          = { wowzers : "in my trousers" }
sampleEvent = newEvent "foo" d'

spec = describe "Control.Monad.Event" do

  it "events should dispatch without error"
    let emitTheFoo = getContext >>= emitOn sampleEvent
    in  expect emitTheFoo `toNotThrow` Error

  itAsync "subscribeEventedOn hears emitted events" \done -> do
    w <- getContext
    subscribeEventedOn "foo" (const $ itIs done) w
    emitOn sampleEvent w

  itAsync "subscribeEventedOn should receive any attached data" \done -> do
    w <- getContext
    flip (subscribeEventedOn "foo") w \event -> do
      expect (unwrapEventDetail event) `toDeepEqual` d'
      itIs done
    emitOn sampleEvent w

  itAsync "emit and subscribeEvented should be global" \done -> do
    subscribeEvented "foo" <<< const $ itIs done
    emit sampleEvent

  itAsync "unsubscribe cancels a subscription" \done -> do
    isSubbed <- newSTRef false
    sub      <- subscribeEvented "foo" <<< const <<< modifySTRef isSubbed $ const true

    unsubscribe sub
    emit sampleEvent

    timeout 10 do
      isSubbed' <- readSTRef isSubbed
      expect isSubbed' `toEqual` false
      itIs done
  it "eventDMap maps over the details data passing area"
    let
      gadget = "gadget"
      mapped = eventDMap (\d -> d { wowzers = gadget }) sampleEvent
    in do
      expect (unwrapEventDetail mapped) `toDeepEqual` { wowzers : gadget}
      expect (unwrapEventName   mapped) `toEqual`     (unwrapEventName   sampleEvent)
      expect (unwrapEventDetail mapped) `toNotEqual`  (unwrapEventDetail sampleEvent)

  it "eventNMap maps over the name of the event"
    let
      merv   = "Merv Griffen"
      mapped = eventNMap (const merv) sampleEvent
    in do
      expect (unwrapEventDetail mapped) `toDeepEqual` (unwrapEventDetail sampleEvent)
      expect (unwrapEventName   mapped) `toEqual`     merv
      expect (unwrapEventName   mapped) `toNotEqual`  (unwrapEventName   sampleEvent)
