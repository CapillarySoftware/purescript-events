module Control.Reactive.Event
( EventName(..), Event(..)
, newEvent, eventDMap, eventNMap
, unwrapEventDetail, unwrapEventName
, emitOn, subscribeEventedOn
, emit, subscribeEvented
, unsubscribe
, EffR()
) where

import Control.Monad.Eff
import Control.Reactive
import Data.Function
import Context

type EventName = String

type EffR eff = Eff (reactive :: Reactive | eff)

data Event d = Event EventName {
  bubbles    :: Boolean,
  cancelable :: Boolean,
  detail     :: { | d }
}

eventDMap :: forall a b. ({ | a} -> { | b}) -> Event a -> Event b
eventDMap f (Event n d) = Event n $ d { detail = (f d.detail) }

eventNMap :: forall a. (EventName -> EventName) -> Event a -> Event a
eventNMap f (Event n d) = Event (f n) d

newEvent :: forall d. EventName -> { | d} -> Event d
newEvent n d = Event n {
  bubbles    : true,
  cancelable : false,
  detail     : d
}

unwrapEventDetail :: forall d. Event d -> { | d}
unwrapEventDetail (Event n d) = d.detail
unwrapEventName   :: forall d. Event d -> EventName
unwrapEventName   (Event n d) = n

-- Shamlessly ripped off from
-- https://raw.githubusercontent.com/d4tocchini/customevent-polyfill/master/CustomEvent.js

foreign import customEventPolyFill """
  var CustomEvent, context = PS.Context.getContext();
  CustomEvent = function(event, params) {
    var evt;
    params = params || {
      bubbles: false,
      cancelable: false,
      detail: undefined
    };
    evt = document.createEvent('CustomEvent');
    evt.initCustomEvent(event, params.bubbles, params.cancelable, params.detail);
    return evt;
  };
  CustomEvent.prototype = context.Event.prototype;
  context.CustomEvent = CustomEvent;
  function customEventPolyFill(){
    console.log('This function was born depricated. Welcome to the future.');
  };
""" :: forall a. a -> Unit

foreign import emitOn_ """
  function emitOn_(n, d, o){
    return function(){
      var e = new CustomEvent(n, d);
      o.dispatchEvent(e);
      return o;
    };
  }
""" :: forall d o eff. Fn3 EventName { | d} o (EffR eff o)

emitOn :: forall d o eff. Event d -> o -> EffR eff o 
emitOn (Event n d) o = runFn3 emitOn_ n d o

foreign import subscribeEventedOn_ """
  function subscribeEventedOn_(n, obj, fn){
    return function(){
      var fnE = function (event) { return fn(event)(); };
      obj.addEventListener(n, fnE);
      return function(){ obj.removeEventListener(n, fnE); };
    };
  }
""" :: forall d a o eff. Fn3 EventName o (d -> EffR eff a) (EffR eff Subscription)

subscribeEventedOn :: forall a d o eff. EventName
  -> (Event d -> EffR eff a)
  -> o
  -> EffR eff Subscription
subscribeEventedOn n f o = runFn3 subscribeEventedOn_ n o
  \{"type" = t, detail = d} -> f $ newEvent t d

foreign import unsubscribe """
  function unsubscribe(sub){
    return function(){
      sub();
      return {};
    };
  }
""" :: forall eff. Subscription -> EffR eff Unit

emit :: forall d eff. Event d -> EffR eff Context
emit ev              = getContext >>= emitOn ev
subscribeEvented :: forall a d eff. EventName -> (Event d -> EffR eff a) -> EffR eff Subscription
subscribeEvented n f = getContext >>= subscribeEventedOn n f
