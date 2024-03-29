{-# LANGUAGE BangPatterns #-}

module Interpreter ( execCBV, execCBN ) where

import AbsLambdaNat
import ErrM
import PrintLambdaNat

import Data.Map ( Map )
import qualified Data.Map as M


execCBV :: Program -> Exp
execCBV (Prog e) = evalCBV e

evalCBV :: Exp -> Exp
evalCBV e@(EApp e1 e2) = case (evalCBV e1) of
    -- Haskell is lazy (similar to call-by-name) and to get the correct strict behaviour of
    -- call-by-value, we use the Bang pattern in `!e2'` to explicitly force evaluation.
    -- If we simply wrote `evalCBV (subst i (evalCBV e2) e1')` we would get the same 
    -- behaviour as `evalCBN`.
    (EAbs i e1') -> let !e2' = evalCBV e2 in evalCBV (subst i e2' e1')
    e1' -> EApp e1' e2
evalCBV x = x


execCBN :: Program -> Exp
execCBN (Prog e) = evalCBN e


evalCBN :: Exp -> Exp
evalCBN (EApp e1 e2) = case (evalCBN e1) of
    (EAbs i e1') -> evalCBN (subst i e2 e1')
    e1' -> EApp e1' e2
evalCBN x = x


-- A quick and dirty way of getting fresh names. Rather inefficient for big terms...
fresh_ :: Exp -> String
fresh_ (EVar (Id i)) = i ++ "0"
fresh_ (EApp e1 e2) = fresh_ e1 ++ fresh_ e2
fresh_ (EAbs (Id i) e) = i ++ fresh_ e
fresh_ _ = "0"

fresh = Id . fresh_

subst :: Id -> Exp -> Exp -> Exp
subst id s (EVar id') | id == id' = s
                      | otherwise = EVar id'
subst id s (EApp e1 e2) = EApp (subst id s e1) (subst id s e2)
subst id s e@(EAbs id' e') = 
    -- to avoid variable capture, we first substitute id' with a fresh name inside the body
    -- of the λ-abstraction, obtaining e''. 
    -- Only then do we proceed to apply substitution of the original s for id in the 
    -- body e''.
    let f = fresh e 
        e'' = subst id' (EVar f) e' in 
        EAbs f $ subst id s e''
subst _ _ e@(ENat _) = e

