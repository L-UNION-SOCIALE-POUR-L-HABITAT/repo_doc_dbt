
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."orfi_agence__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table orfi_agence
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_agence
 * Cible :          orfi_agence
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_agence as
(
    select
        orfi_agence_hk,
        orfi_agence_id,
        orfi_agence_libelle,
        orfi_secteur_id,
        orfi_agence_code,
        orfi_agence_active

    from "wh_dp_silver"."int"."int_orfi_agence"
),




-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_agence
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."dbo"."orfi_agence__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."orfi_agence__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  