
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "stg"."stg_orfi_fait_niveau_1__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table staging stg_orfi_fait_niveau_1
 *                  Renommage, nettoyage, typage
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          raw_orfi_event_type
 * Cible :          stg_orfi_fait_niveau_1
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_orfi_event_type as 
 (
    select 
        [id]                    as orfi_fait_niveau_1_id,
        [label]                 as orfi_fait_niveau_1_libelle

    from   "wh_dp_bronze"."raw"."raw_orfi_event_type"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_orfi_event_type as 
 (
    select
        *
       
    from  cte_rename_raw_orfi_event_type
 ),
 
-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

cte_finale as
(
    select 
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at

    from cte_clean_and_type_raw_orfi_event_type
)

 
select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."stg"."stg_orfi_fait_niveau_1__dbt_temp" AS SELECT * FROM "wh_dp_silver"."stg"."stg_orfi_fait_niveau_1__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  