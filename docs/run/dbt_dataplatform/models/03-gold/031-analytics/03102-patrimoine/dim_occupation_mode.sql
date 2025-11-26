
  
    
    
    USE [wh_dp_gold];
    
    

    EXEC('create view "dbo"."dim_occupation_mode__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table dim_occupation_mode
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          occupation_mode
 * Cible :          dim_occupation_mode
 */





    select
        occupation_mode_code,
        occupation_mode_libelle,
        occupation_mode_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_silver"."dbo"."occupation_mode"
;');




    
    EXEC('CREATE TABLE "wh_dp_gold"."dbo"."dim_occupation_mode__dbt_temp" AS SELECT * FROM "wh_dp_gold"."dbo"."dim_occupation_mode__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  