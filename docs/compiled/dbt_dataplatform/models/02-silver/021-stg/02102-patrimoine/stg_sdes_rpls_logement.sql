/**
 *
 * Description :    Alimentation de la table staging stg_sdes_rpls_logement
 *                  Renommage, nettoyage, typage
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          raw_sdes_rpls_logement
 * Cible :          stg_sdes_rpls_logement 
 */




 with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_sdes_rpls_logement as 
 (
    select 
        [_meta_year]                as logement_rpls_millesime,
        [IDENT_REP]                 as logement_rpls_id,
        [IDENT_INT]                 as logement_bailleur_systeme_id,
        [IDENT_ORG]                 as organisme_id,
        [DROIT]                     as immobilier_droit_code,
        [DEPCOM]                    as commune_code,
        [CODEPOSTAL]                as adresse_postale_code,
        [LIBCOM]                    as commune_libelle,
        [NUMVOIE]                   as adresse_voie_num,
        [INDREP]                    as adresse_voie_indice_repetition_libelle,
        [TYPVOIE]                   as adresse_voie_type_libelle,
        [NOMVOIE]                   as adresse_voie_libelle,
        [NUMAPPT]                   as adresse_appartement_num,
        [NUMBOITE]                  as adresse_boite_num ,
        [ESC]                       as adresse_escalier_num,
        [COULOIR]                   as adresse_couloir_libelle,
        [ETAGE]                     as adresse_etage_num ,
        [COMPLIDENT]                as adresse_logement_complement_libelle,
        [ENTREE]                    as adresse_entree_num,
        [BAT]                       as adresse_batiment_num,
        [IMMEU]                     as adresse_immeuble_num,
        [COMPLGEO]                  as adresse_batiment_complement_libelle,
        [LIEUDIT]                   as adresse_lieu_dit_libelle,
        [QPV]                       as qpv_flag ,
        [TYPECONST]                 as construction_type_code,
        [NBPIECE]                   as piece_nombre_code,
        [SURFHAB]                   as surface_habitable_m2,
        [CONSTRUCT]                 as construction_achevement_annee,
        [LOCAT]                     as mise_en_location_premiere_annee,
        [PATRIMOINE]                as patrimoine_entree_annee,
        [ORIGINE]                   as patrimoine_origine_code,
        [RSEXPRO]                   as proprietaire_precedent_raison_sociale_libelle,
        [SIRETEXPRO]                as proprietaire_precedent_siret_num,
        [FINAN]                     as financement_initial_code,
        [FINANAUTRE]                as financement_autre_libelle,
        [CONV]                      as convention_flag,
        [NUMCONV]                   as convention_num,
        [DATCONV]                   as convention_date,
        [SORTIEPATRIM]              as patrimoine_sortie_code,
        [OLDLOGT]                   as logement_old_code,
        [NEWLOGT]                   as logement_new_code,
        [MODE]                      as occupation_mode_code,
        [BAIL]                      as bail_effet_mois,
        [MODESURF]                  as surface_mode_code,
        [SURFMODE]                  as surface_mode_m2,
        [LOYERPRINC]                as loyer_principal_mensuel_montant,
        [LOYERACC]                  as loyer_accessoire_mensuel_montant,
        [CONTRIB]                   as contribution_montant,
        -- a changer
        [CUS]                       as financement_cus_code,

        [DPEDATE]                   as dpe_mois,
        [DPEENERGIE]                as dpe_energie_code,
        [DPESERRE]                  as dpe_ges_code,
        [SRU_EXPIR]                 as sru_expiration_annee,
        [SRU_ALINEA]                as sru_alinea_code,
        [IDENTGES]                  as organisme_gestionnaire_id,
        [CODSEGPATRIM]              as patrimoine_segment_code,
        [LIBSEGPATRIM]              as patrimoine_segment_libelle,
        [LOYERMAXAPL]               as loyer_maximal_apl_mensuel_montant,
        [LOYERMAXCUS]               as loyer_maximal_cus_mensuel_montant,
        [QUALACQ]                   as vente_type_code,
        [MISCOMMERCIAL]             as mise_en_commercialisation_code,
        [PRIXVENTE]                 as vente_prix_montant,
        [PRODFIN]                   as produit_financier_net_montant,
        [REMLOCDATE]                as remise_en_location_mois,
        [CONTRESLOG]                as reservation_contingent_code,
        [PMR]                       as pmr_code,
        [DATMISEVENTE]              as vente_autorisation_mois,
        [DATVEFFECT]                as vente_effective_mois,
        [DATE_DEP_DERLOCAT]         as locataire_dernier_depart_date,
        [DPE_CONSO_ENER]            as dpe_energie_consommation_valeur,
        [DPE_CONSO_GES]             as dpe_ges_consommation_valeur,
        [DPE_NUM_REF]               as dpe_reference_num,
        [IDENT_FISCAL]              as logement_fiscal_id,
        [CAT_ORG]                   as organisme_categorie_code,
        [RS]                        as organisme_raison_sociale_libelle,
        [SIRET]                     as organisme_siret_code,
        [DEP]                       as departement_code,
        [LIBDEP]                    as departement_libelle,
        [REG]                       as region_code,
        [LIBREG]                    as region_libelle ,
        [EPCI]                      as epci_code ,
        [LIBEPCI]                   as epci_libelle,
        [DEPARTEMENTS_DE_L_EPCI]    as departements_epci_list,
        [REGIONS_DE_L_EPCI]         as regions_epci_list,
        --[ARN],
        [finan_cus]                 as var_financement_groupe_libelle,
        [mes_sanscumul]             as var_mise_en_service_flag,
        [loymoy]                    as var_loyer_moyen_mensuel_m2_montant,
        [age]                       as var_logement_anciennete_en_annee,
        [deconv]                    as var_deconventionnement_flag,
        [duree_vacance]             as var_duree_vacance_mois,
        [ANNEE_REMLOC]              as var_remise_en_location_annee,
        [MOIS_REMLOC]               as var_remise_en_location_mois,
        [MOIS_BAIL]                 as var_bail_effet_mois,
        [ANNEE_BAIL]                as var_bail_effet_annee,
        [BAIL_DATE]                 as var_bail_effet_date ,
        [REMLOCDATE_DATE]           as var_remise_en_location_date
      
 
    from   "wh_dp_bronze"."raw"."raw_sdes_rpls_logement"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_sdes_rpls_logement as
(

    select
 
        
    case
        -- Valeurs nulles ou codes à ignorer
        when logement_rpls_millesime is null 
          or logement_rpls_millesime in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(logement_rpls_millesime as integer) is not null 
        then cast(logement_rpls_millesime as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(logement_rpls_millesime as float) is not null 
        then cast(cast(logement_rpls_millesime as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
            as logement_rpls_millesime,
        
    case
        when logement_rpls_millesime is null or trim(logement_rpls_millesime) = '' then CAST(NULL AS DATE)
        when upper(trim(logement_rpls_millesime)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
            when len(trim(logement_rpls_millesime)) != 4 then CAST(NULL AS DATE)
            else TRY_CAST(logement_rpls_millesime + '-01-01' AS DATE)
        
        
    end
        as logement_rpls_millesime_date,
        logement_rpls_id,
        logement_bailleur_systeme_id,
        organisme_id,
        
    case 
        when immobilier_droit_code in ('NA', '0','NC','Z') or immobilier_droit_code is null 
            then 'N/A'
        else immobilier_droit_code
    end
          as immobilier_droit_code,
        commune_code,
        adresse_postale_code,
        commune_libelle,
        adresse_voie_num,
        adresse_voie_indice_repetition_libelle,
        adresse_voie_type_libelle,
        adresse_voie_libelle,
        adresse_appartement_num,
        adresse_boite_num,
        adresse_escalier_num,
        adresse_couloir_libelle,
        adresse_etage_num,
        adresse_logement_complement_libelle,
        adresse_entree_num,
        adresse_batiment_num,
        adresse_immeuble_num,
        adresse_batiment_complement_libelle,
        adresse_lieu_dit_libelle,
        
  
  case
    when trim(qpv_flag) = '1' then cast(1 as bit)
    else cast(0 as bit)
  end
 as qpv_flag,
        
    case 
        when construction_type_code in ('NA', '0','NC','Z') or construction_type_code is null 
            then 'N/A'
        else construction_type_code
    end
                 as construction_type_code,
        piece_nombre_code,
        
    case
        -- Valeurs nulles ou codes à ignorer
        when surface_habitable_m2 is null 
          or surface_habitable_m2 in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(surface_habitable_m2 as integer) is not null 
        then cast(surface_habitable_m2 as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(surface_habitable_m2 as float) is not null 
        then cast(cast(surface_habitable_m2 as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
                   as surface_habitable_m2,
        
    case
        when construction_achevement_annee is null or trim(construction_achevement_annee) = '' then CAST(NULL AS DATE)
        when upper(trim(construction_achevement_annee)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
            when len(trim(construction_achevement_annee)) != 4 then CAST(NULL AS DATE)
            else TRY_CAST(construction_achevement_annee + '-01-01' AS DATE)
        
        
    end
     as construction_achevement_annee,
        
    case
        when mise_en_location_premiere_annee is null or trim(mise_en_location_premiere_annee) = '' then CAST(NULL AS DATE)
        when upper(trim(mise_en_location_premiere_annee)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
            when len(trim(mise_en_location_premiere_annee)) != 4 then CAST(NULL AS DATE)
            else TRY_CAST(mise_en_location_premiere_annee + '-01-01' AS DATE)
        
        
    end
   as mise_en_location_premiere_annee,
        
    case
        when patrimoine_entree_annee is null or trim(patrimoine_entree_annee) = '' then CAST(NULL AS DATE)
        when upper(trim(patrimoine_entree_annee)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
            when len(trim(patrimoine_entree_annee)) != 4 then CAST(NULL AS DATE)
            else TRY_CAST(patrimoine_entree_annee + '-01-01' AS DATE)
        
        
    end
           as patrimoine_entree_annee,
        patrimoine_origine_code,
        proprietaire_precedent_raison_sociale_libelle,
        proprietaire_precedent_siret_num,
        financement_initial_code,
        financement_autre_libelle,
        case when  region_code in ('01', '02', '03', '04', '06') then cast (0 as bit) else  
  
  case
    when trim(convention_flag) = '1' then cast(1 as bit)
    else cast(0 as bit)
  end
 end as convention_flag,
        case when  region_code in ('01', '02', '03', '04', '06') then 'N/A' end as convention_num,
        case when  region_code in ('01', '02', '03', '04', '06')  then null else 
    case
        when convention_date is null or trim(convention_date) = '' then CAST(NULL AS DATE)
        when upper(trim(convention_date)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
        when len(trim(convention_date)) < 10 then CAST(NULL AS DATE)
        else TRY_CAST(
            CONCAT(
                SUBSTRING(trim(REPLACE(convention_date, '/', '-')), 7, 4), '-',  -- AAAA
                SUBSTRING(trim(REPLACE(convention_date, '/', '-')), 4, 2), '-',  -- MM
                SUBSTRING(trim(REPLACE(convention_date, '/', '-')), 1, 2)        -- JJ
            ) AS DATE
        )
    
    end
 end as convention_date,
        
    case 
        when patrimoine_sortie_code in ('NA', '0','NC','Z') or patrimoine_sortie_code is null 
            then 'N/A'
        else patrimoine_sortie_code
    end
 as patrimoine_sortie_code,
        logement_old_code,
        logement_new_code,
        
    case 
        when occupation_mode_code in ('NA', '0','NC','Z') or occupation_mode_code is null 
            then 'N/A'
        else occupation_mode_code
    end
 as occupation_mode_code,
        
    case
        when bail_effet_mois is null or trim(bail_effet_mois) = '' then CAST(NULL AS DATE)
        when upper(trim(bail_effet_mois)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
        when len(trim(bail_effet_mois)) != 7 then CAST(NULL AS DATE)
        else TRY_CAST(
            CONCAT(
                SUBSTRING(trim(REPLACE(bail_effet_mois, '/', '-')), 4, 4), '-',  -- AAAA
                SUBSTRING(trim(REPLACE(bail_effet_mois, '/', '-')), 1, 2), '-',  -- MM
                '01'                                                               -- JJ (par défaut)
            ) AS DATE
        )
 

        
    end
 as bail_effet_mois,
        
    case 
        when surface_mode_code in ('NA', '0','NC','Z') or surface_mode_code is null 
            then 'N/A'
        else surface_mode_code
    end
 as surface_mode_code,
        surface_mode_m2,
        
  
  case
    when try_cast(trim(replace(loyer_principal_mensuel_montant, ',', '.')) as float) is not null
      then cast(trim(replace(loyer_principal_mensuel_montant, ',', '.')) as float)
    else null
  end
 as loyer_principal_mensuel_montant,
        
  
  case
    when try_cast(trim(replace(loyer_accessoire_mensuel_montant, ',', '.')) as float) is not null
      then cast(trim(replace(loyer_accessoire_mensuel_montant, ',', '.')) as float)
    else null
  end
 as loyer_accessoire_mensuel_montant,
        
  
  case
    when try_cast(trim(replace(contribution_montant, ',', '.')) as float) is not null
      then cast(trim(replace(contribution_montant, ',', '.')) as float)
    else null
  end
 as contribution_montant,
        financement_cus_code,
        
    case
        when dpe_mois is null or trim(dpe_mois) = '' then CAST(NULL AS DATE)
        when upper(trim(dpe_mois)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
        when len(trim(dpe_mois)) != 7 then CAST(NULL AS DATE)
        else TRY_CAST(
            CONCAT(
                SUBSTRING(trim(REPLACE(dpe_mois, '/', '-')), 4, 4), '-',  -- AAAA
                SUBSTRING(trim(REPLACE(dpe_mois, '/', '-')), 1, 2), '-',  -- MM
                '01'                                                               -- JJ (par défaut)
            ) AS DATE
        )
 

        
    end
  as dpe_mois,
        
    case 
        when dpe_energie_code in ('NA', '0','NC','Z') or dpe_energie_code is null 
            then 'N/A'
        else dpe_energie_code
    end
 as dpe_energie_code,
        
    case 
        when dpe_ges_code in ('NA', '0','NC','Z') or dpe_ges_code is null 
            then 'N/A'
        else dpe_ges_code
    end
 as dpe_ges_code,
        case when  region_code in ('01', '02', '03', '04', '06')  then null else 
    case
        when sru_expiration_annee is null or trim(sru_expiration_annee) = '' then CAST(NULL AS DATE)
        when upper(trim(sru_expiration_annee)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
            when len(trim(sru_expiration_annee)) != 4 then CAST(NULL AS DATE)
            else TRY_CAST(sru_expiration_annee + '-01-01' AS DATE)
        
        
    end
 end as sru_expiration_annee,
        sru_alinea_code,
        organisme_gestionnaire_id,
        patrimoine_segment_code,
        patrimoine_segment_libelle,
        
  
  case
    when try_cast(trim(replace(loyer_maximal_apl_mensuel_montant, ',', '.')) as float) is not null
      then cast(trim(replace(loyer_maximal_apl_mensuel_montant, ',', '.')) as float)
    else null
  end
 as loyer_maximal_apl_mensuel_montant,
        
  
  case
    when try_cast(trim(replace(loyer_maximal_cus_mensuel_montant, ',', '.')) as float) is not null
      then cast(trim(replace(loyer_maximal_cus_mensuel_montant, ',', '.')) as float)
    else null
  end
 as loyer_maximal_cus_mensuel_montant,
        
    case 
        when vente_type_code in ('NA', '0','NC','Z') or vente_type_code is null 
            then 'N/A'
        else vente_type_code
    end
 as vente_type_code,
        mise_en_commercialisation_code,
        
  
  case
    when try_cast(trim(replace(vente_prix_montant, ',', '.')) as float) is not null
      then cast(trim(replace(vente_prix_montant, ',', '.')) as float)
    else null
  end
 as vente_prix_montant,
        
  
  case
    when try_cast(trim(replace(produit_financier_net_montant, ',', '.')) as float) is not null
      then cast(trim(replace(produit_financier_net_montant, ',', '.')) as float)
    else null
  end
 as produit_financier_net_montant,
        
    case
        when remise_en_location_mois is null or trim(remise_en_location_mois) = '' then CAST(NULL AS DATE)
        when upper(trim(remise_en_location_mois)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
        when len(trim(remise_en_location_mois)) != 7 then CAST(NULL AS DATE)
        else TRY_CAST(
            CONCAT(
                SUBSTRING(trim(REPLACE(remise_en_location_mois, '/', '-')), 4, 4), '-',  -- AAAA
                SUBSTRING(trim(REPLACE(remise_en_location_mois, '/', '-')), 1, 2), '-',  -- MM
                '01'                                                               -- JJ (par défaut)
            ) AS DATE
        )
 

        
    end
 as remise_en_location_mois,
        reservation_contingent_code,
        
    case 
        when pmr_code in ('NA', '0','NC','Z') or pmr_code is null 
            then 'N/A'
        else pmr_code
    end
 as pmr_code,
        
    case
        when vente_autorisation_mois is null or trim(vente_autorisation_mois) = '' then CAST(NULL AS DATE)
        when upper(trim(vente_autorisation_mois)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
        when len(trim(vente_autorisation_mois)) != 7 then CAST(NULL AS DATE)
        else TRY_CAST(
            CONCAT(
                SUBSTRING(trim(REPLACE(vente_autorisation_mois, '/', '-')), 4, 4), '-',  -- AAAA
                SUBSTRING(trim(REPLACE(vente_autorisation_mois, '/', '-')), 1, 2), '-',  -- MM
                '01'                                                               -- JJ (par défaut)
            ) AS DATE
        )
 

        
    end
 as vente_autorisation_mois,
        
    case
        when vente_effective_mois is null or trim(vente_effective_mois) = '' then CAST(NULL AS DATE)
        when upper(trim(vente_effective_mois)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
        when len(trim(vente_effective_mois)) != 7 then CAST(NULL AS DATE)
        else TRY_CAST(
            CONCAT(
                SUBSTRING(trim(REPLACE(vente_effective_mois, '/', '-')), 4, 4), '-',  -- AAAA
                SUBSTRING(trim(REPLACE(vente_effective_mois, '/', '-')), 1, 2), '-',  -- MM
                '01'                                                               -- JJ (par défaut)
            ) AS DATE
        )
 

        
    end
 as vente_effective_mois,
        
    case
        when locataire_dernier_depart_date is null or trim(locataire_dernier_depart_date) = '' then CAST(NULL AS DATE)
        when upper(trim(locataire_dernier_depart_date)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
        when len(trim(locataire_dernier_depart_date)) < 10 then CAST(NULL AS DATE)
        else TRY_CAST(
            CONCAT(
                SUBSTRING(trim(REPLACE(locataire_dernier_depart_date, '/', '-')), 7, 4), '-',  -- AAAA
                SUBSTRING(trim(REPLACE(locataire_dernier_depart_date, '/', '-')), 4, 2), '-',  -- MM
                SUBSTRING(trim(REPLACE(locataire_dernier_depart_date, '/', '-')), 1, 2)        -- JJ
            ) AS DATE
        )
    
    end
 as locataire_dernier_depart_date,
        
    case
        -- Valeurs nulles ou codes à ignorer
        when dpe_energie_consommation_valeur is null 
          or dpe_energie_consommation_valeur in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(dpe_energie_consommation_valeur as integer) is not null 
        then cast(dpe_energie_consommation_valeur as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(dpe_energie_consommation_valeur as float) is not null 
        then cast(cast(dpe_energie_consommation_valeur as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as dpe_energie_consommation_valeur,
        
    case
        -- Valeurs nulles ou codes à ignorer
        when dpe_ges_consommation_valeur is null 
          or dpe_ges_consommation_valeur in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(dpe_ges_consommation_valeur as integer) is not null 
        then cast(dpe_ges_consommation_valeur as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(dpe_ges_consommation_valeur as float) is not null 
        then cast(cast(dpe_ges_consommation_valeur as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as dpe_ges_consommation_valeur,
        dpe_reference_num,
        logement_fiscal_id,
        organisme_categorie_code,
        organisme_raison_sociale_libelle,
        RIGHT('00000000000000' + organisme_siret_code, 14) as organisme_siret_code,
        departement_code,
        departement_libelle,
        region_code,
        region_libelle,
        epci_code,
        epci_libelle,
        departements_epci_list,
        regions_epci_list,
        var_financement_groupe_libelle,
        var_mise_en_service_flag,
        
  
  case
    when try_cast(trim(replace(var_loyer_moyen_mensuel_m2_montant, ',', '.')) as float) is not null
      then cast(trim(replace(var_loyer_moyen_mensuel_m2_montant, ',', '.')) as float)
    else null
  end
 as var_loyer_moyen_mensuel_m2_montant,
        var_logement_anciennete_en_annee,
        var_deconventionnement_flag,
        
    case
        when var_duree_vacance_mois is null or trim(var_duree_vacance_mois) = '' then CAST(NULL AS DATE)
        when upper(trim(var_duree_vacance_mois)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
        when len(trim(var_duree_vacance_mois)) < 10 then CAST(NULL AS DATE)
        else TRY_CAST(
            CONCAT(
                SUBSTRING(trim(REPLACE(var_duree_vacance_mois, '/', '-')), 7, 4), '-',  -- AAAA
                SUBSTRING(trim(REPLACE(var_duree_vacance_mois, '/', '-')), 4, 2), '-',  -- MM
                SUBSTRING(trim(REPLACE(var_duree_vacance_mois, '/', '-')), 1, 2)        -- JJ
            ) AS DATE
        )
    
    end
  as var_duree_vacance_mois,
        
    case
        when var_remise_en_location_annee is null or trim(var_remise_en_location_annee) = '' then CAST(NULL AS DATE)
        when upper(trim(var_remise_en_location_annee)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
            when len(trim(var_remise_en_location_annee)) != 4 then CAST(NULL AS DATE)
            else TRY_CAST(var_remise_en_location_annee + '-01-01' AS DATE)
        
        
    end
  as var_remise_en_location_annee,
        
    case
        when var_remise_en_location_mois is null or trim(var_remise_en_location_mois) = '' then CAST(NULL AS DATE)
        when upper(trim(var_remise_en_location_mois)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
        when len(trim(var_remise_en_location_mois)) < 10 then CAST(NULL AS DATE)
        else TRY_CAST(
            CONCAT(
                SUBSTRING(trim(REPLACE(var_remise_en_location_mois, '/', '-')), 7, 4), '-',  -- AAAA
                SUBSTRING(trim(REPLACE(var_remise_en_location_mois, '/', '-')), 4, 2), '-',  -- MM
                SUBSTRING(trim(REPLACE(var_remise_en_location_mois, '/', '-')), 1, 2)        -- JJ
            ) AS DATE
        )
    
    end
 as var_remise_en_location_mois,
        
    case
        when var_bail_effet_mois is null or trim(var_bail_effet_mois) = '' then CAST(NULL AS DATE)
        when upper(trim(var_bail_effet_mois)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
        when len(trim(var_bail_effet_mois)) < 10 then CAST(NULL AS DATE)
        else TRY_CAST(
            CONCAT(
                SUBSTRING(trim(REPLACE(var_bail_effet_mois, '/', '-')), 7, 4), '-',  -- AAAA
                SUBSTRING(trim(REPLACE(var_bail_effet_mois, '/', '-')), 4, 2), '-',  -- MM
                SUBSTRING(trim(REPLACE(var_bail_effet_mois, '/', '-')), 1, 2)        -- JJ
            ) AS DATE
        )
    
    end
 as var_bail_effet_mois,
        
    case
        when var_bail_effet_annee is null or trim(var_bail_effet_annee) = '' then CAST(NULL AS DATE)
        when upper(trim(var_bail_effet_annee)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
            when len(trim(var_bail_effet_annee)) != 4 then CAST(NULL AS DATE)
            else TRY_CAST(var_bail_effet_annee + '-01-01' AS DATE)
        
        
    end
 as var_bail_effet_annee,
        
    case
        when var_bail_effet_date is null or trim(var_bail_effet_date) = '' then CAST(NULL AS DATE)
        when upper(trim(var_bail_effet_date)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
        when len(trim(var_bail_effet_date)) < 10 then CAST(NULL AS DATE)
        else TRY_CAST(
            CONCAT(
                SUBSTRING(trim(REPLACE(var_bail_effet_date, '/', '-')), 7, 4), '-',  -- AAAA
                SUBSTRING(trim(REPLACE(var_bail_effet_date, '/', '-')), 4, 2), '-',  -- MM
                SUBSTRING(trim(REPLACE(var_bail_effet_date, '/', '-')), 1, 2)        -- JJ
            ) AS DATE
        )
    
    end
 as var_bail_effet_date,
        
    case
        when var_remise_en_location_date is null or trim(var_remise_en_location_date) = '' then CAST(NULL AS DATE)
        when upper(trim(var_remise_en_location_date)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
        when len(trim(var_remise_en_location_date)) < 10 then CAST(NULL AS DATE)
        else TRY_CAST(
            CONCAT(
                SUBSTRING(trim(REPLACE(var_remise_en_location_date, '/', '-')), 7, 4), '-',  -- AAAA
                SUBSTRING(trim(REPLACE(var_remise_en_location_date, '/', '-')), 4, 2), '-',  -- MM
                SUBSTRING(trim(REPLACE(var_remise_en_location_date, '/', '-')), 1, 2)        -- JJ
            ) AS DATE
        )
    
    end
 as var_remise_en_location_date

    from
        cte_rename_raw_sdes_rpls_logement
),

 
cte_finale as
(
    select 
        *
        , cast(current_timestamp as datetime2(3)) as _meta_loaded_at

    from cte_clean_and_type_raw_sdes_rpls_logement
)
     

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale