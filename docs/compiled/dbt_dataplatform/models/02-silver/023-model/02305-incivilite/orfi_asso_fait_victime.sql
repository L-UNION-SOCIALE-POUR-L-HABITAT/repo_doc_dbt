/**
 *
 * Description :    Alimentation de la table orfi_asso_fait_victime
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_asso_fait_victime
 * Cible :          orfi_asso_fait_victime
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_asso_fait_victime as
(
    select
        orfi_asso_fait_victime_hk,
        orfi_asso_fait_victime_id_code,
        orfi_fait_hk,
        orfi_fait_id_code,
        orfi_victime_hk,
        orfi_victime_id_code

    from "wh_dp_silver"."int"."int_orfi_asso_fait_victime"
),




-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_asso_fait_victime
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale