/**
 *
 * Description :    Alimentation de la table orfi_statut
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          int_orfi_statut
 * Cible :          orfi_statut
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_orfi_statut as
(
    select
        orfi_statut_hk
        orfi_statut_date,
        orfi_statut_id,
        orfi_statut_libelle,
        orfi_statut_commentaire,
        orfi_statut_itt,
        orfi_statut_prejudice,
        orfi_fait_id,
        orfi_utilisateur_ldap

    from "wh_dp_silver"."int"."int_orfi_statut"
),




-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_orfi_statut
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale