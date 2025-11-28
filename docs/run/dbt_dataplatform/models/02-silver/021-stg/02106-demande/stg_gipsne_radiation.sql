
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "stg"."stg_gipsne_radiation__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table staging stg_gipsne_radiation
 *                  Renommage, nettoyage, typage
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          raw_gipsne_radiation
 * Cible :          stg_gipsne_radiation
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_gipsne_radiation as 
 (
    select 
        [_meta_year]                        as demande_et_radiation_sne_millesime,
        [DEMANDE]                           as demande_id,
        [NUMERO_UNIQUE]                     as demande_numero,
        [DATE_RADIATION]                    as radiation_date,
        [MOTIF_RADIATION]                   as radiation_motif_cle,
        [TYPE_LOGEMENT_ATTRIB]              as logement_attribue_piece_nombre_cle,
        [COMMUNE_LOGEMENT_ATTRIB]           as logement_attribue_commune_cle,
        [ZONAGEPLAFRESS_ATTRIB]             as logement_attribue_zone_plafond_ressource_cle,
        [TYPE_RESERVATAIRE]                 as reservataire_type_cle,
        [DELAI_ATTRIBUTION]                 as attribution_delai_jour_nombre,
        [SIREN_RADIATION]                   as radiation_siren_numero,
        [NUMERORPLS]                        as logement_rpls_id,
        [NB_QPV]                            as qpv_flag  
        -- [TYPE_DEMANDEUR]                     
        -- [GUICHET_ENREGISTREUR],
        -- [DATE_CREATION]                      
        -- [DATE_RENOUVELLEMENT],
        -- [ETAT_DEMANDE],
        -- [MOTIF_DEMANDE]                     
        -- [DATE_NAISS_DEMANDEUR]             -
        -- [TRANCHE_AGE_DEMANDEUR],
        -- [AGE_DEMANDEUR_DEMANDE]             
        -- [TRANCHE_AGE_DEM_DEMANDE],
        -- [SEXE_DEMANDEUR]                 
        -- [STATUT_PROF_DEMANDEUR]              
        -- [NATIONALITE_DEMANDEUR]              
        -- [SITU_FAMILIALE_DEMANDEUR]           
        -- [TAILLE_MENAGE]                     
        -- [CATEGORIE_TAILLE_MENAGE],
        -- [TRANCHE_TAILLE_MENAGE],
        -- [COTITULAIRE]                      
        -- [PERSONNE_A_CHARGE]                  
        -- [COMPOSITION_FAMILLE]               
        -- [UNITE_CONSO]                       
        -- [REVENU_DEMANDEUR]                  
        -- [TRANCHE_REVENU_DEMANDEUR],
        -- [REVENU_MENSUEL_FOYER]               
        -- [TRANCHE_REV_MENS_FOYER],
        -- [GROUPE_REVENU_FOYER],
        -- [REVENU_FISCAL1_FOYER]               
        -- [TRANCHE_REV_FISC1_FOYER],
        -- [REVENU_FISCAL2_FOYER]             
        -- [POSITION_PLAFOND],
        -- [TRANCHE_REV_FISC2_FOYER],
        -- [REVENU_UNITE_CONSO],
        -- [TRANCHE_REVENU_UNITE_CONSO],
        -- [CATEG_LOGEMENT_ACTUEL]              
        -- [TYPE_LOGEMENT_ACTUEL]              
        -- [MODE_LOGEMENT_ACTUEL]              
        -- [COMMUNE_LOG_ACTUEL]                 
        -- [ZONAGE123_ACTUEL],
        -- [ZONAGEABC_ACTUEL],
        -- [ZONAGEPLAFRESS_ACTUEL]             
        -- [CATEG_LOGEMENT_RECHERCHE]          
        -- [TYPE_LOGEMENT_RECHERCHE]           
        -- [LOG_RECHERCHE_ADAPT_HANDI],
        -- [NOMBRE_EQUIP_HANDICAP],
        -- [MONTANT_LOYER_MAXI],
        -- [COMMUNE_LOG_RECHERCHE]             
        -- [ZONAGE123_RECHERCHE],
        -- [ZONAGEABC_RECHERCHE],
        -- [ZONAGEPLAFRESS_RECHERCHE]           
        -- [ZONAGE123_ATTRIB],
        -- [ZONAGEABC_ATTRIB],       
        -- [TRANCHE_DELAI_ATTRIBUTION],
        -- [DATE_MAJ_DWH],
        -- [LOG_ATTRIBUE_CLE_ZUS],       
        -- [DOUBLON_FORCE],
        -- [CLE_GUICHETCREATEUR],
        -- [NB_ENFANT_A_NAITRE],
        -- [NB_PERS_GARDE],
        -- [MT_LOYER_MENSUEL_ACTUEL],
        -- [MT_APL_MENSUEL]                    
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
        -- [MODE_MUTATION]                     
        -- [TRANCHE_REVENU_UC_radiation],
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
        -- [ESTANRU]                           
        -- [VERSION_CERFA]                    
        -- [NB_COLOCATAIRE],
        -- [SMOTIF_RADIATION],
        -- [NB_DA],
        -- [NB_ANRU],
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
        -- [NB_PHANDICAP_AUTONOMIE]           
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
        -- [NB_Q1_radiation],
        -- [NB_Q2_radiation],
        -- [NB_Q3_radiation],
        -- [NB_Q4_radiation],
        -- [POSITION_SEUIL],
        -- [COMMUNE_ACTUEL_VS_RECHERCHE],
        -- [COMMUNE_ACTUEL_VS_ATTRIB],
        -- [COMMUNE_RECHERCHE_VS_ATTRIB],
        -- [TYPELOGEMENT_ACTUEL_VS_RECHERCHE],
        -- [TYPELOGEMENT_ACTUEL_VS_ATTRIB],
        -- [TYPELOGEMENT_RECHERCHE_VS_ATTRIB],
       
         
    from   "wh_dp_bronze"."raw"."raw_gipsne_radiation"
 ),
 -------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_gipsne_radiation as 
 (
    select 
        demande_numero
        , demande_id
        , 
    case
        -- Gestion des valeurs nulles ou vides
        when radiation_date is null or trim(radiation_date) = '''' then CAST(NULL AS DATE)
        
        -- Gestion des valeurs ''NA'' (Not Available)
        when upper(trim(radiation_date)) in (''NA'', ''NA/NA'') then CAST(NULL AS DATE)

        -- Format MM/AAAA (ex: 05/1981)
        -- Convertit en AAAA-MM-01 (1er du mois par défaut)
        
            when len(trim(radiation_date)) < 10 then CAST(NULL AS DATE)
            else TRY_CAST(
                CONCAT(
                    SUBSTRING(trim(REPLACE(radiation_date, ''/'', ''-'')), 7, 4), ''-'',  -- Année (position 7, 4 caractères)
                    SUBSTRING(trim(REPLACE(radiation_date, ''/'', ''-'')), 4, 2), ''-'',  -- Mois (position 4, 2 caractères)
                    SUBSTRING(trim(REPLACE(radiation_date, ''/'', ''-'')), 1, 2)        -- Jour (position 1, 2 caractères)
                ) AS DATE
            )
        
    end
  
                                as radiation_date
        , radiation_motif_cle
        , logement_attribue_piece_nombre_cle
        , logement_attribue_commune_cle
        , logement_attribue_zone_plafond_ressource_cle
        , reservataire_type_cle
        , 
    case
        -- Valeurs nulles ou codes à ignorer
        when attribution_delai_jour_nombre is null 
          or attribution_delai_jour_nombre in (''999'', ''NA'') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(attribution_delai_jour_nombre as integer) is not null 
        then cast(attribution_delai_jour_nombre as integer)

        -- Cas où la valeur est au format scientifique (ex: ''1.1144e+006'')
        when try_cast(attribution_delai_jour_nombre as float) is not null 
        then cast(cast(attribution_delai_jour_nombre as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 
                                as attribution_delai_jour_nombre
        , radiation_siren_numero
        , logement_rpls_id
        , 
  
  case
    when trim(qpv_flag) in (''1'',''Oui'') then cast(1 as bit)
    else cast(0 as bit)
  end
 
                                as qpv_flag   
    
    from 
        cte_rename_raw_gipsne_radiation


 ),

 -------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

cte_finale as
(
    select 
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at

    from cte_clean_and_type_raw_gipsne_radiation
)

 
select 
    *
from 
    cte_finale;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."stg"."stg_gipsne_radiation__dbt_temp" AS SELECT * FROM "wh_dp_silver"."stg"."stg_gipsne_radiation__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  