
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."demandeur_foyer__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table demandeur_foyer
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          int_demandeur_foyer
 * Cible :          demandeur_foyer
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_demandeur_foyer as
(
    select
        demandeur_foyer_demande_id as demande_id
        , demandeur_type_code
        , demandeur_lien_code
        , demandeur_foyer_naissance_date
        , demandeur_foyer_age
        , demandeur_foyer_annee
        , demandeur_foyer_annee_last_flag
        , demandeur_foyer_ordre_affichage
        , demande_et_radiation_sne_hk
        , demandeur_type_hk
        , demandeur_lien_hk

    from "wh_dp_silver"."int"."int_demandeur_foyer"
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_demandeur_foyer
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."dbo"."demandeur_foyer__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."demandeur_foyer__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  