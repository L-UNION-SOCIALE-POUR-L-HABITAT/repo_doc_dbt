
  
    
    
    USE [wh_dp_gold];
    
    

    EXEC('create view "dbo"."dim_departement__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table dim_departement
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          commune
 * Cible :          dim_departement
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_departement as
(
    select 
        departement_code,
        departement_libelle,
        region_code,
        region_av15_code,
        departement_annee_last_flag
    
    from
        "wh_dp_silver"."dbo"."departement"

),

-- Application des filtres 
cte_filtered_departement as
(
    select 
       
        departement_code,
        departement_libelle,
        region_code,
        region_av15_code

    from
        cte_departement
    where
        departement_annee_last_flag = 1
),

-- Ajout des clés techniques (différentes de la couche silver car sans année )
cte_hk_filtered_departement as
(
    select 
        *
        , 
     
        HASHBYTES(''SHA2_256'', 
    
        cast(departement_code as varchar(max))
    
)  
 
    as departement_hk
        , 
     
        HASHBYTES(''SHA2_256'', 
    
        cast(region_code as varchar(max))
    
)  
 
         as region_hk
        , 
     
        HASHBYTES(''SHA2_256'', 
    
        cast( region_av15_code as varchar(max))
    
)  
 
   as  region_av15_hk

    from 
        cte_filtered_departement
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from
        cte_hk_filtered_departement
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale;');




    
    EXEC('CREATE TABLE "wh_dp_gold"."dbo"."dim_departement__dbt_temp" AS SELECT * FROM "wh_dp_gold"."dbo"."dim_departement__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  