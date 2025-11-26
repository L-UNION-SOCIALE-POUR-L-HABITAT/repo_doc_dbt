

/**
 *
 * Description :    Alimentation de la table ref_demande_motif
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          int_demande_motif
 * Cible :          ref_demande_motif
 */













with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_int_demande_motif as
(
    select
        demande_motif_hk,
        demande_motif_cle,
        demande_motif_code,
        demande_motif_ordre_affichage,
        demande_motif_libelle_long,
        demande_motif_libelle_court,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at_int
        
    
        ,null as demande_motif_libelle_groupe
    

    from "wh_dp_silver"."int"."int_demande_motif"
),

 
-- Sélection des colonnes 
cte_select_int_demande_motif as
(
    select
        demande_motif_hk,
        coalesce(demande_motif_code, demande_motif_cle) as demande_motif_code,
        demande_motif_ordre_affichage,
        demande_motif_libelle_long,
        demande_motif_libelle_court 
        
    
        ,null as demande_motif_libelle_groupe
    


    from cte_int_demande_motif
),

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
cte_finale as
(
    select
        *,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from cte_select_int_demande_motif 
)

select 
    *
from 
    cte_finale

