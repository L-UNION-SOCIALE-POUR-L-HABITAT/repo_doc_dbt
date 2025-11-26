

/**
 *
 * Description :    Alimentation de la table demande_motif
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          "wh_dp_silver"."stg"."stg_gipsne_ref_motif_demande"
 * Cible :          demande_motif
 */



with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_source_table as 
(
    select 
        demande_motif_cle,
        demande_motif_code,
        demande_motif_ordre_affichage,
        demande_motif_libelle_long,
        demande_motif_libelle_court
    from 
        "wh_dp_silver"."stg"."stg_gipsne_ref_motif_demande"
),

cte_default_table as
(
    select 
        'N/A'          as demande_motif_cle,
        'N/A'          as demande_motif_code,
        0                                       as demande_motif_ordre_affichage,
        'Non disponible'  as demande_motif_libelle_long,
        'Non disponible'  as demande_motif_libelle_court
        
      
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
    
        cast(coalesce(demande_motif_code, demande_motif_cle) as varchar(max))
    
)  
 
 as demande_motif_hk
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

