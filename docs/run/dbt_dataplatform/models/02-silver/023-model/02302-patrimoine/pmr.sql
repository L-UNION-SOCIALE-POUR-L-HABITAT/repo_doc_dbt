
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."pmr__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table pmr
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          ref_dataplatform
 * Cible :          pmr
 */




    
    
    
    select
        code as pmr_code,
        libelle as pmr_libelle,
        
     
        HASHBYTES(''SHA2_256'', 
    
        cast(code as varchar(max))
    
)  
 
 as pmr_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_bronze"."seed"."ref_dataplatform"
    where objet = ''pmr''
    
    union all

    select
        ''N/A'' as pmr_code,
        ''Non disponible'' as pmr_libelle,
        
     
        HASHBYTES(''SHA2_256'', 
    
        cast(''N/A'' as varchar(max))
    
)  
 
 as pmr_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."dbo"."pmr__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."pmr__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  