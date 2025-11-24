/**
 *
 * Description :    Alimentation de la table orfi_processus
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_processus
 * Cible :          orfi_processus
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_processus as
(
    select
        orfi_processus_hk,
        orfi_processus_id,
        orfi_processus_libelle

    from "wh_dp_silver"."int"."int_orfi_processus"
),


-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_processus
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale