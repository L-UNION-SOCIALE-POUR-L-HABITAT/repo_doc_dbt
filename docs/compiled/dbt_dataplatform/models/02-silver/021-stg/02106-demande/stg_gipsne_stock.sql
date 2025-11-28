/**
 *
 * Description :    Alimentation de la table staging stg_gipsne_stock
 *                  Renommage, nettoyage, typage
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          raw_gipsne_stock
 * Cible :          stg_gipsne_stock
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_gipsne_stock as 
 (
    select 
        [_meta_year]                        as demande_et_radiation_sne_millesime,
        [DEMANDE]                           as demande_id ,
        [NUMERO_UNIQUE]                     as demande_numero ,
        [TYPE_DEMANDEUR]                    as demandeur_type_code,
        [DATE_CREATION]                     as demande_creation_date,
        [MOTIF_DEMANDE]                     as demande_motif_premier_cle,
        [DATE_NAISS_DEMANDEUR]              as demandeur_naissance_date,
        [AGE_DEMANDEUR_DEMANDE]             as demandeur_age,
        [SEXE_DEMANDEUR]                    as demandeur_sexe_cle,
        [STATUT_PROF_DEMANDEUR]             as demandeur_statut_professionnel_cle,
        [NATIONALITE_DEMANDEUR]             as demandeur_nationalite_cle,
        [SITU_FAMILIALE_DEMANDEUR]          as demandeur_situation_familiale_cle,
        [TAILLE_MENAGE]                     as foyer_taille,
        [COTITULAIRE]                       as cotitulaire_nombre,
        [PERSONNE_A_CHARGE]                 as personne_a_charge_nombre,
        [COMPOSITION_FAMILLE]               as demandeur_composition_familiale_code,
        [UNITE_CONSO]                       as unite_de_consommation_nombre,
        [REVENU_DEMANDEUR]                  as demandeur_revenu_mensuel_montant,
        [REVENU_MENSUEL_FOYER]              as foyer_revenu_mensuel_montant,
        [REVENU_FISCAL1_FOYER]              as foyer_revenu_fiscal_1_montant,
        [REVENU_FISCAL2_FOYER]              as foyer_revenu_fiscal_2_montant,
        [CATEG_LOGEMENT_ACTUEL]             as logement_actuel_categorie_cle,
        [TYPE_LOGEMENT_ACTUEL]              as logement_actuel_piece_nombre_cle,
        [MODE_LOGEMENT_ACTUEL]              as logement_actuel_mode_logement_cle,
        [COMMUNE_LOG_ACTUEL]                as logement_actuel_commune_cle,
        [ZONAGEPLAFRESS_ACTUEL]             as logement_actuel_zone_plafond_ressource_cle,
        [CATEG_LOGEMENT_RECHERCHE]          as logement_recherche_categorie_cle,
        [TYPE_LOGEMENT_RECHERCHE]           as logement_recherche_nombre_piece_cle,
        [COMMUNE_LOG_RECHERCHE]             as logement_recherche_commune_cle,
        [ZONAGEPLAFRESS_RECHERCHE]          as logement_recherche_zone_plafond_ressource_cle,
        [MT_APL_MENSUEL]                    as apl_mensuel_montant,
        [MODE_MUTATION]                     as mutation_flag,
        [ESTANRU]                           as anru_flag,
        [VERSION_CERFA]                     as cerfa_version_code,
        [NB_PHANDICAP_AUTONOMIE]            as handicape_nombre
       
        -- [GUICHET_ENREGISTREUR], 
        -- [DATE_RENOUVELLEMENT],
        -- [ETAT_DEMANDE],        
        -- [DATE_RADIATION],
        -- [MOTIF_RADIATION],        
        -- [TRANCHE_AGE_DEMANDEUR],        
        -- [TRANCHE_AGE_DEM_DEMANDE],        
        -- [CATEGORIE_TAILLE_MENAGE],
        -- [TRANCHE_TAILLE_MENAGE],        
        -- [TRANCHE_REVENU_DEMANDEUR],       
        -- [TRANCHE_REV_MENS_FOYER],
        -- [GROUPE_REVENU_FOYER],        
        -- [TRANCHE_REV_FISC1_FOYER],        
        -- [POSITION_PLAFOND],
        -- [TRANCHE_REV_FISC2_FOYER],
        -- [REVENU_UNITE_CONSO],
        -- [TRANCHE_REVENU_UNITE_CONSO],        
        -- [ZONAGE123_ACTUEL],
        -- [ZONAGEABC_ACTUEL],        
        -- [LOG_RECHERCHE_ADAPT_HANDI],
        -- [NOMBRE_EQUIP_HANDICAP],
        -- [MONTANT_LOYER_MAXI],        
        -- [ZONAGE123_RECHERCHE],
        -- [ZONAGEABC_RECHERCHE],       
        -- [TYPE_LOGEMENT_ATTRIB]              
        -- [COMMUNE_LOGEMENT_ATTRIB]            
        -- [ZONAGE123_ATTRIB],
        -- [ZONAGEABC_ATTRIB],
        -- [ZONAGEPLAFRESS_ATTRIB]              
        -- [TYPE_RESERVATAIRE],
        -- [DELAI_ATTRIBUTION],
        -- [TRANCHE_DELAI_ATTRIBUTION],
        -- [DATE_MAJ_DWH],
        -- [LOG_ATTRIBUE_CLE_ZUS],
        -- [SIREN_RADIATION],
        -- [NUMERORPLS],
        -- [DOUBLON_FORCE],
        -- [CLE_GUICHETCREATEUR],
        -- [NB_ENFANT_A_NAITRE],
        -- [NB_PERS_GARDE],
        -- [MT_LOYER_MENSUEL_ACTUEL],        
        -- [NBRE_HABITANT_ACTUEL],
        -- [PROPRIETAIRE_ACTUEL],
        -- [CONTACT_MAIL],
        -- [DATE_PREAVIS_SIMPLE],
        -- [DATE_PREAVIS_AR],
        -- [DATE_SIGNATURE_BAIL],
        -- [ATTRIBUE_DALO],
        -- [ACCORD_COLLECTIF_ID],
        -- [DATE_ETAT],
        -- [DATE_MODIFICATION],        
        -- [TRANCHE_REVENU_UC_STOCK],
        -- [MONTANT_LOYER],
        -- [SURFACE],
        -- [EST_DEMANDE_ELARGIE],
        -- [POSITION_PLAFOND_ATTRIB],
        -- [DEMANDEINFOSSITE_ID],
        -- [ESTCREEESITEGRANDPUBLIC],
        -- [SURFACE_ACTUEL],
        -- [COMPSIRENORGBAILLEUR],
        -- [ESTAVECPARKING],
        -- [ESTREZDECHAUSSEE],
        -- [ESTSANSASCENSEUR],
        -- [ESTADAPTEHANDICAP],
        -- [DERNIERE_CONNEXION_PGP],        
        -- [NB_COLOCATAIRE],
        -- [SMOTIF_RADIATION],
        -- [NB_DA],
        -- [NB_ANRU],
        -- [NB_QPV],
        -- [NB_HQPV],
        -- [NB_Q1],
        -- [NB_Q2],
        -- [NB_Q3],
        -- [NB_Q4],
        -- [NB_QNA],
        -- [NB_MIXITE_Q1],
        -- [NB_MIXITE_QPV],
        -- [NB_DALO],
        -- [NB_SYPLO],
        -- [NB_L441],
        -- [NB_PRIORITE_CERFA],
        -- [NB_CERFA_PRIO_HANDICAP],
        -- [NB_CERFA_PRIO_CHOMAGE],
        -- [NB_CERFA_PRIO_COORD_THERAPIE],
        -- [NB_CERFA_PRIO_LOGT_INDIGNE],
        -- [NB_CERFA_PRIO_EXPULSION],
        -- [NB_CERFA_PRIO_VIOLENCE],
        -- [NB_CERFA_PRIO_LOGT_NON_DECENT],
        -- [NB_CERFA_PRIO_LOGT_SUROCCUPE],
        -- [NB_CERFA_PRIO_SANS_LOGT],
        -- [NB_CERFA_PRIO_HEBERGE_TIERS],
        -- [NB_CERFA_PRIO_HEBERGE_TEMPO],
        -- [NB_COTATION_PRIO_SORTIE_PROSTI],
        -- [NB_COTATION_PRIO_VICTIME_TRAITE],
        -- [NB_COTATION_PRIO_VICTIME_VIOL],
        -- [NB_PRIORITE_COTATION],
        -- [NB_MENAGE_PRIORITAIRE],
        -- [NB_CDD_INTERIM],
        -- [NB_CHOMAGE_LONG],
        -- [DATE_SORTIE_CHOMAGELONG],
        -- [NB_PHANDICAP],
        -- [CLE_HANDICAP_AUTONOMIE],        
        -- [NB_TRAVAILLEUR_ESSENTIEL],
        -- [NB_DEJA_LOGE_PARC],
        -- [NB_PERS_A_LOGER],
        -- [NB_PJRFR],
        -- [NB_PJIDENTITE],
        -- [LOG_ATTRIBUE_CLE_ZUS2015],
        -- [CLE_QPV],
        -- [CLE_QPV2015],
        -- [CLE_ETAT_RPLS],
        -- [NB_QPVNA],
        -- [NB_JEUNE_MENAGE],
        -- [NB_Q1_STOCK],
        -- [NB_Q2_STOCK],
        -- [NB_Q3_STOCK],
        -- [NB_Q4_STOCK],
        -- [POSITION_SEUIL],
        -- [COMMUNE_ACTUEL_VS_RECHERCHE],
        -- [COMMUNE_ACTUEL_VS_ATTRIB],
        -- [COMMUNE_RECHERCHE_VS_ATTRIB],
        -- [TYPELOGEMENT_ACTUEL_VS_RECHERCHE],
        -- [TYPELOGEMENT_ACTUEL_VS_ATTRIB],
        -- [TYPELOGEMENT_RECHERCHE_VS_ATTRIB],
        
         
    from   "wh_dp_bronze"."raw"."raw_gipsne_stock"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_gipsne_stock as 
 (
    select
        
    case
        -- Valeurs nulles ou codes à ignorer
        when demande_et_radiation_sne_millesime is null 
          or demande_et_radiation_sne_millesime in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(demande_et_radiation_sne_millesime as integer) is not null 
        then cast(demande_et_radiation_sne_millesime as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(demande_et_radiation_sne_millesime as float) is not null 
        then cast(cast(demande_et_radiation_sne_millesime as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
            
                                as demande_et_radiation_sne_millesime
        , 
    case
        -- Gestion des valeurs nulles ou vides
        when demande_et_radiation_sne_millesime is null or trim(demande_et_radiation_sne_millesime) = '' then CAST(NULL AS DATE)
        
        -- Gestion des valeurs 'NA' (Not Available)
        when upper(trim(demande_et_radiation_sne_millesime)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        -- Format MM/AAAA (ex: 05/1981)
        -- Convertit en AAAA-MM-01 (1er du mois par défaut)
        
            when len(trim(demande_et_radiation_sne_millesime)) != 4 then CAST(NULL AS DATE)
            else TRY_CAST(demande_et_radiation_sne_millesime + '-01-01' AS DATE)
        
        -- AUTO-DÉTECTION pour les vraies dates
        
    end
        
                                as demande_et_radiation_sne_millesime_date
        , demande_numero
        , demande_id
        , demandeur_type_code
        , 
    case
        -- Gestion des valeurs nulles ou vides
        when demande_creation_date is null or trim(demande_creation_date) = '' then CAST(NULL AS DATE)
        
        -- Gestion des valeurs 'NA' (Not Available)
        when upper(trim(demande_creation_date)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        -- Format MM/AAAA (ex: 05/1981)
        -- Convertit en AAAA-MM-01 (1er du mois par défaut)
        
            -- Détection automatique du format basée sur la structure de la chaîne
            when len(trim(demande_creation_date)) < 10 then CAST(NULL AS DATE)
            
            -- Si la chaîne contient un tiret en position 5 (AAAA-MM-JJ ou AAAA-MM-JJ HH:MI:SS)
            when SUBSTRING(trim(demande_creation_date), 5, 1) = '-' then 
                TRY_CAST(LEFT(trim(demande_creation_date), 10) AS DATE)
            
            -- Si la chaîne contient un séparateur (/ ou -) en position 3 (JJ/MM/AAAA ou JJ-MM-AAAA)
            when SUBSTRING(trim(demande_creation_date), 3, 1) in ('/', '-') then 
                TRY_CAST(
                    CONCAT(
                        SUBSTRING(trim(REPLACE(demande_creation_date, '/', '-')), 7, 4), '-',  -- Année
                        SUBSTRING(trim(REPLACE(demande_creation_date, '/', '-')), 4, 2), '-',  -- Mois
                        SUBSTRING(trim(REPLACE(demande_creation_date, '/', '-')), 1, 2)        -- Jour
                    ) AS DATE
                )
            
            -- Fallback : valeur par défaut si aucun format détecté
            else CAST(NULL AS DATE)
        
    end
  
                                as demande_creation_date
        , demande_motif_premier_cle
        , 
    case
        -- Gestion des valeurs nulles ou vides
        when demandeur_naissance_date is null or trim(demandeur_naissance_date) = '' then CAST(NULL AS DATE)
        
        -- Gestion des valeurs 'NA' (Not Available)
        when upper(trim(demandeur_naissance_date)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        -- Format MM/AAAA (ex: 05/1981)
        -- Convertit en AAAA-MM-01 (1er du mois par défaut)
        
            -- Détection automatique du format basée sur la structure de la chaîne
            when len(trim(demandeur_naissance_date)) < 10 then CAST(NULL AS DATE)
            
            -- Si la chaîne contient un tiret en position 5 (AAAA-MM-JJ ou AAAA-MM-JJ HH:MI:SS)
            when SUBSTRING(trim(demandeur_naissance_date), 5, 1) = '-' then 
                TRY_CAST(LEFT(trim(demandeur_naissance_date), 10) AS DATE)
            
            -- Si la chaîne contient un séparateur (/ ou -) en position 3 (JJ/MM/AAAA ou JJ-MM-AAAA)
            when SUBSTRING(trim(demandeur_naissance_date), 3, 1) in ('/', '-') then 
                TRY_CAST(
                    CONCAT(
                        SUBSTRING(trim(REPLACE(demandeur_naissance_date, '/', '-')), 7, 4), '-',  -- Année
                        SUBSTRING(trim(REPLACE(demandeur_naissance_date, '/', '-')), 4, 2), '-',  -- Mois
                        SUBSTRING(trim(REPLACE(demandeur_naissance_date, '/', '-')), 1, 2)        -- Jour
                    ) AS DATE
                )
            
            -- Fallback : valeur par défaut si aucun format détecté
            else CAST(NULL AS DATE)
        
    end
  
                                as demandeur_naissance_date
        , 
    case
        -- Valeurs nulles ou codes à ignorer
        when demandeur_age is null 
          or demandeur_age in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(demandeur_age as integer) is not null 
        then cast(demandeur_age as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(demandeur_age as float) is not null 
        then cast(cast(demandeur_age as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 
                                as demandeur_age
        , demandeur_sexe_cle
        , demandeur_statut_professionnel_cle
        , demandeur_nationalite_cle
        , demandeur_situation_familiale_cle
        , 
    case
        -- Valeurs nulles ou codes à ignorer
        when foyer_taille is null 
          or foyer_taille in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(foyer_taille as integer) is not null 
        then cast(foyer_taille as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(foyer_taille as float) is not null 
        then cast(cast(foyer_taille as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 
                                as foyer_taille
        , 
    case
        -- Valeurs nulles ou codes à ignorer
        when cotitulaire_nombre is null 
          or cotitulaire_nombre in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(cotitulaire_nombre as integer) is not null 
        then cast(cotitulaire_nombre as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(cotitulaire_nombre as float) is not null 
        then cast(cast(cotitulaire_nombre as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 
                                as cotitulaire_nombre 
        , 
    case
        -- Valeurs nulles ou codes à ignorer
        when personne_a_charge_nombre is null 
          or personne_a_charge_nombre in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(personne_a_charge_nombre as integer) is not null 
        then cast(personne_a_charge_nombre as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(personne_a_charge_nombre as float) is not null 
        then cast(cast(personne_a_charge_nombre as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 
                                as personne_a_charge_nombre  
        ,demandeur_composition_familiale_code
        , 
  
  case
    when try_cast(trim(replace(unite_de_consommation_nombre, ',', '.')) as float) is not null
      then cast(trim(replace(unite_de_consommation_nombre, ',', '.')) as float)
    else  CAST(0 as FLOAT)
  end
 
                                as unite_de_consommation_nombre 
        , 
  
  case
    when try_cast(trim(replace(demandeur_revenu_mensuel_montant, ',', '.')) as float) is not null
      then cast(trim(replace(demandeur_revenu_mensuel_montant, ',', '.')) as float)
    else  CAST(0 as FLOAT)
  end
 
                                as demandeur_revenu_mensuel_montant
        , 
  
  case
    when try_cast(trim(replace(foyer_revenu_mensuel_montant, ',', '.')) as float) is not null
      then cast(trim(replace(foyer_revenu_mensuel_montant, ',', '.')) as float)
    else  CAST(0 as FLOAT)
  end
 
                                as foyer_revenu_mensuel_montant 
        , 
  
  case
    when try_cast(trim(replace(foyer_revenu_fiscal_1_montant, ',', '.')) as float) is not null
      then cast(trim(replace(foyer_revenu_fiscal_1_montant, ',', '.')) as float)
    else  CAST(0 as FLOAT)
  end
 
                                as foyer_revenu_fiscal_1_montant 
        , 
  
  case
    when try_cast(trim(replace(foyer_revenu_fiscal_2_montant, ',', '.')) as float) is not null
      then cast(trim(replace(foyer_revenu_fiscal_2_montant, ',', '.')) as float)
    else  CAST(0 as FLOAT)
  end
 
                                as foyer_revenu_fiscal_2_montant  
        , logement_actuel_categorie_cle
        , logement_actuel_piece_nombre_cle
        , logement_actuel_mode_logement_cle
        , logement_actuel_commune_cle
        , logement_actuel_zone_plafond_ressource_cle
        , logement_recherche_categorie_cle
        , logement_recherche_nombre_piece_cle
        , logement_recherche_commune_cle
        , logement_recherche_zone_plafond_ressource_cle
        , 
  
  case
    when try_cast(trim(replace(apl_mensuel_montant, ',', '.')) as float) is not null
      then cast(trim(replace(apl_mensuel_montant, ',', '.')) as float)
    else  CAST(0 as FLOAT)
  end
 
                                as apl_mensuel_montant 
        , 
  
  case
    when trim(mutation_flag) in ('1','Oui') then cast(1 as bit)
    else cast(0 as bit)
  end
 
                                as mutation_flag  
        , 
  
  case
    when trim(anru_flag) in ('1','Oui') then cast(1 as bit)
    else cast(0 as bit)
  end
 
                                as anru_flag 
        , cerfa_version_code
        , 
    case
        -- Valeurs nulles ou codes à ignorer
        when handicape_nombre is null 
          or handicape_nombre in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(handicape_nombre as integer) is not null 
        then cast(handicape_nombre as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(handicape_nombre as float) is not null 
        then cast(cast(handicape_nombre as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 
                                as handicape_nombre 

       
    from  cte_rename_raw_gipsne_stock
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

    from cte_clean_and_type_raw_gipsne_stock
)

 
select 
    *
from 
    cte_finale