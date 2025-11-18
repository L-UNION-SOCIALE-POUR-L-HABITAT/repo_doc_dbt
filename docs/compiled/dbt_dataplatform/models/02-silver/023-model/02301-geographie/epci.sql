/**
 *
 * Description :    Alimentation de la table epci
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          int_epci
 * Cible :          epci 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_ecpi as
(
    select
        epci_annee,
        epci_annee_last_flag,
        epci_code,
        epci_libelle,
        epci_nature_code,
        epci_bk,
        epci_hk

    from "wh_dp_silver"."int"."int_epci"
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from cte_int_ecpi
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale