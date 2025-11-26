
  
    
    
    USE [wh_dp_gold];
    
    

    EXEC('create view "dbo"."dim_construction_periode__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table dim_construction_periode
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          ref_dataplatform
 * Cible :          dim_construction_periode
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

-- Filtrage, renommage, typage
cte_dim_construction_periode as 
(
    select 
        code                as construction_periode_code,
        libelle             as construction_periode_libelle,
        cast(val1 as int)   as construction_periode_min,
        cast(val2 as int)   as construction_periode_max
    from 
        cte_ref_dataplatform
    where 
        objet = ''dim_construction_periode''
),

-- Ajout des clés techniques
cte_hk_dim_construction_periode as
(
    select 
        *
        , 
     
        HASHBYTES(''SHA2_256'', 
    
        cast(construction_periode_code as varchar(max))
    
)  
 
   as construction_periode_hk
         

    from 
        cte_dim_construction_periode
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
        cte_hk_dim_construction_periode
)

 
select 
    *
from 
    cte_finale;');




    
    EXEC('CREATE TABLE "wh_dp_gold"."dbo"."dim_construction_periode__dbt_temp" AS SELECT * FROM "wh_dp_gold"."dbo"."dim_construction_periode__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  