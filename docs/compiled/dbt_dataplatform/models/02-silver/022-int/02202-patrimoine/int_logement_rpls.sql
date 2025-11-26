/**
 *
 * Description :    Alimentation de la table intermediate int_logement_rpls
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          stg_sdes_rpls_logement
 * Cible :          int_logement_rpls



 */




 with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
 -- Sélection des colonnes 
 cte_stg_sdes_rpls_logement as 
 (
    select 
        
        logement_rpls_millesime,
        logement_rpls_millesime_date,
        logement_rpls_id,
        logement_bailleur_systeme_id,
        organisme_id,
        immobilier_droit_code,
        commune_code        as commune_code_source,
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
        qpv_flag,
        construction_type_code,
        piece_nombre_code,
        surface_habitable_m2,
        construction_achevement_annee,
        mise_en_location_premiere_annee,
        patrimoine_entree_annee,
        patrimoine_origine_code,
        proprietaire_precedent_raison_sociale_libelle,
        proprietaire_precedent_siret_num,
        financement_initial_code,
        financement_autre_libelle,
        convention_flag,
        convention_num,
        convention_date,
        patrimoine_sortie_code,
        logement_old_code,
        logement_new_code,
        occupation_mode_code,
        bail_effet_mois,
        surface_mode_code,
        surface_mode_m2,
        loyer_principal_mensuel_montant,
        loyer_accessoire_mensuel_montant,
        contribution_montant,
        financement_cus_code,
        dpe_mois,
        dpe_energie_code,
        dpe_ges_code,
        sru_expiration_annee,
        sru_alinea_code,
        organisme_gestionnaire_id,
        patrimoine_segment_code,
        patrimoine_segment_libelle,
        loyer_maximal_apl_mensuel_montant,
        loyer_maximal_cus_mensuel_montant,
        vente_type_code,
        mise_en_commercialisation_code,
        vente_prix_montant,
        produit_financier_net_montant,
        remise_en_location_mois,
        reservation_contingent_code,
        pmr_code                        as pmr_code_source,
        vente_autorisation_mois,
        vente_effective_mois,
        locataire_dernier_depart_date,
        dpe_energie_consommation_valeur,
        dpe_ges_consommation_valeur,
        dpe_reference_num,
        logement_fiscal_id,
        organisme_categorie_code,
        organisme_raison_sociale_libelle,
        organisme_siret_code,
        --departement_code,
        -- departement_libelle,
        --region_code,
        -- region_libelle,
        --epci_code,
        -- epci_libelle,
        -- departements_epci_list,
        -- regions_epci_list,
        var_financement_groupe_libelle,
        var_mise_en_service_flag
        -- var_loyer_moyen_mensuel_m2_montant,
        -- var_logement_anciennete_en_annee,
        -- var_deconventionnement_flag,
        -- var_duree_vacance_mois,
        -- var_remise_en_location_annee,
        -- var_remise_en_location_mois,
        -- var_bail_effet_mois,
        -- var_bail_effet_annee,
        -- var_bail_effet_date,
        -- var_remise_en_location_date

    from 
        "wh_dp_silver"."stg"."stg_sdes_rpls_logement"
 ),

 cte_map_financement_groupe as 
 (
    select 
        financement_initial_code,
        convention_flag,
        financement_groupe_code
    from   
        "wh_dp_bronze"."seed"."map_financement_groupe"
 ),

 
 cte_map_pmr_code as 
 (
    select 
        pmr_code_source,
        pmr_code_cible
    from   
        "wh_dp_bronze"."seed"."map_pmr_code"
 ),


cte_int_arrondissement as
(
    select 
        arrondissement_annee,
        arrondissement_code,
        arrondissement_libelle,
        commune_code
    from 
        "wh_dp_silver"."int"."int_arrondissement"
),
 
cte_int_passage_commune_histo as
(
    select 
        passage_commune_annee,
        commune_initiale_code,
        commune_finale_code
    from 
        "wh_dp_silver"."int"."int_passage_commune_histo"
),
 
