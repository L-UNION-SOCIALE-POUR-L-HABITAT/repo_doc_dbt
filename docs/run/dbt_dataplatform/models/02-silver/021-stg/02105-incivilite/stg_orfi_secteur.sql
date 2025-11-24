
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "stg"."stg_orfi_secteur__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table staging stg_orfi_secteur
 *                  Renommage, nettoyage, typage
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          raw_orfi_sector
 * Cible :          stg_orfi_secteur
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_orfi_sector as 
 (
    select 
        [id]                    as orfi_secteur_id,
        [label]                 as orfi_secteur_libelle,
        [id_patrimony]          as orfi_patrimoine_id,
        [code]                  as orfi_secteur_code

    from   "wh_dp_bronze"."raw"."raw_orfi_sector"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_orfi_sector as 
 (
    select
        *
       
    from  cte_rename_raw_orfi_sector
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

    from cte_clean_and_type_raw_orfi_sector
)

 
select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."stg"."stg_orfi_secteur__dbt_temp" AS SELECT * FROM "wh_dp_silver"."stg"."stg_orfi_secteur__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  