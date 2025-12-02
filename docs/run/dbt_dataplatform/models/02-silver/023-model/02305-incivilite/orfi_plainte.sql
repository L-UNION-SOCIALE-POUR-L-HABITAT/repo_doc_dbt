
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbi"."orfi_plainte__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table orfi_plainte
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_plainte
 * Cible :          orfi_plainte
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_plainte as
(
    select
        orfi_plainte_hk,
        orfi_plainte_id_code,
        orfi_plainte_libelle

    from "wh_dp_silver"."int"."int_orfi_plainte"
),


-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_plainte
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."dbi"."orfi_plainte__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbi"."orfi_plainte__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  