

/**
 *
 * Description :    Alimentation de la table demandeur_lien
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          "wh_dp_silver"."stg"."stg_gipsne_ref_lien_demandeur"
 * Cible :          demandeur_lien
 */



with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_source_table as 
(
    select 
        demandeur_lien_cle,
        demandeur_lien_code,
        demandeur_lien_ordre_affichage,
        demandeur_lien_libelle_long,
        demandeur_lien_libelle_court
    from 
        "wh_dp_silver"."stg"."stg_gipsne_ref_lien_demandeur"
),

cte_default_table as
(
    select 
        'N/A'          as demandeur_lien_cle,
        'N/A'          as demandeur_lien_code,
        0                                       as demandeur_lien_ordre_affichage,
        'Non disponible'  as demandeur_lien_libelle_long,
        'Non disponible'  as demandeur_lien_libelle_court
        
      
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
    
        cast(coalesce(demandeur_lien_code, demandeur_lien_cle) as varchar(max))
    
)  
 
 as demandeur_lien_hk
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

