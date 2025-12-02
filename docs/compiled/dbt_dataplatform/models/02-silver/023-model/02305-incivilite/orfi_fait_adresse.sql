/**
 *
 * Description :    Alimentation de la table orfi_fait_adresse
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_fait_adresse
 * Cible :          orfi_fait_adresse
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_fait_adresse as
(
    select
        orfi_fait_adresse_hk,
        orfi_fait_adresse_id_code,
        orfi_fait_adresse_libelle,
        orfi_fait_adresse_longitude_code,
        orfi_fait_adresse_latitude_code,
        orfi_fait_adresse_commune_libelle,
        orfi_fait_adresse_code_postal

    from "wh_dp_silver"."int"."int_orfi_fait_adresse"
),








-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_fait_adresse
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale