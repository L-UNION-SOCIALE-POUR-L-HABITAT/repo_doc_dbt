
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbi"."orfi_localisation_niveau_2__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table orfi_localisation_niveau_2
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_localisation_niveau_2
 * Cible :          orfi_localisation_niveau_2
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_localisation_niveau_2 as
(
    select
        orfi_localisation_niveau_2_hk,
        orfi_localisation_niveau_2_id_code,
        orfi_localisation_niveau_2_libelle,
        orfi_localisation_niveau_1_hk,
        orfi_localisation_niveau_1_id_code

    from "wh_dp_silver"."int"."int_orfi_localisation_niveau_2"
),








-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_localisation_niveau_2
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."dbi"."orfi_localisation_niveau_2__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbi"."orfi_localisation_niveau_2__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  