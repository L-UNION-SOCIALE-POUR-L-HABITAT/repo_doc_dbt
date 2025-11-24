
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."orfi_groupe__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table orfi_groupe
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_groupe
 * Cible :          orfi_groupe
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_groupe as
(
    select
        orfi_groupe_hk,
        orfi_groupe_id,
        organisme_code_union,
        organisme_groupe_libelle,
        organisme_commentaire_flag,
        organisme_agence_libelle,
        organisme_secteur_libelle,
        organisme_patrimoine_libelle,
        organisme_affichage_ancien_flag,
        organisme_pj_active_flag

    from "wh_dp_silver"."int"."int_orfi_groupe"
),




-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_groupe
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."dbo"."orfi_groupe__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."orfi_groupe__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  