cte_int_commune as
(
    select 
        commune_annee,
        commune_code 
    from 
        "wh_dp_silver"."int"."int_commune"
), 
 
-------------------------------------------------------------------
--*********************** TRANSFORMATIONS *************************
-------------------------------------------------------------------
-- Ajout des colonnes calculées
 cte_calc_stg_sdes_rpls_logement  as 
 (
    select
        
        stg_sdes_rpls_logement.*,
        isnull(int_arrondissement.commune_code, stg_sdes_rpls_logement.commune_code_source)                                 
            as commune_code_origine,
        isnull(int_arrondissement.arrondissement_code,'N/A')                                                                              
            as arrondissement_code,
        substring(organisme_siret_code, 1,9)                                                                                
            as organisme_siren_code, 
        -- en incremental a voir comment mettre a jour ce champ pour les annees precedentes
        cast (
                
    case
        when (logement_rpls_millesime) = (
            select max((logement_rpls_millesime))
            from "wh_dp_silver"."stg"."stg_sdes_rpls_logement"
        ) then 1
        else 0
    end
 
                as bit)                                           
            as logement_rpls_millesime_last_flag,
        cast ( case
            when year(bail_effet_mois) = logement_rpls_millesime-1 AND occupation_mode_code = 1
                then 1
            else 0
        end as bit)                                                                                                                
            as emmenagement_flag ,
        --  bail_effet_annee_prec_flag: a voir si pas la meme chose que emmenagement_flag
        cast ( case
            when year(bail_effet_mois) = logement_rpls_millesime-1  
                then 1
            else 0
        end as bit)
            as bail_effet_annee_prec_flag,
     
        cast (case
            when year(remise_en_location_mois) = logement_rpls_millesime-1  
                then 1
            else 0
        end as bit)
            as bail_fin_annee_prec_flag,
        case
            when organisme_categorie_code in ('131','132','133','134','136') 
                then 'OPH'
            when organisme_categorie_code = '211' 
                then 'ESH'
            when organisme_categorie_code in ('251','259')
                then 'SEM'
            when organisme_categorie_code in ('221','222','223')
                then 'Coop'
            when organisme_categorie_code in ('241','611') AND substring(organisme_raison_sociale_libelle,1,12) not in ('SCI Foncière','SCI Fonciere') 
                then 'SACICAP'   
            else 'Autres'
        end                                                                                                                 
            as organisme_famille_rpls_code,     
        map_financement_groupe.financement_groupe_code
            as financement_groupe_code,  
        logement_rpls_millesime - year(construction_achevement_annee) 
            as construction_anciennete_en_annee,
        case 
            when stg_sdes_rpls_logement.convention_flag = 0 and organisme_categorie_code in ('251','259')
                then 1
            else 0
        end   
            as sem_non_convention_flag,                                                                                                              
        case 
            when 
                var_financement_groupe_libelle in ('Non soc inter_CDC','Non soc inter_Reunion')
                then 1 
            else 0
        end  
             as logement_loyer_libre_flag,                                                                                                              
        -- Lors de l'intégration de toutes les années, il faudrait recalculer ce champ chez nous, car ce champ peut être erroné
        cast (var_mise_en_service_flag as bit)     
            as mise_en_service_flag,
        isnull(pmr.pmr_code_cible,stg_sdes_rpls_logement.pmr_code_source) as pmr_code                                                                                      
        
         
    from 
        cte_stg_sdes_rpls_logement stg_sdes_rpls_logement

    left join cte_map_financement_groupe map_financement_groupe 
        on  stg_sdes_rpls_logement.financement_initial_code = map_financement_groupe.financement_initial_code
        and stg_sdes_rpls_logement.convention_flag = map_financement_groupe.convention_flag
    
    left join cte_map_pmr_code pmr
        on stg_sdes_rpls_logement.pmr_code_source = pmr.pmr_code_source

    --le code commune qui se trouve dans la table rpls, peut etre soit un code commune soit un code arrondissement
    left join cte_int_arrondissement int_arrondissement
        on  stg_sdes_rpls_logement.commune_code_source = int_arrondissement.arrondissement_code
        and stg_sdes_rpls_logement.logement_rpls_millesime = int_arrondissement.arrondissement_annee
            

 ),
