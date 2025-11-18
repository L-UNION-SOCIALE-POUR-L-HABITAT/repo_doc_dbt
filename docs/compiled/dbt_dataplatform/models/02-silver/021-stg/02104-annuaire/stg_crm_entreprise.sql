/**
 *
 * Description :    Alimentation de la table staging stg_crm_entreprise
 *                  Renommage, nettoyage, typage
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          raw_crm_entreprise
 * Cible :          stg_crm_entreprise
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_entreprise as 
 (
    select 
        [name]                  as organisme_raison_sociale_libelle,
        [organizationStatut]    as organisme_statut_code,
        [organizationType]      as organisme_type_code,
        [siren]                 as organisme_siren_code,
        --[status],
        [subfamily]             as organisme_sous_famille_code,
        [codeUnion]             as organisme_code_union,
        [id]                    as organisme_id_code
      
    from   "wh_dp_bronze"."raw"."raw_crm_entreprise"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_entreprise as 
 (
    select
        *
       
    from  cte_rename_raw_entreprise
 ),
 
-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

cte_finale as
(
    select 
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at

    from cte_clean_and_type_raw_entreprise
)

 
select 
    *
from 
    cte_finale