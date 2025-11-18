/**
 *
 * Description :    Alimentation de la table arrondissement
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          int_arrondissement
 * Cible :          arrondissement
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_arrondissement as
(
    select
        arrondissement_annee,
        arrondissement_annee_last_flag,
        arrondissement_code,
        arrondissement_hk,
        arrondissement_bk,
        arrondissement_libelle,
        commune_hk

    from "wh_dp_silver"."int"."int_arrondissement"
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_arrondissement
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale