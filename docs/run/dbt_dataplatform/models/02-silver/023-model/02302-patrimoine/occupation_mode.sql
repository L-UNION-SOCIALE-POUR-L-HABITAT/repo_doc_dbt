
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."occupation_mode__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table occupation_mode
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          ref_dataplatform
 * Cible :          occupation_mode
 */




    
    
    
    select
        code as occupation_mode_code,
        libelle as occupation_mode_libelle,
        
     
        HASHBYTES(''SHA2_256'', 
    
        cast(code as varchar(max))
    
)  
 
 as occupation_mode_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_bronze"."seed"."ref_dataplatform"
    where objet = ''occupation_mode''
    
    union all

    select
        ''N/A'' as occupation_mode_code,
        ''Non disponible'' as occupation_mode_libelle,
        
     
        HASHBYTES(''SHA2_256'', 
    
        cast(''N/A'' as varchar(max))
    
)  
 
 as occupation_mode_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."dbo"."occupation_mode__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."occupation_mode__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  