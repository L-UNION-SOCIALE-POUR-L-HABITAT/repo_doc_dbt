
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "stg"."stg_orfi_agence__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table staging stg_orfi_agence
 *                  Renommage, nettoyage, typage
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          raw_orfi_agency
 * Cible :          stg_orfi_agence
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_orfi_agency as 
 (
    select 
        [id]                    as orfi_agence_id_code,
        [label]                 as orfi_agence_libelle,
        [id_sector]             as orfi_secteur_id_code,
        [code]                  as orfi_agence_code,
        [active]                as orfi_agence_active

    from   "wh_dp_bronze"."raw"."raw_orfi_agency"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_orfi_agency as 
 (
    select
            orfi_agence_id_code,
            orfi_agence_libelle,
            orfi_secteur_id_code,
            orfi_agence_code,
            orfi_agence_active,
            
  
  case
    when lower(trim(orfi_agence_active)) in (''1'',''oui'',''vrai'',''active'',''true'',''yes'') then cast(1 as bit)
    else cast(0 as bit)
  end
 as orfi_agence_active_flag
       
    from  cte_rename_raw_orfi_agency
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

    from cte_clean_and_type_raw_orfi_agency
)

 
select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."stg"."stg_orfi_agence__dbt_temp" AS SELECT * FROM "wh_dp_silver"."stg"."stg_orfi_agence__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  