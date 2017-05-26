-- |
--   Copyright   :  (c) Sam Truzjan 2013
--   License     :  BSD3
--   Maintainer  :  pxqr.sta@gmail.com
--   Stability   :  experimental
--   Portability :  portable
--
--   An efficient implementation of dense integer sets based on
--   Big-Endian PATRICIA trees with buddy suffix compression.
--
--   References:
--
--     * Fast Mergeable Integer Maps (1998) by Chris Okasaki, Andrew Gill
--       <http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.37.5452>
--
--   This implementation performs espessially well then set contains
--   long integer invervals like @[0..2047]@ that are just merged into
--   one interval description. This allow to perform many operations
--   in constant time and space. However if set contain sparse
--   integers like @[1,12,7908,234,897]@ the same operations will take
--   /O(min(W, n))/ which is good enough in most cases.
--
--   Conventions in complexity notation:
--
--     * n — number of elements in a set;
--
--     * W — number bits in a 'Key'. This is 32 or 64 at 32 and 64 bit
--     platforms respectively;
--
--     * O(n) or O(k) — means this operation have complexity O(n) in
--     worst case (e.g. sparse set) or O(k) in best case (e.g. one
--     single interval).
--
--   Note that some operations will take centuries to compute. For
--   example @map id universe@ will a long time to end as well as
--   'filter' applied to 'universe', 'naturals', 'positives' or
--   'negatives'.
--
--   Also note that some operations like 'union', 'intersection' and
--   'difference' have overriden from default fixity, so use these
--   operations with infix syntax carefully.
--
{-# LANGUAGE CPP #-}
{-# LANGUAGE Safe #-}

module Data.IntervalSet
       (
         -- * Types
         IntSet(..), Key

         -- * Query
         -- ** Cardinality
       , SB.null
       , size

         -- ** Membership
       , member, notMember

         -- ** Inclusion
       , isSubsetOf, isSupersetOf
--       , isProperSubsetOf, isProperSupersetOf

         -- * Construction
       , empty
       , singleton
       , interval
{-
       , naturals
       , negatives
       , universe
-}
         -- * Modification
       , insert
       , delete

         -- * Map Fold Filter
       , SB.map
       , SB.foldr
       , SB.filter

         -- * Splits
       , split, splitGT, splitLT
       , partition

         -- * Min/Max
       , findMin, findMax

         -- * Combine
       , union, unions
       , intersection, intersections
       , difference, symDiff

         -- ** Monoids
       , Union, Intersection, Difference

         -- * Conversion
         -- *** Arbitary
       , elems
       , toList, fromList

         -- *** Ordered
       , toAscList, toDescList
       , fromAscList

#if defined (TESTING)
         -- * Debug
       , isValid, splitFin
#endif
       ) where

import Data.IntervalSet.Internal as SB
