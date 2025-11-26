
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."logement_rpls__dbt_temp__dbt_tmp_vw" as 


with

 cte_int_rpls_logement as 
 (
    select 
        logement_rpls_bk,
        logement_rpls_hk,
        logement_rpls_millesime,
        logement_rpls_millesime_date,
        logement_rpls_millesime_last_flag,
        logement_rpls_id,
        logement_bailleur_systeme_id,
        organisme_id,
        organisme_categorie_code,
        organisme_raison_sociale_libelle,
        organisme_siret_code,
        organisme_famille_rpls_code,
        organisme_siren_code,
        commune_code,
        arrondissement_code,
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
        immobilier_droit_code,
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
        pmr_code,
        vente_autorisation_mois,
        vente_effective_mois,
        locataire_dernier_depart_date,
        dpe_energie_consommation_valeur,
        dpe_ges_consommation_valeur,
        dpe_reference_num,
        logement_fiscal_id,
        emmenagement_flag,
        sem_non_convention_flag,
        logement_loyer_libre_flag,
        mise_en_service_flag,
        bail_effet_annee_prec_flag,
        bail_fin_annee_prec_flag,
        financement_groupe_code,
        construction_anciennete_en_annee,
        occupation_mode_hk,
        financement_initial_hk,
        financement_groupe_hk,
        commune_hk,
        arrondissement_hk,
        organisme_famille_hk,
        organisme_categorie_hk,
        pmr_hk,
        piece_nombre_hk,
        surface_mode_hk,
        dpe_energie_hk,
        dpe_ges_hk,
        vente_type_hk,
        patrimoine_sortie_hk,
        patrimoine_origine_hk,
        construction_type_hk,
        immobilier_droit_hk
 
    from 
        "wh_dp_silver"."int"."int_logement_rpls"
 )
,

 cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_int_rpls_logement
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."dbo"."logement_rpls__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."logement_rpls__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  