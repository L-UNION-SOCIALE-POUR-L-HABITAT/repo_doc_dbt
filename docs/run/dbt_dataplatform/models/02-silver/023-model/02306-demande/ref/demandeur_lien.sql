
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."demandeur_lien__dbt_temp__dbt_tmp_vw" as 

/**
 *
 * Description :    Alimentation de la table ref_demandeur_lien
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          int_demandeur_lien
 * Cible :          ref_demandeur_lien
 */













with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_int_demandeur_lien as
(
    select
        demandeur_lien_hk,
        demandeur_lien_cle,
        demandeur_lien_code,
        demandeur_lien_ordre_affichage,
        demandeur_lien_libelle_long,
        demandeur_lien_libelle_court,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at_int
        
    
        ,null as demandeur_lien_libelle_groupe
    

    from "wh_dp_silver"."int"."int_demandeur_lien"
),

 
-- Sélection des colonnes 
cte_select_int_demandeur_lien as
(
    select
        demandeur_lien_hk,
        coalesce(demandeur_lien_code, demandeur_lien_cle) as demandeur_lien_code,
        demandeur_lien_ordre_affichage,
        demandeur_lien_libelle_long,
        demandeur_lien_libelle_court 
        
    
        ,null as demandeur_lien_libelle_groupe
    


    from cte_int_demandeur_lien
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
    from cte_select_int_demandeur_lien 
)

select 
    *
from 
    cte_finale

;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."dbo"."demandeur_lien__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."demandeur_lien__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  