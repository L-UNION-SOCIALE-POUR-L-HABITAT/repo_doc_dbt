
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "int"."int_zone_plafond_ressource__dbt_temp__dbt_tmp_vw" as 

/**
 *
 * Description :    Alimentation de la table zone_plafond_ressource
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          "wh_dp_silver"."stg"."stg_gipsne_ref_zonage_plaf"
 * Cible :          zone_plafond_ressource
 */



with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_source_table as 
(
    select 
        zone_plafond_ressource_cle,
        zone_plafond_ressource_code,
        zone_plafond_ressource_ordre_affichage,
        zone_plafond_ressource_libelle_long,
        zone_plafond_ressource_libelle_court
    from 
        "wh_dp_silver"."stg"."stg_gipsne_ref_zonage_plaf"
),
 
-------------------------------------------------------------------
--*********************** TRANSFORMATIONS *************************
-------------------------------------------------------------------
 
--ajout des clés techniques
cte_hk_calc as
(
    select
            *,
            
     
        HASHBYTES(''SHA2_256'', 
    
        cast(coalesce(zone_plafond_ressource_code, zone_plafond_ressource_cle) as varchar(max))
    
)  
 
 as zone_plafond_ressource_hk
    from 
        cte_source_table
),

-------------------------------------------------------------------
--*********************** ETAPE FINALE *************************
-------------------------------------------------------------------
cte_finale as 
(
    select
        *,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc
)

select 
    *
from 
    cte_finale

;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."int"."int_zone_plafond_ressource__dbt_temp" AS SELECT * FROM "wh_dp_silver"."int"."int_zone_plafond_ressource__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  