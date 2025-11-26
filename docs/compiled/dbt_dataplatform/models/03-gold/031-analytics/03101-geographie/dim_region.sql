/**
 *
 * Description :    Alimentation de la table dim_region
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          region
 * Cible :          dim_region
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_region as
(
    select 
  
        region_code,
        region_libelle,
        region_idf_flag,
        region_outre_mer_flag,
        region_annee_last_flag
    
    from
        "wh_dp_silver"."dbo"."region"

),

-- Application des filtres 
cte_filtered_region as
(
    select 
       
        region_code,
        region_libelle,
        region_idf_flag,
        region_outre_mer_flag

    from
        cte_region
    where
       region_annee_last_flag = 1 
),

-- Ajout des clés techniques (différentes de la couche silver car sans année )
cte_hk_filtered_region as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(region_code as varchar(max))
    
)  
 
       as region_hk

    from 
        cte_filtered_region
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
        cte_hk_filtered_region
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale