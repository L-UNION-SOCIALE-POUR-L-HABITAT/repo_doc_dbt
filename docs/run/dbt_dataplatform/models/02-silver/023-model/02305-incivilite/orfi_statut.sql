
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbi"."orfi_statut__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table orfi_statut
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_statut
 * Cible :          orfi_statut
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_statut as
(
    select
        orfi_statut_hk
        orfi_statut_id_code,
        orfi_statut_date,
        orfi_statut_libelle,
        orfi_statut_commentaire,
        orfi_statut_itt,
        orfi_statut_prejudice,
        orfi_fait_hk,
        orfi_fait_id_code,
        personne_ldap_code_hk,
        personne_ldap_code

    from "wh_dp_silver"."int"."int_orfi_statut"
),




-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_statut
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."dbi"."orfi_statut__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbi"."orfi_statut__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  