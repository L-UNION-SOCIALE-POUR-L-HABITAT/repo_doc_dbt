

/**
 *
 * Description :    Alimentation de la table composition_familiale
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          "wh_dp_silver"."stg"."stg_gipsne_ref_composition_famille"
 * Cible :          composition_familiale
 */



with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_source_table as 
(
    select 
        composition_familiale_cle,
        composition_familiale_code,
        composition_familiale_ordre_affichage,
        composition_familiale_libelle_long,
        composition_familiale_libelle_court
    from 
        "wh_dp_silver"."stg"."stg_gipsne_ref_composition_famille"
),

cte_default_table as
(
    select 
        'N/A'          as composition_familiale_cle,
        'N/A'          as composition_familiale_code,
        0                                       as composition_familiale_ordre_affichage,
        'Non disponible'  as composition_familiale_libelle_long,
        'Non disponible'  as composition_familiale_libelle_court
        
      
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
    
        cast(coalesce(composition_familiale_code, composition_familiale_cle) as varchar(max))
    
)  
 
 as composition_familiale_hk
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

