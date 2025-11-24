/**
 *
 * Description :    Alimentation de la table orfi_secteur
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_secteur
 * Cible :          orfi_secteur
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_secteur as
(
    select
        orfi_secteur_hk,
        orfi_secteur_id,
        orfi_secteur_libelle,
        orfi_patrimoine_id,
        orfi_secteur_code

    from "wh_dp_silver"."int"."int_orfi_secteur"
),


-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_secteur
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale