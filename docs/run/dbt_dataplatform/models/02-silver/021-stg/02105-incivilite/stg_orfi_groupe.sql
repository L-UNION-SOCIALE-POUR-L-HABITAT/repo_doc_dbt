
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "stg"."stg_orfi_groupe__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table staging stg_orfi_groupe
 *                  Renommage, nettoyage, typage
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          raw_orfi_group
 * Cible :          stg_orfi_groupe
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_orfi_group as 
 (
    select 
        [id]                    as orfi_groupe_id,
        [code]                  as organisme_code_union,
        [name]                  as organisme_groupe_libelle,
        [enable_comment]        as organisme_commentaire_flag,
        [label_agency]          as organisme_agence_libelle,
        [label_sector]          as organisme_secteur_libelle,
        [label_patrimony]       as organisme_patrimoine_libelle,
        [old_display]           as organisme_affichage_ancien_flag,
        [enable_attachments]    as organisme_pj_active_flag

    from   "wh_dp_bronze"."raw"."raw_orfi_group"
 ),

				


-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_orfi_group as 
 (
    select
        *
       
    from  cte_rename_raw_orfi_group
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

    from cte_clean_and_type_raw_orfi_group
)

 
select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."stg"."stg_orfi_groupe__dbt_temp" AS SELECT * FROM "wh_dp_silver"."stg"."stg_orfi_groupe__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  