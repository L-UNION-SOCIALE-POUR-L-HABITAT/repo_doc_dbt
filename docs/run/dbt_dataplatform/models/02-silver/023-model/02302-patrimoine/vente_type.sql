
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."vente_type__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table vente_type
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          ref_dataplatform
 * Cible :          vente_type
 */




    
    
    
    select
        code as vente_type_code,
        libelle as vente_type_libelle,
        
     
        HASHBYTES(''SHA2_256'', 
    
        cast(code as varchar(max))
    
)  
 
 as vente_type_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_bronze"."seed"."ref_dataplatform"
    where objet = ''vente_type''
    
    union all

    select
        ''N/A'' as vente_type_code,
        ''Non disponible'' as vente_type_libelle,
        
     
        HASHBYTES(''SHA2_256'', 
    
        cast(''N/A'' as varchar(max))
    
)  
 
 as vente_type_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."dbo"."vente_type__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."vente_type__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  