
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbi"."orfi_fait__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table orfi_fait
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_fait
 * Cible :          orfi_fait
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_fait as
(
    select
        orfi_fait_hk,
        orfi_fait_id_code,
        orfi_fait_date,
        orfi_fait_recurrent_flag,
        orfi_fait_site,
        orfi_fait_batiment,
        orfi_fait_etage,
        orfi_fait_statut_actuel,
        orfi_fait_niveau_1_hk,
        orfi_fait_niveau_1_id_code,
        orfi_fait_niveau_2_hk,
        orfi_fait_niveau_2_id_code,
        orfi_fait_niveau_3_hk,
        orfi_fait_niveau_3_id_code,
        orfi_localisation_niveau_1_hk,
        orfi_localisation_niveau_1_id_code,
        orfi_localisation_niveau_2_hk,
        orfi_localisation_niveau_2_id_code,
        orfi_fait_adresse_hk,
        orfi_fait_adresse_id_code,
        orfi_fait_camera_flag,
        personne_ldap_code_hk,
        personne_ldap_code,
        organisme_code_union,
        orfi_statut_commentaire,
        orfi_utilisateur_prenom,
        orfi_utilisateur_nom,
        orfi_groupe_libelle,
        orfi_role_hk,
        orfi_role_id_code,
        orfi_patrimoine_hk,
        orfi_patrimoine_id_code,
        orfi_secteur_hk, 
        orfi_secteur_id_code,      
        orfi_agence_hk,
        orfi_agence_id_code,
        orfi_utilisateur_hk,
        orfi_utilisateur_id_code

    from "wh_dp_silver"."int"."int_orfi_fait"
),


-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_fait
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."dbi"."orfi_fait__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbi"."orfi_fait__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  