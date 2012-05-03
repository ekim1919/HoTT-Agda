{-# OPTIONS --without-K #-}

open import Types
open import Paths
open import Contractible

module Equivalences where

hfiber : {i j : Level} {A : Set i} {B : Set j} (f : A → B) (y : B) → Set _
hfiber {A = A} f y = Σ A (λ x → f x ≡ y)

is-equiv : {i j : Level} {A : Set i} {B : Set j} (f : A → B) → Set _
is-equiv {B = B} f = (y : B) → is-contr (hfiber f y)

infix 4 _≃_  -- \simeq

_≃_ : {i j : Level} (A : Set i) (B : Set j) → Set _
A ≃ B = Σ (A → B) is-equiv

-- Notation for the application of an equivalence to an argument

infix 1 _$_

_$_ : {i j : Level} {A : Set i} {B : Set j} (f : A ≃ B) (x : A) → B
f $ x = (π₁ f) x

inverse : {i j : Level} {A : Set i} {B : Set j} (f : A ≃ B) → B → A
inverse (f , e) y = π₁ (π₁ (e y))

inverse-right-inverse : {i j : Level} {A : Set i} {B : Set j} (f : A ≃ B) (y : B) → (f $ ((inverse f) y)) ≡ y
inverse-right-inverse (f , e) y = π₂ (π₁ (e y))

inverse-left-inverse : {i j : Level} {A : Set i} {B : Set j} (f : A ≃ B) (x : A) → (inverse f) (f $ x) ≡ x
inverse-left-inverse (f , e) x = ! (base-path (π₂ (e (f x)) (x , refl (f x))))

hfiber-triangle : {i j : Level} {A : Set i} {B : Set j} (f : A → B) (z : B) {x y : hfiber f z} (p : x ≡ y) → map f (base-path p) ∘ (π₂ y) ≡ π₂ x
hfiber-triangle f z (refl _) = refl _

inverse-triangle : {i j : Level} {A : Set i} {B : Set j} (f : A ≃ B) (x : A) →
  inverse-right-inverse f (f $ x) ≡ map (π₁ f) (inverse-left-inverse f x)
inverse-triangle f x = move1!-left-on-left _ _ (hfiber-triangle (π₁ f) _ (π₂ (π₂ f (f $ x)) (x , refl (π₁ f x)))) ∘ opposite-map (π₁ f) _

equiv-is-inj : {i j : Level} {A : Set i} {B : Set j} (f : A ≃ B) (x y : A) (p : (f $ x) ≡ (f $ y)) → x ≡ y
equiv-is-inj f x y p = ! (inverse-left-inverse f x) ∘ (map (inverse f) p ∘ inverse-left-inverse f y)

abstract
  adjiso-is-eq : {i j : Level} {A : Set i} {B : Set j}
    (f : A → B) (g : B → A) (h : (y : B) → f (g y) ≡ y) (h' : (x : A) → g (f x) ≡ x) (adj : (x : A) → map f (h' x) ≡ h (f x)) → is-equiv f
  adjiso-is-eq f g h h' adj = λ y → ((g y , h y) , (λ y' → total-path (! (h' (π₁ y')) ∘ map g (π₂ y'))
    (trans-fx≡a f _ (! (h' (π₁ y')) ∘ map g (π₂ y')) (π₂ y') ∘
      move-right-on-right (! (map f (! (h' (π₁ y')) ∘ map g (π₂ y')))) (π₂ y') (h y)
       (map ! (map-concat f (! (h' (π₁ y'))) (map g (π₂ y')))
       ∘ (opposite-concat (map f (! (h' (π₁ y')))) (map f (map g (π₂ y'))) ∘
            (whisker-left (! (map f (map g (π₂ y')))) (opposite-map f (! (h' (π₁ y'))) ∘ map (map f) (opposite-opposite (h' (π₁ y'))))
       ∘ ((whisker-left (! (map f (map g (π₂ y')))) (adj (π₁ y'))
       ∘ whisker-right (h (f (π₁ y'))) (map ! (compose-map g f (π₂ y')) ∘ opposite-map (λ x → f (g x)) (π₂ y')))
       ∘ homotopy-naturality-toid (λ x → f (g x)) h (! (π₂ y')))))))))

abstract 
  iso-is-adjiso : {i j : Level} {A : Set i} {B : Set j} (f : A → B) (g : B → A) (h : (y : B) → f (g y) ≡ y) (h' : (x : A) → g (f x) ≡ x)
    → Σ ((x : A) → g (f x) ≡ x) (λ h'' → (x : A) → map f (h'' x) ≡ h (f x))
  iso-is-adjiso f g h h' = ((λ x → ! (map g (map f (h' x))) ∘ (map g (h (f x)) ∘ h' x)) ,
    (λ x → map-concat f (! (map g (map f (h' x)))) (map g (h (f x)) ∘ h' x)
         ∘ (whisker-right (map f (map g (h (f x)) ∘ h' x)) (! (opposite-map f (map g (map f (h' x)))))
         ∘ move!-right-on-left (map f (map g (map f (h' x)))) (map f (map g (h (f x)) ∘ h' x)) (h (f x))
           (map-concat f (map g (h (f x))) (h' x)
         ∘ (whisker-right (map f (h' x)) (compose-map g f (h (f x)))
         ∘ ((whisker-right (map f (h' x)) {q = map (λ x' → f (g x')) (h (f x))}
               {r = h (f (g (f x)))} (anti-whisker-right (h (f x))
           (homotopy-naturality-toid (λ y → f (g y)) h (h (f x))))
         ∘ ! (homotopy-naturality-toid (λ x' → f (g x')) h (map f (h' x))))
         ∘ whisker-right (h (f x)) (! (compose-map g f (map f (h' x))))))))))

abstract
  iso-is-eq : {i j : Level} {A : Set i} {B : Set j}
    (f : A → B) (g : B → A) (h : (y : B) → f (g y) ≡ y) (h' : (x : A) → g (f x) ≡ x) → is-equiv f
  iso-is-eq f g h h' = adjiso-is-eq f g h (π₁ (iso-is-adjiso f g h h')) (π₂ (iso-is-adjiso f g h h'))

-- The inverse of an equivalence is an equivalence

inverse-is-equiv : {i j : Level} {A : Set i} {B : Set j} (f : A ≃ B) → is-equiv (inverse f)
inverse-is-equiv f = iso-is-eq _ (π₁ f) (λ y → inverse-left-inverse f y) (inverse-right-inverse f)

_⁻¹ : {i j : Level} {A : Set i} {B : Set j} (f : A ≃ B) → B ≃ A  -- \^-\^1
_⁻¹ f = (inverse f , inverse-is-equiv f)

-- Any contractible type is equivalent to the unit type
contr-equiv-unit : {i : Level} {A : Set i} (e : is-contr A) → A ≃ unit {i}
contr-equiv-unit e = ((λ _ → tt) , iso-is-eq _ (λ _ → π₁ e) (λ y → refl tt) (λ x → ! (π₂ e x)))