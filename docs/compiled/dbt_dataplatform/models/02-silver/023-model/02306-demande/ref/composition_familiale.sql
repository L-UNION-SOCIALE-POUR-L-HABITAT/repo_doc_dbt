

/**
 *
 * Description :    Alimentation de la table ref_composition_familiale
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          int_composition_familiale
 * Cible :          ref_composition_familiale
 */













with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_int_composition_familiale as
(
    select
        composition_familiale_hk,
        composition_familiale_cle,
        composition_familiale_code,
        composition_familiale_ordre_affichage,
        composition_familiale_libelle_long,
        composition_familiale_libelle_court,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at_int
        
    
        ,null as composition_familiale_libelle_groupe
    

    from "wh_dp_silver"."int"."int_composition_familiale"
),

 
-- Sélection des colonnes 
cte_select_int_composition_familiale as
(
    select
        composition_familiale_hk,
        coalesce(composition_familiale_code, composition_familiale_cle) as composition_familiale_code,
        composition_familiale_ordre_affichage,
        composition_familiale_libelle_long,
        composition_familiale_libelle_court 
        
    
        ,null as composition_familiale_libelle_groupe
    


    from cte_int_composition_familiale
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
    from cte_select_int_composition_familiale 
)

select 
    *
from 
    cte_finale

