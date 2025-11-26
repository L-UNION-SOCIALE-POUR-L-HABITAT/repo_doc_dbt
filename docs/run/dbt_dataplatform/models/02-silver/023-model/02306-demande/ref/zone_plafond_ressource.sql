
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."zone_plafond_ressource__dbt_temp__dbt_tmp_vw" as 

/**
 *
 * Description :    Alimentation de la table ref_zone_plafond_ressource
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          int_zone_plafond_ressource
 * Cible :          ref_zone_plafond_ressource
 */













with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_int_zone_plafond_ressource as
(
    select
        zone_plafond_ressource_hk,
        zone_plafond_ressource_cle,
        zone_plafond_ressource_code,
        zone_plafond_ressource_ordre_affichage,
        zone_plafond_ressource_libelle_long,
        zone_plafond_ressource_libelle_court,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at_int
        
    
        ,null as zone_plafond_ressource_libelle_groupe
    

    from "wh_dp_silver"."int"."int_zone_plafond_ressource"
),

 
-- Sélection des colonnes 
cte_select_int_zone_plafond_ressource as
(
    select
        zone_plafond_ressource_hk,
        coalesce(zone_plafond_ressource_code, zone_plafond_ressource_cle) as zone_plafond_ressource_code,
        zone_plafond_ressource_ordre_affichage,
        zone_plafond_ressource_libelle_long,
        zone_plafond_ressource_libelle_court 
        
    
        ,null as zone_plafond_ressource_libelle_groupe
    


    from cte_int_zone_plafond_ressource
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
    from cte_select_int_zone_plafond_ressource 
)

select 
    *
from 
    cte_finale

;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."dbo"."zone_plafond_ressource__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."zone_plafond_ressource__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  