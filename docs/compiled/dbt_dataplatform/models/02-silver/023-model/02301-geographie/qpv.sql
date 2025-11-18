/**
 *
 * Description :    Alimentation de la table qpv
 * Fréquence :      Annuel
 * Mode :           Full refresh / overwrite
 * Source:          int_qpv
 * Cible :          qpv
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_qpv as
(
    select
        qpv_hk,
        qpv_bk,
        qpv_annee,
        qpv_annee_last_flag,
        qpv_code,
        qpv_libelle

    from "wh_dp_silver"."int"."int_qpv"
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from cte_int_qpv
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale