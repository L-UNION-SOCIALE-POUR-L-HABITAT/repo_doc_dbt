

/**
 *
 * Description :    Alimentation de la table mode_logement
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          "wh_dp_silver"."stg"."stg_gipsne_ref_mode_logement"
 * Cible :          mode_logement
 */



with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_source_table as 
(
    select 
        mode_logement_cle,
        mode_logement_code,
        mode_logement_ordre_affichage,
        mode_logement_libelle_long,
        mode_logement_libelle_court
    from 
        "wh_dp_silver"."stg"."stg_gipsne_ref_mode_logement"
),

cte_default_table as
(
    select 
        'N/A'          as mode_logement_cle,
        'N/A'          as mode_logement_code,
        0                                       as mode_logement_ordre_affichage,
        'Non disponible'  as mode_logement_libelle_long,
        'Non disponible'  as mode_logement_libelle_court
        
      
),
-------------------------------------------------------------------
--*********************** TRANSFORMATIONS *************************
-------------------------------------------------------------------
 --union
 cte_union_source_default_table as (
    select * 
    from cte_source_table
    union all
    select * 
    from cte_default_table

 ),

--ajout des clés techniques
cte_hk_calc as
(
    select
            *,
            
     
        HASHBYTES('SHA2_256', 
    
        cast(coalesce(mode_logement_code, mode_logement_cle) as varchar(max))
    
)  
 
 as mode_logement_hk
    from 
        cte_union_source_default_table
),

-------------------------------------------------------------------
--*********************** ETAPE FINALE *************************
-------------------------------------------------------------------
cte_finale as 
(
    select
        *,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc
)

select 
    *
from 
    cte_finale

