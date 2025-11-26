
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."organisme_categorie__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table organisme_categorie
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          ref_dataplatform
 * Cible :          organisme_categorie
 */




    
    
    
    select
        code as organisme_categorie_code,
        libelle as organisme_categorie_libelle,
        
     
        HASHBYTES(''SHA2_256'', 
    
        cast(code as varchar(max))
    
)  
 
 as organisme_categorie_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_bronze"."seed"."ref_dataplatform"
    where objet = ''organisme_categorie''
    
    union all

    select
        ''N/A'' as organisme_categorie_code,
        ''Non disponible'' as organisme_categorie_libelle,
        
     
        HASHBYTES(''SHA2_256'', 
    
        cast(''N/A'' as varchar(max))
    
)  
 
 as organisme_categorie_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."dbo"."organisme_categorie__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."organisme_categorie__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  