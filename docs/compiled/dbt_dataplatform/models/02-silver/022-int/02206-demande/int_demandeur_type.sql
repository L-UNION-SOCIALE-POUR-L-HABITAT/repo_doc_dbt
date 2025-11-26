

/**
 *
 * Description :    Alimentation de la table demandeur_type
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          "wh_dp_silver"."stg"."stg_gipsne_ref_type_personne"
 * Cible :          demandeur_type
 */



with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_source_table as 
(
    select 
        demandeur_type_cle,
        demandeur_type_code,
        demandeur_type_ordre_affichage,
        demandeur_type_libelle_long,
        demandeur_type_libelle_court
    from 
        "wh_dp_silver"."stg"."stg_gipsne_ref_type_personne"
),
 
-------------------------------------------------------------------
--*********************** TRANSFORMATIONS *************************
-------------------------------------------------------------------
 
--ajout des clés techniques
cte_hk_calc as
(
    select
            *,
            
     
        HASHBYTES('SHA2_256', 
    
        cast(coalesce(demandeur_type_code, demandeur_type_cle) as varchar(max))
    
)  
 
 as demandeur_type_hk
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
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc
)

select 
    *
from 
    cte_finale

