/**
 *
 * Description :    Alimentation de la table ept
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          int_epci
 * Cible :          epci 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_ept as
(
    select
        ept_annee,
        ept_annee_last_flag,
        ept_code,
        ept_libelle,
        ept_hk,
        ept_bk
        --epci_code,
        --epci_hk

    from "wh_dp_silver"."int"."int_ept"
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from cte_int_ept
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale