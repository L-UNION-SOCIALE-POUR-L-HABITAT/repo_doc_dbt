
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."reservation_contingent__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table reservation_contingent
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          ref_dataplatform
 * Cible :          reservation_contingent
 */




    
    
    
    select
        code as reservation_contingent_code,
        libelle as reservation_contingent_libelle,
        
     
        HASHBYTES(''SHA2_256'', 
    
        cast(code as varchar(max))
    
)  
 
 as reservation_contingent_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_bronze"."seed"."ref_dataplatform"
    where objet = ''reservation_contingent''
    
    union all

    select
        ''N/A'' as reservation_contingent_code,
        ''Non disponible'' as reservation_contingent_libelle,
        
     
        HASHBYTES(''SHA2_256'', 
    
        cast(''N/A'' as varchar(max))
    
)  
 
 as reservation_contingent_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."dbo"."reservation_contingent__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."reservation_contingent__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  