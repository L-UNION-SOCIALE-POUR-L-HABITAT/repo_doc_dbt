/**
 *
 * Description :    Alimentation de la table staging stg_orfi_utilisateur
 *                  Renommage, nettoyage, typage
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          raw_orfi_user
 * Cible :          stg_orfi_utilisateur
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_orfi_user as 
 (
    select 
        [id]                    as orfi_utilisateur_id,
        [username]              as orfi_utilisateur_ldap,
        [firstname]             as orfi_utilisateur_prenom,
        [lastname]              as orfi_utilisateur_nom_famille,
        [group_code]            as organisme_code_union,
        [group_name]            as organisme_groupe_libelle,
        [email]                 as orfi_utilisateur_email,
        [id_keycloak]           as orfi_utilisateur_id_keycloak,
        [status]                as orfi_utilisateur_statut,
        [created_at]            as orfi_utilisateur_creation,
        [updated_at]            as orfi_utilisateur_maj,
        [previous_group_code]   as orfi_utilisateur_ancien_groupe_code

    from   "wh_dp_bronze"."raw"."raw_orfi_user"
 ),



-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_orfi_user as 
 (
    select
        --
    case
        when orfi_utilisateur_creation is null or trim(orfi_utilisateur_creation) = '' then CAST(NULL AS DATE)
        when upper(trim(orfi_utilisateur_creation)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
            when len(trim(orfi_utilisateur_creation)) != 10 then CAST(NULL AS DATE)
            else TRY_CAST(REPLACE(orfi_utilisateur_creation, '/', '-') AS DATE)

        
    end
 as orfi_utilisateur_creation,
        --
    case
        when orfi_utilisateur_maj is null or trim(orfi_utilisateur_maj) = '' then CAST(NULL AS DATE)
        when upper(trim(orfi_utilisateur_maj)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
            when len(trim(orfi_utilisateur_maj)) != 10 then CAST(NULL AS DATE)
            else TRY_CAST(REPLACE(orfi_utilisateur_maj, '/', '-') AS DATE)

        
    end
 as orfi_utilisateur_maj,
        orfi_utilisateur_id,
        orfi_utilisateur_ldap,
        orfi_utilisateur_prenom,
        orfi_utilisateur_nom_famille,
        organisme_code_union,
        organisme_groupe_libelle,
        orfi_utilisateur_email,
        orfi_utilisateur_id_keycloak,
        orfi_utilisateur_statut,
        orfi_utilisateur_ancien_groupe_code
       
    from  cte_rename_raw_orfi_user
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

    from cte_clean_and_type_raw_orfi_user
)

 
select 
    *
from 
    cte_finale