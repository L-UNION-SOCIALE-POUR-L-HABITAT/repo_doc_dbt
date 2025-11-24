/**
 *
 * Description :    Alimentation de la table personne
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
cte_int_personne as
(
    select
        personne_id_code,
        personne_hk,
        personne_civilite_hk,
        organisme_type_code,
        organisme_type_libelle,
        organisme_siren_code,
        organisme_code_union,
        organisme_id_code,
        personne_ldap_code,
        personne_prenom_libelle,
        personne_nom_libelle,
        personne_titre_libelle,
        personne_fonction_code,
        personne_fonction_libelle,
        personne_email_libelle,
        personne_statut_code,
        personne_role_libelle

    from "wh_dp_silver"."int"."int_personne"
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    
    from cte_int_personne
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale