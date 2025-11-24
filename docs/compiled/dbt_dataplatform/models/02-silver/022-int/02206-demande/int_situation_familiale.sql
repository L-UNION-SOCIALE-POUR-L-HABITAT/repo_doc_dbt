

/**
 *
 * Description :    Alimentation de la table situation_familiale
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          "wh_dp_silver"."stg"."stg_gipsne_ref_situation_familiale"
 * Cible :          situation_familiale
 */



with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_source_table as 
(
    select 
        situation_familiale_cle,
        situation_familiale_code,
        situation_familiale_ordre_affichage,
        situation_familiale_libelle_long,
        situation_familiale_libelle_court
    from 
        "wh_dp_silver"."stg"."stg_gipsne_ref_situation_familiale"
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
    
        cast(coalesce(situation_familiale_code, situation_familiale_cle) as varchar(max))
    
)  
 
 as situation_familiale_hk
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

