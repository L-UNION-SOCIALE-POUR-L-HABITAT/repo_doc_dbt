/**
 *
 * Description :    Alimentation de la table intermediate int_demande
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          stg_gipsne_stock    
 * WARNING:         On aura que la dernière géographie, car la table de ref_geographie n'a pas d'année                         
 * Cible :          int_demande
 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_stg_gipsne_stock as 
(
    select 
         demande_et_radiation_sne_millesime
        ,demande_et_radiation_sne_millesime_date
        ,demande_numero
        ,demande_id
        ,demandeur_type_code
        ,demande_creation_date
        ,demande_motif_premier_cle
        ,demandeur_naissance_date
        ,demandeur_age
        ,demandeur_sexe_cle
        ,demandeur_statut_professionnel_cle
        ,demandeur_nationalite_cle
        ,demandeur_situation_familiale_cle
        ,foyer_taille
        ,cotitulaire_nombre
        ,personne_a_charge_nombre
        ,demandeur_composition_familiale_code
        ,unite_de_consommation_nombre
        ,demandeur_revenu_mensuel_montant
        ,foyer_revenu_mensuel_montant
        ,foyer_revenu_fiscal_1_montant
        ,foyer_revenu_fiscal_2_montant
        ,logement_actuel_categorie_cle
        ,logement_actuel_piece_nombre_cle
        ,logement_actuel_mode_logement_cle
        ,logement_actuel_commune_cle
        ,logement_actuel_zone_plafond_ressource_cle
        ,logement_recherche_categorie_cle
        ,logement_recherche_nombre_piece_cle
        ,logement_recherche_commune_cle
        ,logement_recherche_zone_plafond_ressource_cle
        ,apl_mensuel_montant
        ,mutation_flag
        ,anru_flag
        ,cerfa_version_code
        ,handicape_nombre


    from "wh_dp_silver"."stg"."stg_gipsne_stock"
),
 
cte_int_demande_motif as
(
    select 
        demande_motif_cle
        , demande_motif_code
    from 
        "wh_dp_silver"."int"."int_demande_motif"
),

cte_int_statut_professionnel as
(
    select 
        statut_professionnel_cle
        , statut_professionnel_code
    from 
        "wh_dp_silver"."int"."int_statut_professionnel"
),

cte_int_situation_familiale as
(
    select 
        situation_familiale_cle
        , situation_familiale_code
    from 
        "wh_dp_silver"."int"."int_situation_familiale"
),

cte_int_categorie_logement as
(
    select 
        categorie_logement_cle
        , categorie_logement_code
    from 
        "wh_dp_silver"."int"."int_categorie_logement"
),

cte_stg_gipsne_ref_type_logement as
(
    select 
        piece_nombre_sne_cle
        , piece_nombre_sne_code
    from 
        "wh_dp_silver"."stg"."stg_gipsne_ref_type_logement"
),

cte_map_piece_nombre_code as
(
    select 
        sne_piece_nombre_code
        , ref_piece_nombre_code
    from 
        "wh_dp_bronze"."seed"."map_piece_nombre_code"
),

cte_stg_gipsne_ref_geographie as
(
    select 
        geographie_sne_commune_cle
        , geographie_sne_commune_code
        , geographie_sne_annee
    from 
        "wh_dp_silver"."stg"."stg_gipsne_ref_geographie"
),

cte_int_arrondissement as
(
    select 
        arrondissement_code
        , commune_code
    from 
        "wh_dp_silver"."int"."int_arrondissement"
    where 
        
    case
        when (arrondissement_annee) = (
            select max((arrondissement_annee))
            from int_arrondissement
        ) then 1
        else 0
    end

            = 1
),
-------------------------------------------------------------------
--*********************** TRANSFORMATIONS *************************
-------------------------------------------------------------------
------ on recherche le piece_nombre_code de reference correspondant 
------- au type de logement (nombre de piece) du sne
cte_calc_nombre_piece_code as
(
    select 
        sne.piece_nombre_sne_cle       as piece_nombre_cle
        , map.ref_piece_nombre_code     as piece_nombre_code
    from 
        cte_stg_gipsne_ref_type_logement sne
    inner join
        cte_map_piece_nombre_code map
    on (
        sne.piece_nombre_sne_code = map.sne_piece_nombre_code
    )

),

--- transformation principale
cte_calc_stg_gipsne_stock as
(
    select 
        stg.*
        , 
    case
        when (demande_et_radiation_sne_millesime) = (
            select max((demande_et_radiation_sne_millesime))
            from cte_stg_gipsne_stock
        ) then 1
        else 0
    end

                            as demande_et_radiation_sne_millesime_last_flag
        , isnull(demande_motif.demande_motif_code,'N/A') 
                as demande_motif_premier_code 
        , isnull(statut_pro.statut_professionnel_code,'N/A') 
                as demandeur_statut_professionnel_code 
        , isnull(situation_fam.situation_familiale_code,'N/A') 
                as demandeur_situation_familiale_code
        , isnull(categ_log_act.categorie_logement_code,'N/A') 
                as logement_actuel_categorie_logement_code
        , isnull(piece_nombre_act.piece_nombre_code,'N/A') 
                as logement_actuel_piece_nombre_code
        , isnull(int_arrondissement.commune_code, geo.geographie_sne_commune_code)                                 
                as commune_code_origine
        , isnull(int_arrondissement.arrondissement_code,'N/A')                                                                              
                as arrondissement_code
        , isnull(categ_log_rech.categorie_logement_code,'N/A') 
                as logement_recherche_categorie_logement_code
         

    from 
        cte_stg_gipsne_stock stg
    left join
        cte_int_demande_motif demande_motif 
            on (stg.demande_motif_premier_cle = demande_motif.demande_motif_cle)
    left join
        cte_int_statut_professionnel statut_pro
            on (stg.demandeur_statut_professionnel_cle = statut_pro.statut_professionnel_cle)
    left join
        cte_int_situation_familiale situation_fam
            on (stg.demandeur_situation_familiale_cle = situation_fam.situation_familiale_cle)
    left join
        cte_int_categorie_logement categ_log_act
            on (stg.logement_actuel_categorie_cle = categ_log_act.categorie_logement_cle)
    left join
        cte_calc_nombre_piece_code piece_nombre_act
            on (stg.logement_actuel_piece_nombre_cle = piece_nombre_act.piece_nombre_cle)
    --- logement_actuel_commune peut être soit une commune, soit un arrondissement
    left join
        cte_stg_gipsne_ref_geographie geo
            on (stg.logement_actuel_commune_cle = geo.geographie_sne_commune_cle)
            left join 
                cte_int_arrondissement int_arrondissement
                    on (geo.geographie_sne_commune_code = int_arrondissement.arrondissement_code)                 
    left join
        cte_int_categorie_logement categ_log_rech
            on (stg.logement_recherche_categorie_cle = categ_log_rech.categorie_logement_cle)

),
 

--ajout des clés techniques
cte_hk_calc_stg_gipsne_stock as
(
    select 
        *
    from 
        cte_calc_stg_gipsne_stock
),

-------------------------------------------------------------------
--*********************** ETAPE FINALE *************************
-------------------------------------------------------------------
cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc_stg_gipsne_stock
 )

 
select 
    *
from 
    cte_finale