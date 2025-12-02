/**
 *
 * Description :    Alimentation de la table staging stg_orfi_fait
 *                  Renommage, nettoyage, typage
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          raw_orfi_event
 * Cible :          stg_orfi_fait
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_orfi_event as 
 (
    select 
        [id]                    as orfi_fait_id_code,
        [date]                  as orfi_fait_date,
        [recurrent]             as orfi_fait_recurrent,
        [site]                  as orfi_fait_site,
        [building]              as orfi_fait_batiment,
        [floor]                 as orfi_fait_etage,
        [current_status]        as orfi_fait_statut_actuel,
        [id_type]               as orfi_fait_niveau_1_id_code,
        [id_subtype]            as orfi_fait_niveau_2_id_code,
        [id_category]           as orfi_fait_niveau_3_id_code,
        [id_location_type]      as orfi_localisation_niveau_1_id_code,
        [id_location_subtype]   as orfi_localisation_niveau_2_id_code,
        [id_address]            as orfi_fait_adresse_id_code,
        [camera]                as orfi_fait_camera,
        [username]              as personne_ldap_code,
        [id_group]              as organisme_code_union,
        [comment]               as orfi_statut_commentaire,
        [firstname]             as orfi_utilisateur_prenom,
        [lastname]              as orfi_utilisateur_nom,
        [group_name]            as orfi_groupe_libelle,
        [user_role]             as orfi_role_id_code,
        [id_patrimony]          as orfi_patrimoine_id_code, 
        [id_sector]             as orfi_secteur_id_code,       
        [id_agency]             as orfi_agence_id_code,
        [id_user]               as orfi_utilisateur_id_code

    from   "wh_dp_bronze"."raw"."raw_orfi_event"
 ),

									


-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_orfi_event as 
 (
    select
        
    case
        -- Gestion des valeurs nulles ou vides
        when orfi_fait_date is null or trim(orfi_fait_date) = '' then CAST(NULL AS DATE)
        
        -- Gestion des valeurs 'NA' (Not Available)
        when upper(trim(orfi_fait_date)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        -- Format MM/AAAA (ex: 05/1981)
        -- Convertit en AAAA-MM-01 (1er du mois par défaut)
        
            -- Détection automatique du format basée sur la structure de la chaîne
            when len(trim(orfi_fait_date)) < 10 then CAST(NULL AS DATE)
            
            -- Si la chaîne contient un tiret en position 5 (AAAA-MM-JJ ou AAAA-MM-JJ HH:MI:SS)
            when SUBSTRING(trim(orfi_fait_date), 5, 1) = '-' then 
                TRY_CAST(LEFT(trim(orfi_fait_date), 10) AS DATE)
            
            -- Si la chaîne contient un séparateur (/ ou -) en position 3 (JJ/MM/AAAA ou JJ-MM-AAAA)
            when SUBSTRING(trim(orfi_fait_date), 3, 1) in ('/', '-') then 
                TRY_CAST(
                    CONCAT(
                        SUBSTRING(trim(REPLACE(orfi_fait_date, '/', '-')), 7, 4), '-',  -- Année
                        SUBSTRING(trim(REPLACE(orfi_fait_date, '/', '-')), 4, 2), '-',  -- Mois
                        SUBSTRING(trim(REPLACE(orfi_fait_date, '/', '-')), 1, 2)        -- Jour
                    ) AS DATE
                )
            
            -- Fallback : valeur par défaut si aucun format détecté
            else CAST(NULL AS DATE)
        
    end
 as orfi_fait_date,
        orfi_fait_id_code,
        
  
  case
    when lower(trim(orfi_fait_recurrent)) in ('1','oui','vrai','active','true','yes') then cast(1 as bit)
    else cast(0 as bit)
  end
 as orfi_fait_recurrent_flag,
        orfi_fait_site,
        orfi_fait_batiment,
        orfi_fait_etage,
        orfi_fait_statut_actuel,
        orfi_fait_niveau_1_id_code,
        orfi_fait_niveau_2_id_code,
        orfi_fait_niveau_3_id_code,
        orfi_localisation_niveau_1_id_code,
        orfi_localisation_niveau_2_id_code,
        orfi_fait_adresse_id_code,
        
  
  case
    when lower(trim(orfi_fait_camera)) in ('1','oui','vrai','active','true','yes') then cast(1 as bit)
    else cast(0 as bit)
  end
 as orfi_fait_camera_flag,
        personne_ldap_code,
        organisme_code_union,
        orfi_statut_commentaire,
        orfi_utilisateur_prenom,
        orfi_utilisateur_nom,
        orfi_groupe_libelle,
        orfi_role_id_code,
        orfi_patrimoine_id_code, 
        orfi_secteur_id_code,       
        orfi_agence_id_code,
        orfi_utilisateur_id_code


       
    from  cte_rename_raw_orfi_event
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

    from cte_clean_and_type_raw_orfi_event
)

 
select 
    *
from 
    cte_finale