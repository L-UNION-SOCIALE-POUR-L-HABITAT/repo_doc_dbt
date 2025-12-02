
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbi"."orfi_asso_plainte_statut__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table orfi_asso_plainte_statut
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_asso_plainte_statut
 * Cible :          orfi_asso_plainte_statut
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_asso_plainte_statut as
(
    select
        orfi_asso_plainte_statut_hk,
        orfi_asso_plainte_statut_id_code,
        orfi_plainte_hk,
        orfi_plainte_id_code,
        orfi_statut_hk,
        orfi_statut_id_code

    from "wh_dp_silver"."int"."int_orfi_asso_plainte_statut"
),




-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_asso_plainte_statut
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."dbi"."orfi_asso_plainte_statut__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbi"."orfi_asso_plainte_statut__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  