{-# OPTIONS --without-K --rewriting #-}

open import HoTT
open import homotopy.FinWedge

module homotopy.Bouquet where

Rose : ∀ {i} (I : Type i) → Type i
Rose I = BigWedge {A = I} (λ _ → ⊙S¹)

Bouquet-family : ∀ {i} (I : Type i) (m : ℕ) → (I → Ptd₀)
Bouquet-family I m _ = ⊙Sphere m

Bouquet : ∀ {i} (I : Type i) (m : ℕ) → Type i
Bouquet I m = BigWedge (Bouquet-family I m)

⊙Bouquet : ∀ {i} (I : Type i) (m : ℕ) → Ptd i
⊙Bouquet I m = ⊙BigWedge (Bouquet-family I m)

BouquetLift-family : ∀ {i} (I : Type i) (m : ℕ) → (I → Ptd i)
BouquetLift-family {i} I m _ = ⊙Lift {j = i} (⊙Sphere m)

BouquetLift : ∀ {i} (I : Type i) (m : ℕ) → Type i
BouquetLift {i} I m = BigWedge (BouquetLift-family I m)

⊙BouquetLift : ∀ {i} (I : Type i) (m : ℕ) → Ptd i
⊙BouquetLift {i} I m = ⊙BigWedge (BouquetLift-family I m)

FinBouquetLift-family : ∀ {i} (I m : ℕ) → (Fin I → Ptd i)
FinBouquetLift-family {i} I m _ = ⊙Lift {j = i} (⊙Sphere m)

⊙FinBouquetLift : ∀ {i} (I m : ℕ) → Ptd i
⊙FinBouquetLift I m = ⊙FinWedge (FinBouquetLift-family I m)

FinBouquet-family : (I m : ℕ) → (Fin I → Ptd₀)
FinBouquet-family I m _ = ⊙Sphere m

FinBouquet : (I m : ℕ) → Type₀
FinBouquet I m = FinWedge (FinBouquet-family I m)

⊙FinBouquet : (I m : ℕ) → Ptd₀
⊙FinBouquet I m = ⊙FinWedge (FinBouquet-family I m)
