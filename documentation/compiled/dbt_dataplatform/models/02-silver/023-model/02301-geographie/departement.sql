/**
 *
 * Description :    Alimentation de la table departement
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          int_departement
 * Cible :          departement
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_departement as
(
    select
        departement_annee,
        departement_annee_last_flag,
        departement_code,
        departement_libelle,
        departement_hk,
        departement_bk,
        region_hk,
        region_code,
        region_av15_hk,
        region_av15_code

    from "wh_dp_silver"."int"."int_departement"
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_departement
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
    
from 
    cte_finale