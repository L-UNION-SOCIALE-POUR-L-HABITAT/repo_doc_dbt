

/**
 *
 * Description :    Alimentation de la table statut_professionnel
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          "wh_dp_silver"."stg"."stg_gipsne_ref_statut_professionnel"
 * Cible :          statut_professionnel
 */



with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_source_table as 
(
    select 
        statut_professionnel_cle,
        statut_professionnel_code,
        statut_professionnel_ordre_affichage,
        statut_professionnel_libelle_long,
        statut_professionnel_libelle_court
    from 
        "wh_dp_silver"."stg"."stg_gipsne_ref_statut_professionnel"
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
    
        cast(coalesce(statut_professionnel_code, statut_professionnel_cle) as varchar(max))
    
)  
 
 as statut_professionnel_hk
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

