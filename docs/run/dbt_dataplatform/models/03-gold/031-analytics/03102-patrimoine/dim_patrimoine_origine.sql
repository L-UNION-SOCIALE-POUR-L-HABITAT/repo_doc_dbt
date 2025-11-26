
  
    
    
    USE [wh_dp_gold];
    
    

    EXEC('create view "dbo"."dim_patrimoine_origine__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table dim_patrimoine_origine
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          patrimoine_origine  
 * Cible :          dim_patrimoine_origine 
 */





    select
        patrimoine_origine_code,
        patrimoine_origine_libelle,
        patrimoine_origine_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_silver"."dbo"."patrimoine_origine"
;');




    
    EXEC('CREATE TABLE "wh_dp_gold"."dbo"."dim_patrimoine_origine__dbt_temp" AS SELECT * FROM "wh_dp_gold"."dbo"."dim_patrimoine_origine__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  