/*
Parfois, une commune présente dans le RPLS n'existe pas dans le référentiel des communes pour la même année.

Exemple :
En 2023, le code commune 85053 est dans le RPLS, mais pas dans le référentiel.

Solution :
On utilise une table de correspondance (appelée "passage commune") pour retrouver le nouveau code de commune valide.

Exemple :
Dans la table de passage :
codgeo_ini = 85053, codgeo = 85289, année = 2023

On remplace donc 85053 par 85289 dans le RPLS pour pouvoir faire la jointure avec le référentiel.
*/
cte_corrige_commune_rpls_logement as
(

    select 
        cte_calc_stg_sdes_rpls_logement.*
        , isnull(cte_int_passage_commune_histo.commune_finale_code, cte_calc_stg_sdes_rpls_logement.commune_code_origine)
            as commune_code

    from cte_calc_stg_sdes_rpls_logement
    left join cte_int_passage_commune_histo 
        on (
            cte_calc_stg_sdes_rpls_logement.commune_code_origine = cte_int_passage_commune_histo.commune_initiale_code
            and
            cte_calc_stg_sdes_rpls_logement.logement_rpls_millesime = cte_int_passage_commune_histo.passage_commune_annee
            and
            -- que pour les communes du rpls qu'on ne trouve pas dans le referentiel
            not exists (
                select commune_code
                from
                    cte_int_commune
                where 
                    cte_int_commune.commune_code = cte_calc_stg_sdes_rpls_logement.commune_code_origine
                    and
                    cte_int_commune.commune_annee = cte_calc_stg_sdes_rpls_logement.logement_rpls_millesime
                        )
        )
  
),

-- Ajout des clés business
cte_bk_calc_sdes_rpls_logement as
(
    select 
        *
        ,  
    
        concat_ws('||', logement_rpls_millesime, logement_rpls_id, logement_bailleur_systeme_id, organisme_id) 
    
  
                as logement_rpls_bk
        ,   
    
        concat_ws('||', logement_rpls_millesime, commune_code) 
    
  
                as commune_bk
        ,   
    
        concat_ws('||', logement_rpls_millesime, arrondissement_code) 
    
   
                as arrondissement_bk
    from 
        cte_corrige_commune_rpls_logement

),
-- Ajout des clés techniques
cte_hk_calc_sdes_rpls_logement as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(logement_rpls_bk as varchar(max))
    
)  
 
              as logement_rpls_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(commune_bk as varchar(max))
    
)  
 
                    as commune_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(arrondissement_bk as varchar(max))
    
)  
 
             as arrondissement_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(occupation_mode_code as varchar(max))
    
)  
 
          as occupation_mode_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(financement_initial_code as varchar(max))
    
)  
 
      as financement_initial_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(financement_groupe_code as varchar(max))
    
)  
 
       as financement_groupe_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(pmr_code as varchar(max))
    
)  
 
                      as pmr_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(piece_nombre_code as varchar(max))
    
)  
 
             as piece_nombre_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(surface_mode_code as varchar(max))
    
)  
 
             as surface_mode_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(dpe_energie_code as varchar(max))
    
)  
 
              as dpe_energie_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(dpe_ges_code as varchar(max))
    
)  
 
                  as dpe_ges_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(vente_type_code as varchar(max))
    
)  
 
               as vente_type_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(patrimoine_sortie_code as varchar(max))
    
)  
 
        as patrimoine_sortie_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(patrimoine_origine_code as varchar(max))
    
)  
 
       as patrimoine_origine_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(construction_type_code as varchar(max))
    
)  
 
        as construction_type_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(immobilier_droit_code as varchar(max))
    
)  
 
         as immobilier_droit_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(organisme_famille_rpls_code as varchar(max))
    
)  
 
   as organisme_famille_hk 
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(organisme_categorie_code as varchar(max))
    
)  
 
      as organisme_categorie_hk 
 
    from 
        cte_bk_calc_sdes_rpls_logement
),

 cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc_sdes_rpls_logement
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale