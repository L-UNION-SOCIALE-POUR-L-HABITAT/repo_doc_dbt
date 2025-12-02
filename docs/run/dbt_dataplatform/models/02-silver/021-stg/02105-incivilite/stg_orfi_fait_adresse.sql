
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "stg"."stg_orfi_fait_adresse__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table staging stg_orfi_fait_adresse
 *                  Renommage, nettoyage, typage
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          raw_orfi_address
 * Cible :          stg_orfi_fait_adresse
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_orfi_address as 
 (
    select 
        [id]                    as orfi_fait_adresse_id_code,
        [address]               as orfi_fait_adresse_libelle,
        [longitude]             as orfi_fait_adresse_longitude_code,
        [latitude]              as orfi_fait_adresse_latitude_code,
        [city]                  as orfi_fait_adresse_commune_libelle,
        [zipcode]               as orfi_fait_adresse_code_postal
    


    from   "wh_dp_bronze"."raw"."raw_orfi_address"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_orfi_address as 
 (
    select
        *
       
    from  cte_rename_raw_orfi_address
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

    from cte_clean_and_type_raw_orfi_address
)

 
select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."stg"."stg_orfi_fait_adresse__dbt_temp" AS SELECT * FROM "wh_dp_silver"."stg"."stg_orfi_fait_adresse__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  