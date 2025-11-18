/**
 *
 * Description :    Alimentation de la table dim_organisme_famille
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          ref_dataplatform
 * Cible :          dim_organisme_famille
 */



-- Selection des tables et des colonnes
with cte_ref_dataplatform as
(
    select 
        objet,
        code, 
        libelle,
        val1,
        val2
    from   
        "wh_dp_bronze"."seed"."ref_dataplatform"
),

-- Filtre et renommage
cte_dim_organisme_famille as 
(
    select 
        code                as organisme_famille_code,
        libelle             as organisme_famille_libelle,
        cast(val1 as bit)   as hlm_flag,
        cast(val2 as int)   as display_order
    from 
        cte_ref_dataplatform
    where 
        objet = 'dim_organisme_famille'
),

-- Ajout des clés techniques
cte_hk_dim_organisme_famille as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(organisme_famille_code as varchar(max))
    
)  
 
   as organisme_famille_hk
         

    from 
        cte_dim_organisme_famille
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
        cte_hk_dim_organisme_famille
)

 
select 
    *
from 
    cte_finale