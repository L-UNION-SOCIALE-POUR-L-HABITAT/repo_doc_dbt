
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."orfi_fait_niveau_3__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table orfi_fait_niveau_3
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_fait_niveau_3
 * Cible :          orfi_fait_niveau_3
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_fait_niveau_3 as
(
    select
        orfi_fait_niveau_3_id,
        orfi_fait_niveau_3_hk,
        orfi_fait_niveau_3_libelle,
        orfi_fait_niveau_2_id,
        orfi_fait_niveau_3_recurrent

    from "wh_dp_silver"."int"."int_orfi_fait_niveau_3"
),








-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_fait_niveau_3
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."dbo"."orfi_fait_niveau_3__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."orfi_fait_niveau_3__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  