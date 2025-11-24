
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "stg"."stg_crm_personne__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table staging stg_crm_personne
 *                  Renommage, nettoyage, typage
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          raw_crm_personne
 * Cible :          stg_crm_personne
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_personne as 
 (
    select 
        [PerID]                  as personne_id_code,
        [PerCivID]               as personne_civilite_hk,
        [EntOrgType]             as organisme_type_code,
        [EntOrgTypeLabel]        as organisme_type_libelle,
        [PerEntID]               as organisme_id_code,
        [EntCodeUnion]           as organisme_code_union,
        [EntSiren]               as organisme_siren_code,
        [PerLdapName_]           as personne_ldap_code,
        [PerFstName]             as personne_prenom_libelle,
        [PerName]                as personne_nom_libelle,
        [PerTitle]               as personne_titre_libelle,
        [PerFctID]               as personne_fonction_code,
        [PerFctLabel]            as personne_fonction_libelle,
        [PerMail]                as personne_email_libelle,
        [PerDataPrivStatus]      as personne_statut_code,
        [PerRolesApplication1_]  as personne_role_libelle


    from   "wh_dp_bronze"."raw"."raw_crm_personne"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_personne as 
 (
    select
        *
       
    from  cte_rename_raw_personne
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

    from cte_clean_and_type_raw_personne
)

 
select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."stg"."stg_crm_personne__dbt_temp" AS SELECT * FROM "wh_dp_silver"."stg"."stg_crm_personne__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  