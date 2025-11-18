/**
 *
 * Description :    Alimentation de la table dim_patrimoine_sortie
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          patrimoine_sortie
 * Cible :          dim_patrimoine_sortie
 * Dimension créée a partir de la table de mapping map_patrimoine_sortie
 * Le patrimoine_sortie qu'on affiche est une aggrégation du patrimoins sortie qu'on a en source
 */




-- Selection des tables et des colonnes
with cte_map_patrimoine_sortie as
(
    select 
        patrimoine_sortie_code_gold
        , patrimoine_sortie_gold_libelle
    from   
        "wh_dp_bronze"."seed"."map_patrimoine_sortie"
),

cte_default_values as 
(
    select
        'N/A'               as patrimoine_sortie_code,
        'Mise en service'   as patrimoine_sortie_libelle
),

-- Filtre, union et renommage
cte_dim_patrimoine_sortie as 
(
    select distinct
        patrimoine_sortie_code_gold                as patrimoine_sortie_code,
        patrimoine_sortie_gold_libelle             as patrimoine_sortie_libelle
        
    from 
        cte_map_patrimoine_sortie

    union all
    
    select 
        patrimoine_sortie_code,
        patrimoine_sortie_libelle
    from cte_default_values  
),

-- Ajout des clés techniques
cte_hk_dim_patrimoine_sortie as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(patrimoine_sortie_code as varchar(max))
    
)  
 
   as patrimoine_sortie_hk
         

    from 
        cte_dim_patrimoine_sortie
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
        cte_hk_dim_patrimoine_sortie
)

 
select 
    *
from 
    cte_finale