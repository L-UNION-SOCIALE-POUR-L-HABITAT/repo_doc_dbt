
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbi"."orfi_patrimoine__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table orfi_patrimoine
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_patrimoine
 * Cible :          orfi_patrimoine
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_patrimoine as
(
    select
        orfi_patrimoine_hk,
        orfi_patrimoine_id_code,
        orfi_patrimoine_libelle,
        orfi_patrimoine_code

    from "wh_dp_silver"."int"."int_orfi_patrimoine"
),


-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_patrimoine
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."dbi"."orfi_patrimoine__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbi"."orfi_patrimoine__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  