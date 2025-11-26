

/**
 *
 * Description :    Alimentation de la table ref_demandeur_type
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          int_demandeur_type
 * Cible :          ref_demandeur_type
 */













with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_int_demandeur_type as
(
    select
        demandeur_type_hk,
        demandeur_type_cle,
        demandeur_type_code,
        demandeur_type_ordre_affichage,
        demandeur_type_libelle_long,
        demandeur_type_libelle_court,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at_int
        
    
        ,null as demandeur_type_libelle_groupe
    

    from "wh_dp_silver"."int"."int_demandeur_type"
),

 
-- Sélection des colonnes 
cte_select_int_demandeur_type as
(
    select
        demandeur_type_hk,
        coalesce(demandeur_type_code, demandeur_type_cle) as demandeur_type_code,
        demandeur_type_ordre_affichage,
        demandeur_type_libelle_long,
        demandeur_type_libelle_court 
        
    
        ,null as demandeur_type_libelle_groupe
    


    from cte_int_demandeur_type
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
    from cte_select_int_demandeur_type 
)

select 
    *
from 
    cte_finale

