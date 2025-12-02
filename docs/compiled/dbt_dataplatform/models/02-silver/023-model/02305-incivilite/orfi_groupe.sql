/**
 *
 * Description :    Alimentation de la table orfi_groupe
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_groupe
 * Cible :          orfi_groupe
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_groupe as
(
    select
        organisme_code_union_hk,
        organisme_code_union,
        orfi_groupe_id_code,
        organisme_groupe_libelle,
        organisme_commentaire_flag,
        organisme_agence_libelle,
        organisme_secteur_libelle,
        organisme_patrimoine_libelle,
        organisme_affichage_ancien_flag,
        organisme_pj_active_flag

    from "wh_dp_silver"."int"."int_orfi_groupe"
),




-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_groupe
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale