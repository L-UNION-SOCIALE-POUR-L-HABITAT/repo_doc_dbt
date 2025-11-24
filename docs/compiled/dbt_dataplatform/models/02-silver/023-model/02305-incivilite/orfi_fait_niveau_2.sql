/**
 *
 * Description :    Alimentation de la table orfi_fait_niveau_2
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_fait_niveau_2
 * Cible :          orfi_fait_niveau_2
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_fait_niveau_2 as
(
    select
        orfi_fait_niveau_2_hk,
        orfi_fait_niveau_2_id,
        orfi_fait_niveau_2_libelle,
        orfi_fait_niveau_1_id

    from "wh_dp_silver"."int"."int_orfi_fait_niveau_2"
),








-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_fait_niveau_2
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale