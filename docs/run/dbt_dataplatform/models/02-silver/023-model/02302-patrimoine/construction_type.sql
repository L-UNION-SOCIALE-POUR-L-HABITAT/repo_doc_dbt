
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."construction_type__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table construction_type
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          ref_dataplatform
 * Cible :          construction_type
 */



-- Selection des tables et des colonnes
with cte_ref_dataplatform as
(
    select 
        objet,
        code, 
        libelle,
        val1
    from   
        "wh_dp_bronze"."seed"."ref_dataplatform"
),

-- Filtre et renommage
cte_construction_type as 
(
    select 
        code                as construction_type_code,
        libelle             as construction_type_libelle,
        val1                as construction_type_libelle_court
    from 
        cte_ref_dataplatform
    where 
        objet = ''construction_type''
    
    union all

    select
        ''N/A''          as construction_type_code,
        ''Non disponible''  as construction_type_libelle,
        ''Non disponible''  as construction_type_libelle_court
 
),

-- Ajout des clés techniques
cte_hk_construction_type as
(
    select 
        *
        , 
     
        HASHBYTES(''SHA2_256'', 
    
        cast(construction_type_code as varchar(max))
    
)  
 
   as construction_type_hk
         

    from 
        cte_construction_type
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
        cte_hk_construction_type
)

 
select 
    *
from 
    cte_finale;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."dbo"."construction_type__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."construction_type__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  