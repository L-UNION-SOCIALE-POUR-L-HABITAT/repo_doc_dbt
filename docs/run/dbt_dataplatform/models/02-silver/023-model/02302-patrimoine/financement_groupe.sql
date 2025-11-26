
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."financement_groupe__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table financement_groupe
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          ref_dataplatform
 * Cible :          financement_groupe
 */




    
    
    
    select
        code as financement_groupe_code,
        libelle as financement_groupe_libelle,
        
     
        HASHBYTES(''SHA2_256'', 
    
        cast(code as varchar(max))
    
)  
 
 as financement_groupe_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_bronze"."seed"."ref_dataplatform"
    where objet = ''financement_groupe''
    
    union all

    select
        ''N/A'' as financement_groupe_code,
        ''Non disponible'' as financement_groupe_libelle,
        
     
        HASHBYTES(''SHA2_256'', 
    
        cast(''N/A'' as varchar(max))
    
)  
 
 as financement_groupe_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."dbo"."financement_groupe__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."financement_groupe__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  