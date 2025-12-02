
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbi"."orfi_secteur__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table orfi_secteur
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_secteur
 * Cible :          orfi_secteur
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_secteur as
(
    select
        orfi_secteur_hk,
        orfi_secteur_id_code,
        orfi_secteur_libelle,
        orfi_patrimoine_hk,
        orfi_patrimoine_id_code,
        orfi_secteur_code

    from "wh_dp_silver"."int"."int_orfi_secteur"
),


-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_secteur
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."dbi"."orfi_secteur__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbi"."orfi_secteur__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  