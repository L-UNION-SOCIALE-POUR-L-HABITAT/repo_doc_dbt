
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "int"."int_reservataire_type__dbt_temp__dbt_tmp_vw" as 

/**
 *
 * Description :    Alimentation de la table reservataire_type
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          "wh_dp_silver"."stg"."stg_gipsne_ref_type_reservataire"
 * Cible :          reservataire_type
 */



with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_source_table as 
(
    select 
        reservataire_type_cle,
        reservataire_type_code,
        reservataire_type_ordre_affichage,
        reservataire_type_libelle_long,
        reservataire_type_libelle_court
    from 
        "wh_dp_silver"."stg"."stg_gipsne_ref_type_reservataire"
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
    
        cast(coalesce(reservataire_type_code, reservataire_type_cle) as varchar(max))
    
)  
 
 as reservataire_type_hk
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




    
    EXEC('CREATE TABLE "wh_dp_silver"."int"."int_reservataire_type__dbt_temp" AS SELECT * FROM "wh_dp_silver"."int"."int_reservataire_type__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  