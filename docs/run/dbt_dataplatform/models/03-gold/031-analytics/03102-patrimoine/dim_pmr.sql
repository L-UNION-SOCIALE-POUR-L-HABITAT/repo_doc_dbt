
  
    
    
    USE [wh_dp_gold];
    
    

    EXEC('create view "dbo"."dim_pmr__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table dim_pmr
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          pmr
 * Cible :          dim_pmr
 */





    select
        pmr_code,
        pmr_libelle,
        pmr_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_silver"."dbo"."pmr"
;');




    
    EXEC('CREATE TABLE "wh_dp_gold"."dbo"."dim_pmr__dbt_temp" AS SELECT * FROM "wh_dp_gold"."dbo"."dim_pmr__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  