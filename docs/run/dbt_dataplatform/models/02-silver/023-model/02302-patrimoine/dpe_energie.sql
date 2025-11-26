
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."dpe_energie__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table dpe_energie
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          ref_dataplatform
 * Cible :          dpe_energie
 */



    
    
    
    select
        code as dpe_energie_code,
        libelle as dpe_energie_libelle,
        
     
        HASHBYTES(''SHA2_256'', 
    
        cast(code as varchar(max))
    
)  
 
 as dpe_energie_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_bronze"."seed"."ref_dataplatform"
    where objet = ''dpe_energie''
    
    union all

    select
        ''N/A'' as dpe_energie_code,
        ''Non disponible'' as dpe_energie_libelle,
        
     
        HASHBYTES(''SHA2_256'', 
    
        cast(''N/A'' as varchar(max))
    
)  
 
 as dpe_energie_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."dbo"."dpe_energie__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."dpe_energie__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  