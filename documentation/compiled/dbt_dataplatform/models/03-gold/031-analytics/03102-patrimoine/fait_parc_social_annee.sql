/**
 *
 * Description :    Alimentation de la table de fait parc social
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          int_logement_rpls
 * Cible :          logement_rpls  

 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
 
cte_logement_rpls as
(
    select
        logement_rpls_hk
        -- ANNEE
        ,logement_rpls_millesime_date   
        ,construction_anciennete_en_annee 
        ,construction_achevement_annee 
        -- FLAG
        ,qpv_flag
        ,mise_en_service_flag
        ,sem_non_convention_flag
        ,logement_loyer_libre_flag
        ,bail_effet_annee_prec_flag
        ,bail_fin_annee_prec_flag
        ,emmenagement_flag
        -- SURFACE
        ,surface_habitable_m2
        -- MONTANT
        ,loyer_principal_mensuel_montant
        -- CODE
        ,piece_nombre_code
        ,dpe_energie_code
        ,dpe_ges_code
        ,patrimoine_sortie_code     as patrimoine_sortie_code_source
        ,vente_type_code      
        ,commune_code               as commune_code_source
        ,organisme_famille_rpls_code
        ,financement_groupe_code
        ,occupation_mode_code
        ,construction_type_code
        ,patrimoine_origine_code
        ,pmr_code                    
        -- HK
        ,financement_groupe_hk
        ,patrimoine_origine_hk
        ,dpe_ges_hk
        ,dpe_energie_hk    
        ,occupation_mode_hk  
        ,construction_type_hk   
        ,organisme_famille_hk
        ,piece_nombre_hk
        ,pmr_hk                      
         

    from
        "wh_dp_silver"."dbo"."logement_rpls"

),

cte_map_patrimoine_sortie as 
(
    select
        patrimoine_sortie_code_silver
        , vente_type_code_silver
        , patrimoine_sortie_code_gold
        , patrimoine_sortie_gold_libelle

    from    
        "wh_dp_bronze"."seed"."map_patrimoine_sortie"
),

cte_passage_commune_histo as
(
    select 
        passage_commune_annee
        , passage_commune_annee_last_flag
        , commune_initiale_code
        , commune_finale_code
    from
        "wh_dp_silver"."dbo"."passage_commune_histo"
),

-- la dimension commune contient la dernière version  
cte_commune as 
(
    select 
        commune_annee,
        commune_code,
        commune_hk,
        departement_code,
        departement_hk,
        epci_code,
        epci_hk,
        ept_code,
        ept_hk,
        zone_123_code,
        zone_123_hk,
        zone_abc_code,
        zone_abc_hk
    from 
        "wh_dp_gold"."dbo"."dim_commune"
),

-- la dimension departement contient la dernière version  
cte_departement as 
(
    select 
        departement_hk, 
        region_hk,
        region_code
    from 
        "wh_dp_gold"."dbo"."dim_departement"
),

-- la dimension region contient la dernière version
cte_region as
(
    select 
        region_hk,
        region_outre_mer_flag
     from 
        "wh_dp_gold"."dbo"."dim_region"
),


cte_ref_dataplatform as
(
    select 
        
        objet
        , code 
        , val1
        , val2
    from 
        "wh_dp_bronze"."seed"."ref_dataplatform"

),
-------------------------------------------------------------------
--*************************** FILTRES *****************************
-------------------------------------------------------------------

 --recuperation de la dernière version des passages communes
 cte_passage_commune_histo_last as
 (
    select
        *
    from cte_passage_commune_histo
    where 
        passage_commune_annee_last_flag = 1
       
 ),

 
cte_dim_construction_periode as 
(
    select 
        code
        , val1
        , val2
    from 
        cte_ref_dataplatform
    where 
        objet = 'dim_construction_periode'

),



-------------------------------------------------------------------
--************************* TRAITEMENTS ***************************
-------------------------------------------------------------------

 cte_commune_fusionnee as
(
select  commune_initiale_code,
        commune_finale_code
from  cte_passage_commune_histo_last base
where not exists (select 1 
      
      from cte_passage_commune_histo_last cte_passage_commune_histo
      where
           base.commune_initiale_code = cte_passage_commune_histo.commune_finale_code
            )
),

-- Préparation des axes d'analyses
cte_transform_logement_rpls as
(
    select
        cte_logement_rpls.*
        -- Règle de détermination du code commune :
        -- 1. Si le code commune du RPLS est présent dans le champ "commune_finale" de la table de passage,
        --    alors on conserve ce code (le code n’a pas changé, ex : scission).
        -- 2. Sinon, on recherche dans la table de passage la ligne où :
        --       "commune_initiale" = code commune du RPLS,
        --    et on récupère le code "commune_finale" correspondant (le code a changé, ex : fusion).
        --
        -- Autrement dit :
        -- - En cas de **scission**, la commune garde son code d’origine.
        -- - En cas de **fusion**, la commune prend le nouveau code issu de la table de passage.
        , case when exists (select 1 
                            from  cte_logement_rpls   
                            inner join cte_passage_commune_histo
                            on (
                                cte_logement_rpls.commune_code_source = cte_passage_commune_histo.commune_finale_code
                                and  cte_passage_commune_histo.passage_commune_annee_last_flag = 1
                            ))
                    then cte_logement_rpls.commune_code_source  
                else cte_commune_fusionnee.commune_initiale_code  
        end as commune_code
        , isnull(cte_map_patrimoine_sortie.patrimoine_sortie_code_gold, 'N/A')   as patrimoine_sortie_code
        , isnull(cte_dim_construction_periode.code, 'N/A')                       as construction_periode_code
    from 
        cte_logement_rpls   
    left join
        cte_map_patrimoine_sortie on (
            cte_logement_rpls.patrimoine_sortie_code_source = cte_map_patrimoine_sortie.patrimoine_sortie_code_silver
            and (
                cte_map_patrimoine_sortie.vente_type_code_silver = '-'
                or
                cte_logement_rpls.vente_type_code = cte_map_patrimoine_sortie.vente_type_code_silver 
                )
                                            
        )
     left join 
        cte_dim_construction_periode on (
            year(cte_logement_rpls.construction_achevement_annee) between cte_dim_construction_periode.val1 and cte_dim_construction_periode.val2

        )
    left join 
    cte_commune_fusionnee as cte_commune_fusionnee on (     
        cte_logement_rpls.commune_code_source =   cte_commune_fusionnee.commune_initiale_code
        
    )
    

),

-- On ajoute les informations de la commune
cte_infos_commune_logement_rpls as
(
    select 
        cte_transform_logement_rpls.*
        , cte_commune.commune_annee as geographie_annee
        , cte_commune.commune_hk
        , cte_commune.departement_code
        , cte_commune.departement_hk
        , cte_commune.epci_code
        , cte_commune.epci_hk
        , cte_commune.ept_code
        , cte_commune.ept_hk
        , cte_departement.region_code
        , cte_departement.region_hk
        , cte_region.region_outre_mer_flag
        , cte_commune.zone_123_code
        , cte_commune.zone_123_hk
        , cte_commune.zone_abc_code
        , cte_commune.zone_abc_hk
 
    from 
        cte_transform_logement_rpls
    inner join cte_commune
    on (cte_transform_logement_rpls.commune_code = cte_commune.commune_code )
    inner join cte_departement
    on (cte_commune.departement_hk = cte_departement.departement_hk)
    inner join cte_region
    on (cte_departement.region_hk = cte_region.region_hk)
),

-- Exlusion des SEM non conventionnées (excepté pour les DOM-TOM) et des logements à loyer libre
cte_filtre_logement_rpls as
(
    select 
        *
    from
        cte_infos_commune_logement_rpls
    where 
        (
            (sem_non_convention_flag <> 1 or region_outre_mer_flag = 1)
            and
            logement_loyer_libre_flag <> 1
             

        )
        
),
 
-- Calcul des indicateurs et aggrégation
 cte_calc_logement_rpls as 
 (
    select
        logement_rpls_millesime_date                                            as rpls_annee
        , commune_code 
        , departement_code
        , region_code   
        , epci_code
        , ept_code
        , zone_123_code
        , zone_abc_code
        , piece_nombre_code                                                      
        , qpv_flag    
        , bail_effet_annee_prec_flag        
        , bail_fin_annee_prec_flag     
        , emmenagement_flag
        , mise_en_service_flag               
        , financement_groupe_code
        , dpe_energie_code
        , dpe_ges_code
        , patrimoine_origine_code
        , construction_type_code
        , occupation_mode_code
        , patrimoine_sortie_code                                                                                                                                                    
        , construction_periode_code   
        , organisme_famille_rpls_code     
        , pmr_code                                       
        , sum(construction_anciennete_en_annee)                                 as construction_anciennete_en_annee
        , count(logement_rpls_hk)                                               as logement_total_nombre
        , sum(surface_habitable_m2)                                             as surface_habitable_m2
        , sum(loyer_principal_mensuel_montant)                                  as loyer_principal_mensuel_montant
        , dpe_energie_hk
        , dpe_ges_hk
        , commune_hk
        , patrimoine_origine_hk
        , construction_type_hk
        , occupation_mode_hk 
        , financement_groupe_hk
        , piece_nombre_hk
        , organisme_famille_hk
        , departement_hk
        , region_hk  
        , epci_hk
        , ept_hk
        , zone_123_hk
        , zone_abc_hk
        , pmr_hk
    

    from 
        cte_filtre_logement_rpls
    
    group by
        logement_rpls_millesime_date                                                     
        , commune_code 
        , departement_code
        , region_code   
        , epci_code
        , ept_code
        , zone_123_code
        , zone_abc_code
        , piece_nombre_code                                                      
        , qpv_flag       
        , bail_effet_annee_prec_flag        
        , bail_fin_annee_prec_flag  
        , emmenagement_flag
        , mise_en_service_flag                                                 
        , financement_groupe_code
        , dpe_energie_code
        , dpe_ges_code
        , patrimoine_origine_code
        , construction_type_code
        , occupation_mode_code
        , patrimoine_sortie_code                                                                                                                                                    
        , construction_periode_code   
        , organisme_famille_rpls_code
        , pmr_code
        , dpe_energie_hk
        , dpe_ges_hk
        , patrimoine_origine_hk
        , construction_type_hk
        , occupation_mode_hk 
        , financement_groupe_hk
        , piece_nombre_hk
        , organisme_famille_hk
        , commune_hk
        , departement_hk
        , region_hk  
        , epci_hk
        , ept_hk
        , zone_123_hk
        , zone_abc_hk
        , pmr_hk

 ),

 -- Calcul des clés techniques pour celles qui ne sont pas directement récupérées de la couche silver
cte_hk_calc_logement_rpls as
 (
    select     
        cte_calc_logement_rpls.*

    ,   
     
        HASHBYTES('SHA2_256', 
    
        cast(patrimoine_sortie_code as varchar(max))
    
)  
 
    as patrimoine_sortie_hk
    ,   
     
        HASHBYTES('SHA2_256', 
    
        cast(construction_periode_code as varchar(max))
    
)  
 
 as construction_periode_hk
    from 
        cte_calc_logement_rpls
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
    from
        cte_hk_calc_logement_rpls
)

select 
    *
from 
    cte_finale