/**
 *
 * Description :    Alimentation de la table organisme
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_organisme
 * Cible :          organisme
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_organisme as
(
    select
        organisme_raison_sociale_libelle,
        organisme_statut_code,
        organisme_type_code,
        organisme_siren_code,
        organisme_sous_famille_code,
        organisme_code_union,
        organisme_id_code,
        organisme_hk,
        organisme_statut_hk,
        organisme_type_hk,
        organisme_sous_famille_hk


    from "wh_dp_silver"."int"."int_organisme"
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_organisme
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale