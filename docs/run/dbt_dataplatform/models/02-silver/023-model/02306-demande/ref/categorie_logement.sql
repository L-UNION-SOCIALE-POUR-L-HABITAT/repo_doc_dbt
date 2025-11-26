
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."categorie_logement__dbt_temp__dbt_tmp_vw" as 

/**
 *
 * Description :    Alimentation de la table ref_categorie_logement
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          int_categorie_logement
 * Cible :          ref_categorie_logement
 */













with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_int_categorie_logement as
(
    select
        categorie_logement_hk,
        categorie_logement_cle,
        categorie_logement_code,
        categorie_logement_ordre_affichage,
        categorie_logement_libelle_long,
        categorie_logement_libelle_court,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at_int
        
    
        ,null as categorie_logement_libelle_groupe
    

    from "wh_dp_silver"."int"."int_categorie_logement"
),

 
-- Sélection des colonnes 
cte_select_int_categorie_logement as
(
    select
        categorie_logement_hk,
        coalesce(categorie_logement_code, categorie_logement_cle) as categorie_logement_code,
        categorie_logement_ordre_affichage,
        categorie_logement_libelle_long,
        categorie_logement_libelle_court 
        
    
        ,null as categorie_logement_libelle_groupe
    


    from cte_int_categorie_logement
),

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
cte_finale as
(
    select
        *,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from cte_select_int_categorie_logement 
)

select 
    *
from 
    cte_finale

;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."dbo"."categorie_logement__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."categorie_logement__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  