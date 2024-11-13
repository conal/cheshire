{-# OPTIONS --safe #-}

module Cheshire.Core where

module 𝕃 where
  open import Level renaming (Level to t) public

module 𝟙 where
  open import Data.Unit.Polymorphic renaming (⊤ to t) public

module Rel₁ where
  open import Relation.Unary hiding (∅; U) public
  open import Relation.Unary.Polymorphic public

module Rel₂ where
  open import Relation.Binary public
  open import Relation.Binary.PropositionalEquality public
  import Relation.Binary.Reasoning.Setoid as SetoidR
  module SetoidReasoning {s₁ s₂} (S : Setoid s₁ s₂) = SetoidR S

open 𝕃 using (_⊔_) public
open Rel₂ using (Rel) public

record Quiver o ℓ : Set (𝕃.suc (o ⊔ ℓ)) where
  no-eta-equality
  constructor mk⇒
  infix 4 _⇒_
  field
    {Ob} : Set o
    Hom : Rel Ob ℓ

  _⇒_ : Rel Ob ℓ
  _⇒_ = Hom

open Quiver using (Ob; Hom) public

private
  variable
    o ℓ : 𝕃.t

_[_,_] : (𝒬 : Quiver o ℓ) → Rel (𝒬 .Ob) ℓ
𝒬 [ a , b ] = 𝒬 .Hom a b

module _ (𝒬 : Quiver o ℓ) where

  open Quiver 𝒬

  record Equivalence (e : 𝕃.t) : Set (o ⊔ ℓ ⊔ 𝕃.suc e) where
    infix  4 _≈_
    field
      _≈_ : ∀ {A B} → Rel (A ⇒ B) e
      equiv : ∀ {A B} → Rel₂.IsEquivalence (_≈_ {A} {B})

    setoid : {A B : 𝒬 .Ob} → Rel₂.Setoid ℓ e
    setoid {A} {B} = record
      { Carrier       = A ⇒ B
      ; _≈_           = _≈_
      ; isEquivalence = equiv
      }

    module Equiv {A B : 𝒬 .Ob} = Rel₂.IsEquivalence (equiv {A} {B})
    module EdgeReasoning {A B : 𝒬 .Ob} = Rel₂.SetoidReasoning (setoid {A} {B})

    open Equiv public

  open Equivalence ⦃ … ⦄ public
