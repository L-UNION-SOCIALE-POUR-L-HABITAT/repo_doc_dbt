/**
 *
 * Description :    Alimentation de la table quartier iris
 * Fréquence :      Annuel
 * Mode :           Full refresh / overwrite
 * Source:          int_quartier_iris
 * Cible :          quartier_iris
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_quartier_iris as
(
    select
        quartier_iris_hk,
        quartier_iris_bk,
        quartier_iris_annee,
        quartier_iris_annee_last_flag,
        quartier_iris_code,
        quartier_iris_libelle,
        commune_code,
        commune_hk,
        arrondissement_code,
        arrondissement_hk

    from "wh_dp_silver"."int"."int_quartier_iris"
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from cte_int_quartier_iris
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale