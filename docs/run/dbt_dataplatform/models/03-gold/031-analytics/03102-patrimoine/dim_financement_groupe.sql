
  
    
    
    USE [wh_dp_gold];
    
    

    EXEC('create view "dbo"."dim_financement_groupe__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table dim_financement_groupe
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          financement_groupe 
 * Cible :          dim_financement_groupe 
 */





    select
        financement_groupe_code,
        financement_groupe_libelle,
        financement_groupe_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_silver"."dbo"."financement_groupe"
;');




    
    EXEC('CREATE TABLE "wh_dp_gold"."dbo"."dim_financement_groupe__dbt_temp" AS SELECT * FROM "wh_dp_gold"."dbo"."dim_financement_groupe__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  