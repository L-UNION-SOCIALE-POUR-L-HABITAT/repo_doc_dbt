
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."orfi_utilisateur__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table orfi_utilisateur
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_utilisateur
 * Cible :          orfi_utilisateur
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_utilisateur as
(
    select
        orfi_utilisateur_hk
        orfi_utilisateur_id,
        orfi_utilisateur_ldap,
        orfi_utilisateur_prenom,
        orfi_utilisateur_nom_famille,
        organisme_code_union,
        organisme_groupe_libelle,
        orfi_utilisateur_email,
        orfi_utilisateur_id_keycloak,
        orfi_utilisateur_statut,
        orfi_utilisateur_creation,
        orfi_utilisateur_maj,
        orfi_utilisateur_ancien_groupe_code

    from "wh_dp_silver"."int"."int_orfi_utilisateur"
),




-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_utilisateur
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."dbo"."orfi_utilisateur__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."orfi_utilisateur__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  