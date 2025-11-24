
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "stg"."stg_orfi_fait__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table staging stg_orfi_fait
 *                  Renommage, nettoyage, typage
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          raw_orfi_event
 * Cible :          stg_orfi_fait
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_orfi_event as 
 (
    select 
        [id]                    as orfi_fait_id,
        [date]                  as orfi_fait_date,
        [recurrent]             as orfi_fait_recurrent,
        [site]                  as orfi_fait_site,
        [building]              as orfi_fait_batiment,
        [floor]                 as orfi_fait_etage,
        [current_status]        as orfi_fait_statut_actuel,
        [id_type]               as orfi_fait_niveau_1_id,
        [id_subtype]            as orfi_fait_niveau_2_id,
        [id_category]           as orfi_fait_niveau_3_id,
        [id_location_type]      as orfi_localisation_niveau_1_id,
        [id_location_subtype]   as orfi_localisation_niveau_2_id,
        [id_address]            as orfi_fait_adresse_id,
        [camera]                as orfi_fait_camera,
        [username]              as orfi_utilisateur_ldap,
        [id_group]              as organisme_code_union,
        [comment]               as orfi_statut_commentaire,
        [firstname]             as orfi_utilisateur_prenom,
        [lastname]              as orfi_utilisateur_nom,
        [group_name]            as orfi_groupe_libelle,
        [user_role]             as orfi_role_id,
        [id_patrimony]          as orfi_patrimoine_id, 
        [id_sector]             as orfi_secteur_id,       
        [id_agency]             as orfi_agence_id,
        [id_user]               as orfi_utilisateur_id

    from   "wh_dp_bronze"."raw"."raw_orfi_event"
 ),

									


-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_orfi_event as 
 (
    select
        *
       
    from  cte_rename_raw_orfi_event
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

    from cte_clean_and_type_raw_orfi_event
)

 
select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."stg"."stg_orfi_fait__dbt_temp" AS SELECT * FROM "wh_dp_silver"."stg"."stg_orfi_fait__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  