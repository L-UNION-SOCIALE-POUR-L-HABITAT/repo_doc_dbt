/**
 *
 * Description :    Alimentation de la table dim_construction_type
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          construction_type
 * Cible :          dim_construction_type 
 */


 
-- Selection des tables et des colonnes
with cte_construction_type as
(
    select 
        construction_type_hk
        , construction_type_code
        , construction_type_libelle
        , construction_type_libelle_court
    from   
        "wh_dp_silver"."dbo"."construction_type"
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_construction_type
)

 
select 
    *
from 
    cte_finale