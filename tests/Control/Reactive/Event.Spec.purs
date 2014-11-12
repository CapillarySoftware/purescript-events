module Control.Reactive.Event.Spec where

import Control.Monad.ST
import Control.Reactive.Event
import Control.Reactive.Timer
import Test.Mocha
import Test.Chai

d'          = { wowzers : "in my trousers" }
sampleEvent = newEvent "foo" d'

spec = describe "Control.Monad.Event" do
    
  window <- getWindow

  it "events should dispatch without error" 
    let emitTheFoo = getWindow >>= emitOn sampleEvent
    in expect emitTheFoo `toNotThrow` Error

  itAsync "subscribeEventedOn hears emitted events" \done -> do
    subscribeEventedOn "foo" (const $ itIs done) window
    emitOn sampleEvent window

  itAsync "subscribeEventedOn should receive any attached data" \done -> do         
    flip (subscribeEventedOn "foo") window \event -> do 
      expect (unwrapEventDetail event) `toDeepEqual` d'
      itIs done
    emitOn sampleEvent window

  itAsync "emit and subscribeEvented should be global" \done -> do 
    subscribeEvented "foo" <<< const $ itIs done
    emit sampleEvent

  itAsync "unsubscribe cancels a subscription" \done -> do
    isSubbed <- newSTRef false
    sub      <- subscribeEvented "foo" <<< const <<< 
      modifySTRef isSubbed $ const true

    unsubscribe sub     
    emit sampleEvent

    timeout 10 do
      isSubbed' <- readSTRef isSubbed
      expect isSubbed' `toEqual` false
      itIs done

  -- describe "maps" do 

  --   it "eventDMap maps over the details data passing area" do 
  --     let mapped = eventDMap (\d -> d { wowzers = "gadget" }) sampleEvent      
  --     expect (unwrapEventDetail mapped) `toDeepEqual` { wowzers : "gadget"}
      -- expect (unwrapEventName mapped) `toEqual` (unwrapEventName sampleEvent)
      -- expect (unwrapEventDetail mapped) `toNotEqual` (unwrapEventDetail sampleEvent)

  --   it "eventNMap maps over the name of the event" $ do
  --     let mapped = eventNMap (\_ -> "Merv Griffen") sampleEvent
  --     expect (unwrapEventDetail mapped) `toDeepEqual` (unwrapEventDetail sampleEvent)
  --     expect (unwrapEventName mapped) `toEqual` "Merv Griffen"
  --     expect (unwrapEventName mapped) `toNotEqual` (unwrapEventName sampleEvent)