/**
 *
 * Description :    Alimentation de la table de correspondance qpv_commune
 * Fréquence :      Annuel
 * Mode :           Full refresh / overwrite
 * Source:          int_qpv_commune
 * Cible :          qpv_commune 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_qpv_commune as
(
    select
        qpv_commune_bk,
        qpv_commune_hk,
        qpv_commune_annee,
        qpv_commune_annee_last_flag,
        qpv_code,
        --qpv_libelle,
        commune_code,
        qpv_hk,
        commune_hk

    from "wh_dp_silver"."int"."int_qpv_commune"
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from cte_int_qpv_commune
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale