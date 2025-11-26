
  
    
    
    USE [wh_dp_gold];
    
    

    EXEC('create view "dbo"."dim_dpe_ges__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table dim_dpe_ges
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          dpe_ges
 * Cible :          dim_dpe_ges 
 */





    select
        dpe_ges_code,
        dpe_ges_libelle,
        dpe_ges_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_silver"."dbo"."dpe_ges"
;');




    
    EXEC('CREATE TABLE "wh_dp_gold"."dbo"."dim_dpe_ges__dbt_temp" AS SELECT * FROM "wh_dp_gold"."dbo"."dim_dpe_ges__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  