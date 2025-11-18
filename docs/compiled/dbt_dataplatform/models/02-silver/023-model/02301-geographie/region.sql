/**
 *
 * Description :    Alimentation de la table region
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          int_region
 * Cible :          region 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_region as
(
    select
        region_annee,
        region_annee_last_flag,
        region_code,
        region_libelle,
        region_hk,
        region_bk,
        region_idf_flag,
        region_outre_mer_flag,
        region_outre_mer_flag_libelle

    from "wh_dp_silver"."int"."int_region"
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from cte_int_region
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale