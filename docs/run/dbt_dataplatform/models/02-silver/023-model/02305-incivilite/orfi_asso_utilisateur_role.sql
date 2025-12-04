
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbi"."orfi_asso_utilisateur_role__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table orfi_asso_utilisateur_role
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_asso_utilisateur_role
 * Cible :          orfi_asso_utilisateur_role
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_asso_utilisateur_role as
(
    select
        orfi_asso_utilisateur_role_hk,
        orfi_asso_utilisateur_role_id_code,
        personne_ldap_code_hk,
        personne_ldap_code,
        orfi_role_hk,
        orfi_role_id_code

    from "wh_dp_silver"."int"."int_orfi_asso_utilisateur_role"
),




-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_asso_utilisateur_role
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."dbi"."orfi_asso_utilisateur_role__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbi"."orfi_asso_utilisateur_role__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  