-- | Monoidal wrappers for applicative functors. Useful to define tree
-- folds.

-- These are the same as in the 'reducers' package. We do not use
-- 'reducers' to avoid its dependencies.

{- License for the 'reducers' package
Copyright 2008-2011 Edward Kmett

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

3. Neither the name of the author nor the names of his contributors
   may be used to endorse or promote products derived from this software
   without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
-}

{-# LANGUAGE CPP #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Test.Tasty.Runners.Reducers where

import Data.Monoid hiding ((<>))
import Data.Semigroup (Semigroup(..))
import Control.Applicative
import Prelude  -- Silence AMP import warnings

-- | Monoid generated by '*>'
newtype Traversal f = Traversal { getTraversal :: f () }
instance Applicative f => Semigroup (Traversal f) where
  Traversal f1 <> Traversal f2 = Traversal $ f1 *> f2
instance Applicative f => Monoid (Traversal f) where
  mempty = Traversal $ pure ()
#if !(MIN_VERSION_base(4,11,0))
  Traversal f1 `mappend` Traversal f2 = Traversal $ f1 *> f2
#endif

-- | Monoid generated by @'liftA2' ('<>')@
newtype Ap f a = Ap { getApp :: f a }
  deriving (Functor, Applicative, Monad)
instance (Applicative f, Semigroup a) => Semigroup (Ap f a) where
  (<>) = liftA2 (<>)
instance (Applicative f, Monoid a) => Monoid (Ap f a) where
  mempty = pure mempty
#if !(MIN_VERSION_base(4,11,0))
  mappend = liftA2 mappend
#endif
